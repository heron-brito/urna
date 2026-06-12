import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Barra de cronômetro por pergunta, estilo "barra de progresso" do DuoLingo.
/// Fica verde, depois amarela e vermelha conforme o tempo acaba.
class TimerBar extends StatelessWidget {
  final int secondsLeft;
  final int totalSeconds;

  const TimerBar({
    super.key,
    required this.secondsLeft,
    required this.totalSeconds,
  });

  Color get _color {
    final ratio = secondsLeft / totalSeconds;
    if (ratio > 0.5) return AppColors.primary;
    if (ratio > 0.25) return AppColors.gold;
    return AppColors.danger;
  }

  @override
  Widget build(BuildContext context) {
    final ratio = (secondsLeft / totalSeconds).clamp(0.0, 1.0);
    return Row(
      children: [
        Icon(Icons.timer_rounded, color: _color, size: 22),
        const SizedBox(width: 8),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: ratio, end: ratio),
              duration: const Duration(milliseconds: 400),
              builder: (context, value, _) => LinearProgressIndicator(
                value: value,
                minHeight: 14,
                backgroundColor: AppColors.border,
                valueColor: AlwaysStoppedAnimation(_color),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 34,
          child: Text(
            '${secondsLeft}s',
            textAlign: TextAlign.end,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: _color,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
