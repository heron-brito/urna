import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/game_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/coin_counter.dart';
import 'quiz_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();

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
                  const _MuteRow(),
                  const Spacer(),
                  // "Mascote" / emblema do jogo.
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [AppColors.gold, AppColors.goldDark],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.goldDark.withValues(alpha: 0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.menu_book_rounded,
                        size: 64, color: Colors.white),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Quiz Gospel\ndo Milhão',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 34,
                      height: 1.1,
                      fontWeight: FontWeight.w900,
                      color: AppColors.celestial,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Responda, acumule coins e chegue ao\n1.000.000 para ganhar um livro gospel!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (game.bestCoins > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.border, width: 2),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.emoji_events_rounded,
                              color: AppColors.gold),
                          const SizedBox(width: 8),
                          const Text('Recorde:',
                              style:
                                  TextStyle(fontWeight: FontWeight.w700)),
                          const SizedBox(width: 8),
                          CoinCounter(amount: game.bestCoins, fontSize: 16),
                        ],
                      ),
                    ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        await game.startGame();
                        if (context.mounted) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => const QuizScreen()),
                          );
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 4),
                        child: Text('COMEÇAR A JOGAR'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => _showHowItWorks(context),
                    child: const Text(
                      'Como funciona?',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w700,
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

  void _showHowItWorks(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const Padding(
        padding: EdgeInsets.fromLTRB(24, 0, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Como funciona',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
            SizedBox(height: 16),
            _Rule(
                icon: Icons.quiz_rounded,
                text: 'São 13 perguntas com dificuldade crescente.'),
            _Rule(
                icon: Icons.timer_rounded,
                text: 'Cada pergunta tem 30 segundos no cronômetro.'),
            _Rule(
                icon: Icons.flag_rounded,
                text:
                    'Há pontos seguros: ao errar, você leva os coins do último checkpoint.'),
            _Rule(
                icon: Icons.handshake_rounded,
                text: 'Use as ajudas 50/50, Plateia e Pular (uma vez cada).'),
            _Rule(
                icon: Icons.menu_book_rounded,
                text:
                    'Chegou a 1.000.000 de coins? Você ganha um livro gospel!'),
          ],
        ),
      ),
    );
  }
}

class _Rule extends StatelessWidget {
  final IconData icon;
  final String text;
  const _Rule({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.celestial),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text,
                style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

class _MuteRow extends StatelessWidget {
  const _MuteRow();

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameController>();
    return Align(
      alignment: Alignment.centerRight,
      child: IconButton(
        tooltip: game.muted ? 'Ativar som' : 'Silenciar',
        icon: Icon(
          game.muted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
          color: AppColors.textSecondary,
        ),
        onPressed: game.toggleMute,
      ),
    );
  }
}
