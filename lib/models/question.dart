/// Nível de dificuldade de uma pergunta.
enum Difficulty {
  facil,
  medio,
  dificil;

  static Difficulty fromString(String value) {
    return Difficulty.values.firstWhere(
      (d) => d.name == value,
      orElse: () => Difficulty.facil,
    );
  }

  String get label {
    switch (this) {
      case Difficulty.facil:
        return 'Fácil';
      case Difficulty.medio:
        return 'Médio';
      case Difficulty.dificil:
        return 'Difícil';
    }
  }
}

/// Representa uma pergunta do quiz gospel.
class Question {
  final int id;
  final Difficulty difficulty;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String reference;
  final String explanation;

  const Question({
    required this.id,
    required this.difficulty,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.reference,
    required this.explanation,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as int,
      difficulty: Difficulty.fromString(json['difficulty'] as String),
      question: json['question'] as String,
      options: (json['options'] as List<dynamic>).cast<String>(),
      correctIndex: json['correctIndex'] as int,
      reference: json['reference'] as String? ?? '',
      explanation: json['explanation'] as String? ?? '',
    );
  }

  bool isCorrect(int index) => index == correctIndex;
}
