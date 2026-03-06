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
      version: 1,
      onCreate: _createTables,
    );
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
}
