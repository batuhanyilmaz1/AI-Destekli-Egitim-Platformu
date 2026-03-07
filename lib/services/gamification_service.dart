import '../models/gamification_model.dart';
import 'database_service.dart';

class GamificationService {
  final _db = DatabaseService();

  Future<UserProfile> getProfile() async {
    final raw = await _db.getUserProfile();
    final badgeIds = await _db.getAwardedBadgeIds();
    return UserProfile(
      totalXp: raw['total_xp'] as int? ?? 0,
      streakDays: raw['streak_days'] as int? ?? 0,
      lastQuizDate: raw['last_quiz_date'] != null
          ? DateTime.tryParse(raw['last_quiz_date'] as String)
          : null,
      lastChallengeDate: raw['last_challenge_date'] != null
          ? DateTime.tryParse(raw['last_challenge_date'] as String)
          : null,
      unlockedBadgeIds: badgeIds,
    );
  }

  /// Awards XP, updates streak, checks badges. Returns newly awarded badge IDs.
  Future<List<BadgeId>> onQuizComplete({
    required String category,
    required int score,
    required int total,
    required String difficultyLabel,
    bool isChallenge = false,
  }) async {
    final xpEarned = XPLevel.calculateEarned(score, total, difficultyLabel);
    await _db.addXP(xpEarned);

    final today = _todayIso();
    if (!isChallenge) {
      await _db.updateStreak(today);
    } else {
      await _db.recordChallengeDate(today);
    }

    return _checkAndAwardBadges(
      category: category,
      score: score,
      total: total,
      difficultyLabel: difficultyLabel,
      isChallenge: isChallenge,
    );
  }

  Future<void> onStudyBookOpened() async {
    await _awardIfNew(BadgeId.studious);
  }

  Future<void> onFlashcardOpened() async {
    await _awardIfNew(BadgeId.flashcardFan);
  }

  Future<List<BadgeId>> _checkAndAwardBadges({
    required String category,
    required int score,
    required int total,
    required String difficultyLabel,
    required bool isChallenge,
  }) async {
    final awarded = <BadgeId>[];

    // Tüm DB sorgularını paralel çalıştır
    final results = await Future.wait<dynamic>([
      _db.getAwardedBadgeIds(),
      _db.getStats(),
      _db.getCategoryTestCounts(),
      _db.getTotalCorrect(),
      _db.getUserProfile(),
    ]);

    final existing = results[0] as Set<String>;
    final stats = results[1] as Map<String, dynamic>;
    final catCounts = results[2] as Map<String, int>;
    final totalCorrect = results[3] as int;
    final profile = results[4] as Map<String, dynamic>;

    final streak = profile['streak_days'] as int? ?? 0;
    final challengeCount = profile['challenge_count'] as int? ?? 0;

    Future<void> tryAward(BadgeId id) async {
      if (!existing.contains(id.name)) {
        final ok = await _db.awardBadge(id.name);
        if (ok) awarded.add(id);
      }
    }

    final totalSessions = stats['totalSessions'] as int? ?? 0;

    // İlk quiz
    if (totalSessions >= 1) await tryAward(BadgeId.firstQuiz);

    // Test sayısı
    if (totalSessions >= 10) await tryAward(BadgeId.sessions10);
    if (totalSessions >= 25) await tryAward(BadgeId.sessions25);

    // Tam puan
    if (score == total) await tryAward(BadgeId.perfectScore);

    // Zorluk
    if (difficultyLabel == 'Zor') await tryAward(BadgeId.hardChallenger);
    if (difficultyLabel == 'Kolay' && score == total) await tryAward(BadgeId.easyWin);

    // Seri
    if (streak >= 3) await tryAward(BadgeId.streak3);
    if (streak >= 7) await tryAward(BadgeId.streak7);
    if (streak >= 14) await tryAward(BadgeId.streak14);

    // Günlük görev
    if (isChallenge) await tryAward(BadgeId.dailyChallenger);
    if (challengeCount >= 7) await tryAward(BadgeId.dailyChallenge7);

    // Toplam doğru
    if (totalCorrect >= 100) await tryAward(BadgeId.correct100);
    if (totalCorrect >= 500) await tryAward(BadgeId.correct500);
    if (totalCorrect >= 1000) await tryAward(BadgeId.correct1000);

    // Gece kuşu
    final hour = DateTime.now().hour;
    if (hour >= 22 || hour < 4) await tryAward(BadgeId.nightOwl);

    // Kategori rozetleri
    final catCount = catCounts[category] ?? 0;
    if (catCount >= 3) {
      if (category.contains('Fizik')) await tryAward(BadgeId.physicist);
      if (category.contains('Kimya')) await tryAward(BadgeId.chemist);
      if (category.contains('Biyoloji')) await tryAward(BadgeId.biologist);
      if (category.contains('Bilgisayar')) await tryAward(BadgeId.programmer);
      if (category.contains('İngilizce')) await tryAward(BadgeId.linguist);
      if (category.contains('Matematik')) await tryAward(BadgeId.mathematician);
      if (category.contains('Türkçe')) await tryAward(BadgeId.turkishMaster);
      if (category.contains('Tarih')) await tryAward(BadgeId.historian);
    }

    // Tüm kategoriler
    final allCatKeywords = ['Fizik', 'Kimya', 'Biyoloji', 'Bilgisayar', 'İngilizce', 'Matematik', 'Türkçe', 'Tarih'];
    final testedCats = catCounts.keys.toList();
    final allTested = allCatKeywords.every((c) => testedCats.any((t) => t.contains(c)));
    if (allTested) await tryAward(BadgeId.allCategories);

    return awarded;
  }

  Future<void> _awardIfNew(BadgeId id) async {
    final existing = await _db.getAwardedBadgeIds();
    if (!existing.contains(id.name)) {
      await _db.awardBadge(id.name);
    }
  }

  String _todayIso() {
    final n = DateTime.now();
    return '${n.year}-${n.month.toString().padLeft(2, '0')}-${n.day.toString().padLeft(2, '0')}';
  }
}
