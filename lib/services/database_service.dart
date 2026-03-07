import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/quiz_session_model.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'lumina_quiz.db');

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createTables,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await _createGamificationTables(db);
    }
  }

  Future<void> _createTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE QuizSessions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        category TEXT NOT NULL,
        score INTEGER NOT NULL,
        total_questions INTEGER NOT NULL DEFAULT 20,
        date DATETIME NOT NULL,
        duration_seconds INTEGER NOT NULL DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE Mistakes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        session_id INTEGER NOT NULL,
        question TEXT NOT NULL,
        user_choice TEXT NOT NULL,
        correct_answer TEXT NOT NULL,
        hint TEXT DEFAULT '',
        FOREIGN KEY (session_id) REFERENCES QuizSessions (id)
      )
    ''');

    await db.execute(
        'CREATE INDEX idx_sessions_date ON QuizSessions (date DESC)');
    await db.execute(
        'CREATE INDEX idx_sessions_category ON QuizSessions (category)');
    await db.execute(
        'CREATE INDEX idx_mistakes_session ON Mistakes (session_id)');

    await _createGamificationTables(db);
  }

  Future<void> _createGamificationTables(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS UserProfile (
        id INTEGER PRIMARY KEY DEFAULT 1,
        total_xp INTEGER NOT NULL DEFAULT 0,
        streak_days INTEGER NOT NULL DEFAULT 0,
        last_quiz_date TEXT,
        last_challenge_date TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS AwardedBadges (
        badge_id TEXT PRIMARY KEY,
        awarded_at TEXT NOT NULL
      )
    ''');

    await db.rawInsert(
        'INSERT OR IGNORE INTO UserProfile (id, total_xp, streak_days) VALUES (1, 0, 0)');
  }

  Future<int> insertSession(QuizSession session) async {
    final db = await database;
    return await db.insert('QuizSessions', session.toMap());
  }

  Future<void> insertMistakes(List<Mistake> mistakes) async {
    final db = await database;
    final batch = db.batch();
    for (final m in mistakes) {
      batch.insert('Mistakes', m.toMap());
    }
    await batch.commit(noResult: true);
  }

  Future<List<QuizSession>> getAllSessions() async {
    final db = await database;
    final maps = await db.query(
      'QuizSessions',
      orderBy: 'date DESC',
    );
    return maps.map((m) => QuizSession.fromMap(m)).toList();
  }

  Future<List<Mistake>> getMistakesForSession(int sessionId) async {
    final db = await database;
    final maps = await db.query(
      'Mistakes',
      where: 'session_id = ?',
      whereArgs: [sessionId],
    );
    return maps.map((m) => Mistake.fromMap(m)).toList();
  }

  Future<Map<String, dynamic>> getStats() async {
    final db = await database;

    final totalResult =
        await db.rawQuery('SELECT COUNT(*) as count FROM QuizSessions');
    final total = totalResult.first['count'] as int? ?? 0;

    final avgResult = await db.rawQuery(
        'SELECT AVG(CAST(score AS FLOAT) / total_questions * 100) as avg FROM QuizSessions');
    final avg = avgResult.first['avg'] as double? ?? 0.0;

    final bestResult = await db.rawQuery(
        'SELECT MAX(CAST(score AS FLOAT) / total_questions * 100) as best FROM QuizSessions');
    final best = bestResult.first['best'] as double? ?? 0.0;

    return {
      'totalSessions': total,
      'averagePercent': avg,
      'bestPercent': best,
    };
  }

  Future<void> deleteSession(int id) async {
    final db = await database;
    await db.delete('Mistakes', where: 'session_id = ?', whereArgs: [id]);
    await db.delete('QuizSessions', where: 'id = ?', whereArgs: [id]);
  }

  // --- Gamification ---

  Future<Map<String, dynamic>> getUserProfile() async {
    final db = await database;
    final rows = await db.query('UserProfile', where: 'id = 1');
    if (rows.isEmpty) {
      await db.rawInsert(
          'INSERT OR IGNORE INTO UserProfile (id, total_xp, streak_days) VALUES (1, 0, 0)');
      return {'total_xp': 0, 'streak_days': 0, 'last_quiz_date': null, 'last_challenge_date': null};
    }
    return rows.first;
  }

  Future<void> addXP(int amount) async {
    final db = await database;
    await db.rawUpdate(
        'UPDATE UserProfile SET total_xp = total_xp + ? WHERE id = 1',
        [amount]);
  }

  Future<void> updateStreak(String todayIso) async {
    final db = await database;
    final profile = await getUserProfile();
    final lastDate = profile['last_quiz_date'] as String?;

    int newStreak = 1;
    if (lastDate != null) {
      final last = DateTime.parse(lastDate);
      final today = DateTime.parse(todayIso);
      final diff = today.difference(last).inDays;
      if (diff == 1) {
        newStreak = (profile['streak_days'] as int? ?? 0) + 1;
      } else if (diff == 0) {
        newStreak = profile['streak_days'] as int? ?? 1;
      }
    }

    await db.rawUpdate(
        'UPDATE UserProfile SET streak_days = ?, last_quiz_date = ? WHERE id = 1',
        [newStreak, todayIso]);
  }

  Future<void> recordChallengeDate(String todayIso) async {
    final db = await database;
    await db.rawUpdate(
        'UPDATE UserProfile SET last_challenge_date = ? WHERE id = 1',
        [todayIso]);
  }

  Future<Set<String>> getAwardedBadgeIds() async {
    final db = await database;
    final rows = await db.query('AwardedBadges');
    return rows.map((r) => r['badge_id'] as String).toSet();
  }

  Future<bool> awardBadge(String badgeId) async {
    final db = await database;
    try {
      await db.insert('AwardedBadges', {
        'badge_id': badgeId,
        'awarded_at': DateTime.now().toIso8601String(),
      });
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<Map<String, double>> getCategoryAverages() async {
    final db = await database;
    final rows = await db.rawQuery('''
      SELECT category,
             AVG(CAST(score AS FLOAT) / total_questions * 100) as avg_pct,
             COUNT(*) as test_count
      FROM QuizSessions
      GROUP BY category
    ''');
    return {for (final r in rows) r['category'] as String: (r['avg_pct'] as double? ?? 0).roundToDouble()};
  }

  Future<int> getTotalCorrect() async {
    final db = await database;
    final result = await db.rawQuery('SELECT SUM(score) as total FROM QuizSessions');
    return result.first['total'] as int? ?? 0;
  }

  Future<Map<String, int>> getCategoryTestCounts() async {
    final db = await database;
    final rows = await db.rawQuery('''
      SELECT category, COUNT(*) as cnt FROM QuizSessions GROUP BY category
    ''');
    return {for (final r in rows) r['category'] as String: r['cnt'] as int};
  }
}
