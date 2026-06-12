import 'question.dart';

/// Um degrau da escada de prêmios do "Quiz Gospel do Milhão".
class PrizeStep {
  /// Quantidade de coins acumulada ao acertar esta pergunta.
  final int coins;

  /// Dificuldade da pergunta sorteada para este degrau.
  final Difficulty difficulty;

  /// Degrau seguro: ao errar daqui pra cima, o jogador não perde
  /// o que já garantiu neste ponto (estilo "Show do Milhão").
  final bool isCheckpoint;

  const PrizeStep({
    required this.coins,
    required this.difficulty,
    this.isCheckpoint = false,
  });
}

/// Escada de prêmios em coins até o grande prêmio de 1.000.000.
/// São 13 perguntas com dificuldade crescente e dois pontos seguros.
class PrizeLadder {
  static const int millionGoal = 1000000;

  static const List<PrizeStep> steps = [
    PrizeStep(coins: 1000, difficulty: Difficulty.facil),
    PrizeStep(coins: 2000, difficulty: Difficulty.facil),
    PrizeStep(coins: 3000, difficulty: Difficulty.facil),
    PrizeStep(coins: 5000, difficulty: Difficulty.facil),
    PrizeStep(coins: 10000, difficulty: Difficulty.facil, isCheckpoint: true),
    PrizeStep(coins: 20000, difficulty: Difficulty.medio),
    PrizeStep(coins: 30000, difficulty: Difficulty.medio),
    PrizeStep(coins: 50000, difficulty: Difficulty.medio),
    PrizeStep(coins: 100000, difficulty: Difficulty.medio, isCheckpoint: true),
    PrizeStep(coins: 200000, difficulty: Difficulty.dificil),
    PrizeStep(coins: 300000, difficulty: Difficulty.dificil),
    PrizeStep(coins: 500000, difficulty: Difficulty.dificil),
    PrizeStep(coins: millionGoal, difficulty: Difficulty.dificil),
  ];

  static int get totalSteps => steps.length;

  /// Coins garantidos quando o jogador está no degrau [stepIndex]
  /// (0-based) e erra a pergunta: cai para o último checkpoint abaixo.
  static int guaranteedCoinsAt(int stepIndex) {
    int guaranteed = 0;
    for (int i = 0; i < stepIndex && i < steps.length; i++) {
      if (steps[i].isCheckpoint) {
        guaranteed = steps[i].coins;
      }
    }
    return guaranteed;
  }
}
