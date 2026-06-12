import 'package:flutter/material.dart';

/// Paleta e tema do app, inspirado na linguagem visual amigável do DuoLingo
/// com um toque gospel (dourado/celestial).
class AppColors {
  // Verde "DuoLingo" para acertos e ação principal.
  static const Color primary = Color(0xFF58CC02);
  static const Color primaryDark = Color(0xFF46A302);

  // Azul de apoio.
  static const Color secondary = Color(0xFF1CB0F6);

  // Dourado das coins / prêmio.
  static const Color gold = Color(0xFFFFC800);
  static const Color goldDark = Color(0xFFE6A700);

  // Vermelho de erro/coração.
  static const Color danger = Color(0xFFFF4B4B);
  static const Color dangerDark = Color(0xFFD63333);

  // Roxo celestial para o tema do jogo.
  static const Color celestial = Color(0xFF6C5CE7);

  static const Color background = Color(0xFFF7F7FB);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF3C3C3C);
  static const Color textSecondary = Color(0xFF777777);
  static const Color border = Color(0xFFE5E5E5);
}

class AppTheme {
  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        brightness: Brightness.light,
      ),
    );

    return base.copyWith(
      textTheme: base.textTheme.apply(
        bodyColor: AppColors.textPrimary,
        displayColor: AppColors.textPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 16,
            letterSpacing: 0.5,
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}
