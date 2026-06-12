import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/game_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/coin_counter.dart';
import 'quiz_screen.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();

    final won = game.phase == GamePhase.won;
    final stopped = game.phase == GamePhase.stopped;

    late Color accent;
    late IconData icon;
    late String title;
    late String subtitle;

    if (won) {
      accent = AppColors.gold;
      icon = Icons.emoji_events_rounded;
      title = 'VOCÊ CHEGOU AO MILHÃO!';
      subtitle = 'Parabéns! Você ganhou um livro gospel de presente!';
    } else if (stopped) {
      accent = AppColors.secondary;
      icon = Icons.flag_rounded;
      title = 'Você parou no tempo certo!';
      subtitle = 'Decisão sábia. Seus coins estão garantidos.';
    } else {
      accent = AppColors.danger;
      icon = Icons.favorite_rounded;
      title = 'Fim de jogo';
      subtitle = game.finalCoins > 0
          ? 'Você ainda garantiu os coins do último ponto seguro.'
          : 'Não desanime, tente de novo e supere seu recorde!';
    }

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: accent.withValues(alpha: 0.15),
                    ),
                    child: Icon(icon, size: 64, color: accent),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: accent,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 28),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.border, width: 2),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'COINS CONQUISTADOS',
                          style: TextStyle(
                            fontSize: 12,
                            letterSpacing: 1,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        CoinCounter(
                          amount: game.finalCoins,
                          fontSize: 30,
                          iconSize: 32,
                        ),
                        if (game.bestCoins > game.finalCoins) ...[
                          const SizedBox(height: 10),
                          Text(
                            'Recorde: ${formatCoins(game.bestCoins)} coins',
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                        if (game.bestCoins <= game.finalCoins &&
                            game.finalCoins > 0) ...[
                          const SizedBox(height: 10),
                          const Text(
                            'Novo recorde! 🎉',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (won) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.gold.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(16),
                        border:
                            Border.all(color: AppColors.gold, width: 2),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.menu_book_rounded,
                              color: AppColors.goldDark),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Prêmio: 1 livro gospel! Procure a organização para resgatar.',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: AppColors.goldDark,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        await game.startGame();
                        if (context.mounted) {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => const QuizScreen(),
                            ),
                          );
                        }
                      },
                      child: const Text('JOGAR DE NOVO'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {
                        game.backToHome();
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                      },
                      child: const Text(
                        'VOLTAR AO INÍCIO',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
