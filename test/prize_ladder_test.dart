import 'package:flutter_test/flutter_test.dart';
import 'package:urna/models/prize_ladder.dart';
import 'package:urna/models/question.dart';

void main() {
  group('PrizeLadder', () {
    test('a escada termina em 1.000.000 de coins', () {
      expect(PrizeLadder.steps.last.coins, PrizeLadder.millionGoal);
    });

    test('possui ao menos um checkpoint antes do prêmio máximo', () {
      final checkpoints =
          PrizeLadder.steps.where((s) => s.isCheckpoint).toList();
      expect(checkpoints, isNotEmpty);
    });

    test('coins garantidos caem para o último checkpoint ao errar', () {
      // Antes de qualquer checkpoint, não há garantia.
      expect(PrizeLadder.guaranteedCoinsAt(0), 0);
      // No degrau 5 (0-based), o checkpoint de 10.000 (índice 4) já passou.
      expect(PrizeLadder.guaranteedCoinsAt(5), 10000);
      // No último degrau, o checkpoint de 100.000 (índice 8) está garantido.
      expect(PrizeLadder.guaranteedCoinsAt(PrizeLadder.totalSteps - 1), 100000);
    });
  });

  group('Question', () {
    test('faz parse do JSON corretamente', () {
      final q = Question.fromJson({
        'id': 1,
        'difficulty': 'medio',
        'question': 'Pergunta?',
        'options': ['a', 'b', 'c', 'd'],
        'correctIndex': 2,
        'reference': 'Gn 1:1',
        'explanation': 'ok',
      });
      expect(q.id, 1);
      expect(q.difficulty, Difficulty.medio);
      expect(q.options.length, 4);
      expect(q.isCorrect(2), isTrue);
      expect(q.isCorrect(0), isFalse);
    });
  });
}
