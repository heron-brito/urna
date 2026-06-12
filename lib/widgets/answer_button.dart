import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Estado visual de um botão de resposta.
enum AnswerState { idle, eliminated, selectedWrong, correct, suggested }

/// Botão de alternativa estilo DuoLingo: cantos arredondados, "sombra"
/// inferior 3D e cores de feedback.
class AnswerButton extends StatelessWidget {
  final String letter; // A, B, C, D
  final String text;
  final AnswerState state;
  final VoidCallback? onTap;

  const AnswerButton({
    super.key,
    required this.letter,
    required this.text,
    required this.state,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    late Color bg;
    late Color borderColor;
    late Color fg;

    switch (state) {
      case AnswerState.idle:
        bg = Colors.white;
        borderColor = AppColors.border;
        fg = AppColors.textPrimary;
        break;
      case AnswerState.suggested:
        bg = const Color(0xFFE8F6FF);
        borderColor = AppColors.secondary;
        fg = AppColors.textPrimary;
        break;
      case AnswerState.eliminated:
        bg = const Color(0xFFF0F0F0);
        borderColor = AppColors.border;
        fg = Colors.grey.shade400;
        break;
      case AnswerState.correct:
        bg = const Color(0xFFD7FFB8);
        borderColor = AppColors.primary;
        fg = AppColors.primaryDark;
        break;
      case AnswerState.selectedWrong:
        bg = const Color(0xFFFFD9D9);
        borderColor = AppColors.danger;
        fg = AppColors.dangerDark;
        break;
    }

    final disabled = onTap == null || state == AnswerState.eliminated;

    return Opacity(
      opacity: state == AnswerState.eliminated ? 0.55 : 1,
      child: Container(
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 2),
          boxShadow: [
            BoxShadow(
              color: borderColor.withValues(alpha: 0.5),
              offset: const Offset(0, 3),
              blurRadius: 0,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: disabled ? null : onTap,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: borderColor.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      letter,
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: fg,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      text,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: fg,
                      ),
                    ),
                  ),
                  if (state == AnswerState.correct)
                    const Icon(Icons.check_circle, color: AppColors.primary),
                  if (state == AnswerState.selectedWrong)
                    const Icon(Icons.cancel, color: AppColors.danger),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
