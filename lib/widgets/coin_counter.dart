import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Formata um valor de coins com separador de milhar (ex.: 1.000.000).
String formatCoins(int value) {
  final s = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buffer.write('.');
    buffer.write(s[i]);
  }
  return buffer.toString();
}

/// Ícone de moeda dourada reutilizável (sem cifrão, conforme pedido).
class CoinIcon extends StatelessWidget {
  final double size;
  const CoinIcon({super.key, this.size = 22});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.gold, AppColors.goldDark],
        ),
        boxShadow: [
          BoxShadow(color: Color(0x33000000), blurRadius: 2, offset: Offset(0, 1)),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        'C',
        style: TextStyle(
          fontSize: size * 0.6,
          fontWeight: FontWeight.w900,
          color: Colors.white,
        ),
      ),
    );
  }
}

/// Exibe a quantidade de coins com o ícone de moeda.
class CoinCounter extends StatelessWidget {
  final int amount;
  final double iconSize;
  final double fontSize;
  final Color? textColor;

  const CoinCounter({
    super.key,
    required this.amount,
    this.iconSize = 22,
    this.fontSize = 18,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CoinIcon(size: iconSize),
        const SizedBox(width: 6),
        Text(
          formatCoins(amount),
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w800,
            color: textColor ?? AppColors.goldDark,
          ),
        ),
      ],
    );
  }
}
