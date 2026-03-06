enum DifficultyLevel {
  easy,
  medium,
  hard;

  String get label {
    switch (this) {
      case DifficultyLevel.easy:
        return 'Kolay';
      case DifficultyLevel.medium:
        return 'Orta';
      case DifficultyLevel.hard:
        return 'Zor';
    }
  }

  int get durationSeconds {
    switch (this) {
      case DifficultyLevel.easy:
        return 300; // 5 dakika
      case DifficultyLevel.medium:
        return 600; // 10 dakika
      case DifficultyLevel.hard:
        return 840; // 14 dakika
    }
  }

  String get durationLabel {
    switch (this) {
      case DifficultyLevel.easy:
        return '5 dakika';
      case DifficultyLevel.medium:
        return '10 dakika';
      case DifficultyLevel.hard:
        return '14 dakika';
    }
  }

  String get emoji {
    switch (this) {
      case DifficultyLevel.easy:
        return '🟢';
      case DifficultyLevel.medium:
        return '🟡';
      case DifficultyLevel.hard:
        return '🔴';
    }
  }

  String get description {
    switch (this) {
      case DifficultyLevel.easy:
        return 'Rahat tempoda, 5 dakika süren';
      case DifficultyLevel.medium:
        return 'Normal tempo, 10 dakika süren';
      case DifficultyLevel.hard:
        return 'Hızlı düşün, 14 dakika süren';
    }
  }

  String get colorHex {
    switch (this) {
      case DifficultyLevel.easy:
        return '5CB85C';
      case DifficultyLevel.medium:
        return 'E8A45A';
      case DifficultyLevel.hard:
        return 'E8735A';
    }
  }

  String get bgColorHex {
    switch (this) {
      case DifficultyLevel.easy:
        return 'D4EDDA';
      case DifficultyLevel.medium:
        return 'FAEBD6';
      case DifficultyLevel.hard:
        return 'FADDD8';
    }
  }

  String get geminiLabel {
    switch (this) {
      case DifficultyLevel.easy:
        return 'kolay (5-6. sınıf ortaokul seviyesi, temel kavramlar)';
      case DifficultyLevel.medium:
        return 'orta (7-8. sınıf ortaokul seviyesi, kavramları biraz daha derinleştir)';
      case DifficultyLevel.hard:
        return 'zor (8. sınıf sonu ve lise giriş seviyesi, analitik sorular)';
    }
  }
}
