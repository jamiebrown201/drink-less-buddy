import 'package:flutter/material.dart';

/// Design system with unique brand identity
/// Inspired by wellness apps with a modern, friendly feel
class AppTheme {
  AppTheme._();

  // Brand Colors - Warm and inviting
  static const Color primaryBlue = Color(0xFF5B7B9A); // Muted slate blue
  static const Color secondaryGreen = Color(0xFF6B9080); // Sage green
  static const Color accentPurple = Color(0xFF9B7E6B); // Warm taupe
  static const Color warningAmber = Color(0xFFD4A574); // Warm caramel
  static const Color dangerRose = Color(0xFFB85C5C); // Muted terracotta

  // Neutral Colors - Warm Sand/Beige Palette
  static const Color backgroundCream = Color(0xFFF5EDE4); // Warm sand
  static const Color surfaceWhite = Color(0xFFFAF7F2); // Warm off-white
  static const Color cardBackground = Color(0xFFFFFBF7); // Cream card
  static const Color textPrimary = Color(0xFF3D3229); // Warm dark brown
  static const Color textSecondary = Color(0xFF6B5D52); // Warm gray-brown
  static const Color textTertiary = Color(0xFF9C8E82); // Light warm gray
  static const Color divider = Color(0xFFE5DDD4); // Warm divider

  // Gradients - Warm tones
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF5B7B9A), Color(0xFF6B9080)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF6B9080), Color(0xFF7FA88F)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient warningGradient = LinearGradient(
    colors: [Color(0xFFD4A574), Color(0xFFC99B6B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Shadows
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.04),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> elevatedShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> glowShadow(Color color) => [
        BoxShadow(
          color: color.withOpacity(0.3),
          blurRadius: 20,
          offset: const Offset(0, 4),
        ),
      ];

  // Spacing
  static const double spacing4 = 4.0;
  static const double spacing6 = 6.0;
  static const double spacing8 = 8.0;
  static const double spacing10 = 10.0;
  static const double spacing12 = 12.0;
  static const double spacing16 = 16.0;
  static const double spacing20 = 20.0;
  static const double spacing24 = 24.0;
  static const double spacing32 = 32.0;
  static const double spacing40 = 40.0;
  static const double spacing48 = 48.0;

  // Border Radius
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 24.0;
  static const double radiusFull = 9999.0;

  // Typography
  static const String fontFamily = 'Inter'; // Modern, readable font

  static const TextStyle displayLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    height: 1.2,
    color: textPrimary,
    letterSpacing: -0.5,
  );

  static const TextStyle displayMedium = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    height: 1.2,
    color: textPrimary,
    letterSpacing: -0.5,
  );

  static const TextStyle headlineLarge = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    height: 1.3,
    color: textPrimary,
    letterSpacing: -0.3,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.3,
    color: textPrimary,
    letterSpacing: -0.2,
  );

  static const TextStyle titleLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: textPrimary,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: textPrimary,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    height: 1.5,
    color: textPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    height: 1.5,
    color: textPrimary,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    height: 1.4,
    color: textSecondary,
  );

  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: textPrimary,
    letterSpacing: 0.5,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: textSecondary,
    letterSpacing: 0.5,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    height: 1.4,
    color: textTertiary,
    letterSpacing: 0.4,
  );

  static const TextStyle displaySmall = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    height: 1.2,
    color: textPrimary,
    letterSpacing: -0.3,
  );

  // Animation Durations
  static const Duration durationFast = Duration(milliseconds: 200);
  static const Duration durationNormal = Duration(milliseconds: 300);
  static const Duration durationSlow = Duration(milliseconds: 500);

  // Animation Curves
  static const Curve curveDefault = Curves.easeInOutCubic;
  static const Curve curveEmphasized = Curves.easeOutCubic;
  static const Curve curveDecelerate = Curves.easeOut;
  static const Curve curveAccelerate = Curves.easeIn;
  static const Curve curveSpring = Curves.elasticOut;
}
