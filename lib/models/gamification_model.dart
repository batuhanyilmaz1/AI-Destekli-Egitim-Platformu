enum BadgeId {
  firstQuiz,
  perfectScore,
  hardChallenger,
  streak3,
  streak7,
  streak14,
  correct100,
  correct500,
  correct1000,
  physicist,
  chemist,
  biologist,
  programmer,
  linguist,
  mathematician,
  turkishMaster,
  historian,
  allCategories,
  studious,
  flashcardFan,
  dailyChallenger,
  dailyChallenge7,
  speedQuiz,
  nightOwl,
  easyWin,
  sessions10,
  sessions25,
}

class BadgeInfo {
  final BadgeId id;
  final String emoji;
  final String title;
  final String description;
  final bool isSecret;

  const BadgeInfo({
    required this.id,
    required this.emoji,
    required this.title,
    required this.description,
    this.isSecret = false,
  });

  static const List<BadgeInfo> all = [
    // — Başlangıç —
    BadgeInfo(id: BadgeId.firstQuiz, emoji: '🌱', title: 'İlk Adım',
        description: 'İlk testini tamamladın. Öğrenme yolculuğun başladı!'),
    BadgeInfo(id: BadgeId.studious, emoji: '📖', title: 'Araştırmacı',
        description: 'Çalışma kitapçığını açtın. Bilgiye açsın!'),
    BadgeInfo(id: BadgeId.flashcardFan, emoji: '🃏', title: 'Kart Ustası',
        description: 'Flashcard modunu açtın. Görsel öğrenme harika!'),
    // — Başarı —
    BadgeInfo(id: BadgeId.perfectScore, emoji: '💯', title: 'Tam Puan',
        description: 'Bir testte tüm 20 soruyu doğru cevapladın. Muhteşem!'),
    BadgeInfo(id: BadgeId.hardChallenger, emoji: '🔥', title: 'Zorluk Avcısı',
        description: 'Zor seviyede bir test tamamladın. Gerçekten cesursun!'),
    BadgeInfo(id: BadgeId.easyWin, emoji: '😊', title: 'Kolay Başlangıç',
        description: 'Kolay seviyede %100 aldın. Şimdi bir üst seviyeye geç!'),
    BadgeInfo(id: BadgeId.speedQuiz, emoji: '⚡', title: 'Hız Şampiyonu',
        description: '5 dakika içinde bir testi bitirdin. Inanılmaz hız!'),
    // — Seri —
    BadgeInfo(id: BadgeId.streak3, emoji: '🌤️', title: '3 Gün Serisi',
        description: '3 gün art arda test çözdün. Harika bir alışkanlık!'),
    BadgeInfo(id: BadgeId.streak7, emoji: '🔆', title: '7 Gün Serisi',
        description: 'Bir haftadır her gün çalışıyorsun. Sen bir şampiyon!'),
    BadgeInfo(id: BadgeId.streak14, emoji: '🌟', title: '14 Gün Serisi',
        description: 'İki hafta kesintisiz çalışma. İnanılmaz bir azim!'),
    // — Günlük Görev —
    BadgeInfo(id: BadgeId.dailyChallenger, emoji: '🎯', title: 'Günlük Kahraman',
        description: 'İlk günlük görevini tamamladın. Böyle devam!'),
    BadgeInfo(id: BadgeId.dailyChallenge7, emoji: '🏅', title: '7 Günlük Görev',
        description: '7 günlük görevi tamamladın. Gerçek bir disiplin!'),
    // — Doğru Sayısı —
    BadgeInfo(id: BadgeId.correct100, emoji: '💪', title: '100 Doğru',
        description: 'Toplamda 100 soruyu doğru yanıtladın.'),
    BadgeInfo(id: BadgeId.correct500, emoji: '🏆', title: '500 Doğru',
        description: 'Toplamda 500 doğru cevap. Sen artık bir efsanesin!'),
    BadgeInfo(id: BadgeId.correct1000, emoji: '👑', title: '1000 Doğru',
        description: '1000 doğru cevap! Bu oyunun tartışmasız efsanesi!'),
    // — Test Sayısı —
    BadgeInfo(id: BadgeId.sessions10, emoji: '📚', title: '10 Test',
        description: 'Toplamda 10 test tamamladın. Devam et!'),
    BadgeInfo(id: BadgeId.sessions25, emoji: '🎓', title: '25 Test',
        description: 'Toplamda 25 test! Artık gerçek bir öğrenci oldun.'),
    // — Kategori Uzmanları —
    BadgeInfo(id: BadgeId.physicist, emoji: '⚛️', title: 'Fizik Meraklısı',
        description: 'Fizik kategorisinde 3 test tamamladın.'),
    BadgeInfo(id: BadgeId.chemist, emoji: '🧪', title: 'Kimya Öğrencisi',
        description: 'Kimya kategorisinde 3 test tamamladın.'),
    BadgeInfo(id: BadgeId.biologist, emoji: '🌿', title: 'Biyolog',
        description: 'Biyoloji kategorisinde 3 test tamamladın.'),
    BadgeInfo(id: BadgeId.programmer, emoji: '💻', title: 'Kodcu',
        description: 'Bilgisayar & Programlama kategorisinde 3 test tamamladın.'),
    BadgeInfo(id: BadgeId.linguist, emoji: '🇬🇧', title: 'İngilizce Tutkunu',
        description: 'İngilizce kategorisinde 3 test tamamladın.'),
    BadgeInfo(id: BadgeId.mathematician, emoji: '📐', title: 'Matematikçi',
        description: 'Matematik kategorisinde 3 test tamamladın.'),
    BadgeInfo(id: BadgeId.turkishMaster, emoji: '📝', title: 'Türkçe Ustası',
        description: 'Türkçe kategorisinde 3 test tamamladın.'),
    BadgeInfo(id: BadgeId.historian, emoji: '🏛️', title: 'Tarihçi',
        description: 'Tarih kategorisinde 3 test tamamladın.'),
    // — Özel —
    BadgeInfo(id: BadgeId.allCategories, emoji: '🌍', title: 'Çok Yönlü',
        description: 'Tüm kategorilerde en az bir test tamamladın!'),
    BadgeInfo(id: BadgeId.nightOwl, emoji: '🦉', title: 'Gece Kuşu',
        description: 'Gece 22:00\'den sonra bir test tamamladın.'),
  ];

  static BadgeInfo? findById(BadgeId id) {
    try {
      return all.firstWhere((b) => b.id == id);
    } catch (_) {
      return null;
    }
  }
}

class XPLevel {
  static const List<String> _titles = [
    'Aday', 'Öğrenci', 'Keşifçi', 'Bilge', 'Usta', 'Efsane',
  ];
  static const List<int> _thresholds = [0, 100, 300, 600, 1000, 2000];

  static int getLevel(int xp) {
    for (int i = _thresholds.length - 1; i >= 0; i--) {
      if (xp >= _thresholds[i]) return i + 1;
    }
    return 1;
  }

  static String getTitle(int xp) {
    final level = getLevel(xp);
    return _titles[(level - 1).clamp(0, _titles.length - 1)];
  }

  static double getLevelProgress(int xp) {
    final level = getLevel(xp);
    if (level >= _thresholds.length) return 1.0;
    final current = _thresholds[level - 1];
    final next = _thresholds[level];
    return ((xp - current) / (next - current)).clamp(0.0, 1.0);
  }

  static int xpToNextLevel(int xp) {
    final level = getLevel(xp);
    if (level >= _thresholds.length) return 0;
    return _thresholds[level] - xp;
  }

  static int calculateEarned(int score, int total, String difficulty) {
    final perCorrect = difficulty == 'Zor' ? 15 : difficulty == 'Orta' ? 10 : 7;
    return score * perCorrect;
  }
}

class UserProfile {
  final int totalXp;
  final int streakDays;
  final DateTime? lastQuizDate;
  final DateTime? lastChallengeDate;
  final Set<String> unlockedBadgeIds;

  const UserProfile({
    this.totalXp = 0,
    this.streakDays = 0,
    this.lastQuizDate,
    this.lastChallengeDate,
    this.unlockedBadgeIds = const {},
  });

  bool get challengeDoneToday {
    if (lastChallengeDate == null) return false;
    final now = DateTime.now();
    return lastChallengeDate!.year == now.year &&
        lastChallengeDate!.month == now.month &&
        lastChallengeDate!.day == now.day;
  }

  int get level => XPLevel.getLevel(totalXp);
  String get levelTitle => XPLevel.getTitle(totalXp);
  double get levelProgress => XPLevel.getLevelProgress(totalXp);
  int get xpToNext => XPLevel.xpToNextLevel(totalXp);
}
