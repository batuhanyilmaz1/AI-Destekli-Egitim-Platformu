class QuizQuestion {
  final String question;
  final List<String> options;
  final String answer;
  final String hint;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.answer,
    required this.hint,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      question: json['question']?.toString() ?? '',
      options: List<String>.from(json['options'] ?? []),
      answer: json['answer']?.toString() ?? '',
      hint: json['hint']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'question': question,
        'options': options,
        'answer': answer,
        'hint': hint,
      };
}

class QuizCategory {
  final String id;
  final String name;
  final String emoji;
  final String description;
  final String colorHex;
  final String bgColorHex;

  const QuizCategory({
    required this.id,
    required this.name,
    required this.emoji,
    required this.description,
    required this.colorHex,
    required this.bgColorHex,
  });

  static const List<QuizCategory> all = [
    QuizCategory(
      id: 'fen',
      name: 'Fen Bilimleri',
      emoji: '🔬',
      description: 'Fizik, kimya ve biyoloji — tek çatı altında',
      colorHex: '6B9BD1',
      bgColorHex: 'E3EEF9',
    ),
    QuizCategory(
      id: 'cs',
      name: 'Bilgisayar & Programlama',
      emoji: '💻',
      description: 'Algoritmalar, veri yapıları ve kodlama',
      colorHex: 'E8A45A',
      bgColorHex: 'FAEBD6',
    ),
    QuizCategory(
      id: 'english',
      name: 'İngilizce',
      emoji: '🇬🇧',
      description: 'Gramer, kelime bilgisi ve okuma',
      colorHex: 'CC9494',
      bgColorHex: 'F5E0E0',
    ),
    QuizCategory(
      id: 'math',
      name: 'Matematik',
      emoji: '📐',
      description: 'Sayılar, denklemler, geometri ve problem çözme',
      colorHex: '6BAF92',
      bgColorHex: 'D4EDE3',
    ),
    QuizCategory(
      id: 'turkish',
      name: 'Türkçe',
      emoji: '📝',
      description: 'Dil bilgisi, anlam, paragraf ve yazım kuralları',
      colorHex: 'C4845A',
      bgColorHex: 'F5DDD0',
    ),
    QuizCategory(
      id: 'history',
      name: 'Tarih',
      emoji: '🏛️',
      description: 'Türk tarihi, dünya tarihi ve medeniyetler',
      colorHex: 'A07850',
      bgColorHex: 'EEE0CA',
    ),
  ];
}
