import 'package:flutter/material.dart';

import '../models/prize_ladder.dart';
import '../theme/app_theme.dart';
import 'coin_counter.dart';

/// Painel com a escada de prêmios (1.000 → 1.000.000 coins), destacando
/// o degrau atual e os pontos seguros (checkpoints).
class PrizeLadderPanel extends StatelessWidget {
  final int currentStepIndex;
  const PrizeLadderPanel({super.key, required this.currentStepIndex});

  @override
  Widget build(BuildContext context) {
    const steps = PrizeLadder.steps;
    return ListView.builder(
      shrinkWrap: true,
      reverse: true, // 1.000.000 no topo
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: steps.length,
      itemBuilder: (context, i) {
        final step = steps[i];
        final isCurrent = i == currentStepIndex;
        final isReached = i < currentStepIndex;
        Color bg;
        if (isCurrent) {
          bg = AppColors.gold.withValues(alpha: 0.25);
        } else if (step.isCheckpoint) {
          bg = AppColors.celestial.withValues(alpha: 0.08);
        } else {
          bg = Colors.transparent;
        }
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(10),
            border: isCurrent
                ? Border.all(color: AppColors.goldDark, width: 2)
                : null,
          ),
          child: Row(
            children: [
              SizedBox(
                width: 28,
                child: Text(
                  '${i + 1}',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: isReached
                        ? AppColors.primary
                        : AppColors.textSecondary,
                  ),
                ),
              ),
              Expanded(child: CoinCounter(amount: step.coins, fontSize: 15)),
              if (step.isCheckpoint)
                const Icon(Icons.flag_rounded,
                    size: 18, color: AppColors.celestial),
              if (isReached)
                const Icon(Icons.check_circle,
                    size: 18, color: AppColors.primary),
            ],
          ),
        );
      },
    );
  }
}
