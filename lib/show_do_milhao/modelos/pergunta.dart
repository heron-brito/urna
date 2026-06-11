enum Dificuldade { facil, media, dificil }

class Pergunta {
  const Pergunta({
    required this.enunciado,
    required this.alternativas,
    required this.indiceCorreta,
    required this.dificuldade,
  }) : assert(alternativas.length == 4),
       assert(indiceCorreta >= 0 && indiceCorreta < 4);

  /// Cria uma pergunta a partir de um item do arquivo
  /// `assets/dados/perguntas.json`.
  factory Pergunta.fromJson(Map<String, dynamic> json) {
    return Pergunta(
      enunciado: json['enunciado'] as String,
      alternativas: List<String>.from(json['alternativas'] as List),
      indiceCorreta: json['correta'] as int,
      dificuldade: _dificuldadeDeTexto(json['dificuldade'] as String),
    );
  }

  final String enunciado;
  final List<String> alternativas;
  final int indiceCorreta;
  final Dificuldade dificuldade;

  static Dificuldade _dificuldadeDeTexto(String texto) {
    switch (texto) {
      case 'facil':
        return Dificuldade.facil;
      case 'media':
        return Dificuldade.media;
      case 'dificil':
        return Dificuldade.dificil;
    }
    throw FormatException('Dificuldade desconhecida: $texto');
  }
}
