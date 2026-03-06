class QuizSession {
  final int? id;
  final String category;
  final int score;
  final int totalQuestions;
  final DateTime date;
  final int durationSeconds;

  QuizSession({
    this.id,
    required this.category,
    required this.score,
    required this.totalQuestions,
    required this.date,
    required this.durationSeconds,
  });

  double get percentage => totalQuestions > 0 ? score / totalQuestions : 0;

  factory QuizSession.fromMap(Map<String, dynamic> map) {
    return QuizSession(
      id: map['id'] as int?,
      category: map['category'] as String,
      score: map['score'] as int,
      totalQuestions: map['total_questions'] as int? ?? 20,
      date: DateTime.parse(map['date'] as String),
      durationSeconds: map['duration_seconds'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'category': category,
        'score': score,
        'total_questions': totalQuestions,
        'date': date.toIso8601String(),
        'duration_seconds': durationSeconds,
      };
}

class Mistake {
  final int? id;
  final int sessionId;
  final String question;
  final String userChoice;
  final String correctAnswer;
  final String hint;

  Mistake({
    this.id,
    required this.sessionId,
    required this.question,
    required this.userChoice,
    required this.correctAnswer,
    required this.hint,
  });

  factory Mistake.fromMap(Map<String, dynamic> map) {
    return Mistake(
      id: map['id'] as int?,
      sessionId: map['session_id'] as int,
      question: map['question'] as String,
      userChoice: map['user_choice'] as String,
      correctAnswer: map['correct_answer'] as String,
      hint: map['hint'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'session_id': sessionId,
        'question': question,
        'user_choice': userChoice,
        'correct_answer': correctAnswer,
        'hint': hint,
      };
}
