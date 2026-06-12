import 'package:flutter/material.dart';

import '../state/game_controller.dart';
import '../theme/app_theme.dart';

/// Barra de ajudas ("cartas") do Show do Milhão: 50/50, plateia e pular.
class LifelineBar extends StatelessWidget {
  final GameController game;
  const LifelineBar({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _LifelineButton(
          icon: Icons.balance_rounded,
          label: '50/50',
          used: game.isLifelineUsed(Lifeline.fiftyFifty),
          color: AppColors.secondary,
          onTap: game.useFiftyFifty,
        ),
        _LifelineButton(
          icon: Icons.groups_rounded,
          label: 'Plateia',
          used: game.isLifelineUsed(Lifeline.audience),
          color: AppColors.celestial,
          onTap: game.useAudience,
        ),
        _LifelineButton(
          icon: Icons.skip_next_rounded,
          label: 'Pular',
          used: game.isLifelineUsed(Lifeline.skip),
          color: AppColors.gold,
          onTap: game.useSkip,
        ),
      ],
    );
  }
}

class _LifelineButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool used;
  final Color color;
  final VoidCallback onTap;

  const _LifelineButton({
    required this.icon,
    required this.label,
    required this.used,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: used ? 0.4 : 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: used ? null : onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color.withValues(alpha: 0.5), width: 1.5),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                  color: color,
                  decoration: used ? TextDecoration.lineThrough : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
