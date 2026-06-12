import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart' show rootBundle;

import '../models/question.dart';

/// Carrega as perguntas do arquivo JSON e sorteia uma pergunta por
/// dificuldade, sem repetir as já usadas na partida.
class QuestionRepository {
  static const String _assetPath = 'assets/data/questions.json';

  final Random _random;
  List<Question> _all = const [];

  QuestionRepository({Random? random}) : _random = random ?? Random();

  bool get isLoaded => _all.isNotEmpty;

  Future<void> load() async {
    if (_all.isNotEmpty) return;
    final raw = await rootBundle.loadString(_assetPath);
    final data = json.decode(raw) as Map<String, dynamic>;
    final list = (data['questions'] as List<dynamic>)
        .map((e) => Question.fromJson(e as Map<String, dynamic>))
        .toList();
    _all = list;
  }

  /// Sorteia uma pergunta da [difficulty] indicada que não esteja em
  /// [usedIds]. Se acabarem as da dificuldade pedida, recorre a qualquer
  /// pergunta ainda não usada.
  Question? pick(Difficulty difficulty, Set<int> usedIds) {
    final preferred = _all
        .where((q) => q.difficulty == difficulty && !usedIds.contains(q.id))
        .toList();
    if (preferred.isNotEmpty) {
      return preferred[_random.nextInt(preferred.length)];
    }
    final fallback = _all.where((q) => !usedIds.contains(q.id)).toList();
    if (fallback.isEmpty) return null;
    return fallback[_random.nextInt(fallback.length)];
  }
}
