import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/prize_ladder.dart';
import '../state/game_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/answer_button.dart';
import '../widgets/coin_counter.dart';
import '../widgets/lifeline_bar.dart';
import '../widgets/prize_ladder_panel.dart';
import '../widgets/timer_bar.dart';
import 'result_screen.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  bool _navigated = false;

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();

    // Quando a partida termina, navega para o resultado.
    if (game.isOver && !_navigated) {
      _navigated = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const ResultScreen()),
        );
      });
    }

    final question = game.question;
    if (question == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _TopBar(game: game),
                  const SizedBox(height: 12),
                  TimerBar(
                    secondsLeft: game.secondsLeft,
                    totalSeconds: 30,
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _QuestionCard(game: game),
                          const SizedBox(height: 16),
                          ..._buildAnswers(game),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (game.phase == GamePhase.playing) ...[
                    LifelineBar(game: game),
                    const SizedBox(height: 12),
                    _StopButton(game: game),
                  ],
                  if (game.phase == GamePhase.feedback)
                    _FeedbackBar(game: game),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildAnswers(GameController game) {
    final q = game.question!;
    final letters = ['A', 'B', 'C', 'D'];
    return List.generate(q.options.length, (i) {
      AnswerState state = AnswerState.idle;
      if (game.eliminated.contains(i)) {
        state = AnswerState.eliminated;
      } else if (game.phase == GamePhase.feedback) {
        if (i == q.correctIndex) {
          state = AnswerState.correct;
        } else if (i == game.selectedIndex) {
          state = AnswerState.selectedWrong;
        }
      } else if (game.audienceSuggestion == i) {
        state = AnswerState.suggested;
      }
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: AnswerButton(
          letter: letters[i],
          text: q.options[i],
          state: state,
          onTap: game.phase == GamePhase.playing
              ? () => game.answer(i)
              : null,
        ),
      );
    });
  }
}

class _TopBar extends StatelessWidget {
  final GameController game;
  const _TopBar({required this.game});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.close_rounded),
          color: AppColors.textSecondary,
          onPressed: () => _confirmQuit(context),
        ),
        Expanded(
          child: Column(
            children: [
              Text(
                'Pergunta ${game.stepIndex + 1} de ${game.totalSteps}',
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 2),
              CoinCounter(amount: game.currentStep.coins, fontSize: 18),
            ],
          ),
        ),
        IconButton(
          tooltip: 'Escada de prêmios',
          icon: const Icon(Icons.leaderboard_rounded),
          color: AppColors.celestial,
          onPressed: () => _showLadder(context, game.stepIndex),
        ),
      ],
    );
  }

  void _showLadder(BuildContext context, int stepIndex) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: Colors.white,
      builder: (_) => SizedBox(
        height: 460,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(12),
              child: Text('Escada de prêmios',
                  style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
            ),
            Expanded(child: PrizeLadderPanel(currentStepIndex: stepIndex)),
          ],
        ),
      ),
    );
  }

  void _confirmQuit(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sair da partida?'),
        content: const Text(
            'Se sair agora, você abre mão dos coins ainda não garantidos.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Continuar jogando'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              game.stopGame();
            },
            child: const Text('Parar e levar coins'),
          ),
        ],
      ),
    );
  }
}

class _QuestionCard extends StatelessWidget {
  final GameController game;
  const _QuestionCard({required this.game});

  @override
  Widget build(BuildContext context) {
    final q = game.question!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.celestial.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              q.difficulty.label.toUpperCase(),
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w900,
                color: AppColors.celestial,
                letterSpacing: 1,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            q.question,
            style: const TextStyle(
              fontSize: 19,
              height: 1.3,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _StopButton extends StatelessWidget {
  final GameController game;
  const _StopButton({required this.game});

  @override
  Widget build(BuildContext context) {
    final canStop = game.coins > 0;
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: canStop ? game.stopGame : null,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.goldDark,
          side: BorderSide(
            color: canStop ? AppColors.gold : AppColors.border,
            width: 2,
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        icon: const Icon(Icons.flag_rounded),
        label: Text(
          canStop
              ? 'Parar e levar ${formatCoins(game.coins)} coins'
              : 'Parar (responda 1 pergunta primeiro)',
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}

class _FeedbackBar extends StatelessWidget {
  final GameController game;
  const _FeedbackBar({required this.game});

  @override
  Widget build(BuildContext context) {
    final correct = game.lastAnswerCorrect;
    final q = game.question!;
    final color = correct ? AppColors.primary : AppColors.danger;
    final bg = correct ? const Color(0xFFD7FFB8) : const Color(0xFFFFD9D9);
    final isLast = game.stepIndex >= PrizeLadder.totalSteps - 1;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                correct ? Icons.check_circle : Icons.cancel,
                color: color,
              ),
              const SizedBox(width: 8),
              Text(
                correct ? 'Muito bem!' : 'Resposta incorreta',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                  color: correct ? AppColors.primaryDark : AppColors.dangerDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '${q.reference} — ${q.explanation}',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: correct ? AppColors.primaryDark : AppColors.dangerDark,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: color),
              onPressed: game.next,
              child: Text(
                !correct
                    ? 'VER RESULTADO'
                    : isLast
                        ? 'GANHAR O MILHÃO!'
                        : 'PRÓXIMA PERGUNTA',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
