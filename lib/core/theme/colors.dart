import 'package:flutter/material.dart';

/// Neon color palette for NeonLecture AI
class NeonColors {
  NeonColors._();

  // Primary neon colors
  static const Color neonCyan = Color(0xFF00F5FF);
  static const Color neonPurple = Color(0xFFBF40FF);
  static const Color neonPink = Color(0xFFFF10F0);
  static const Color neonBlue = Color(0xFF00D9FF);
  static const Color neonViolet = Color(0xFF9D4EDD);

  // Background colors
  static const Color darkBg = Color(0xFF0A0E27);
  static const Color cardBg = Color(0xFF1A1F3A);
  static const Color surfaceBg = Color(0xFF141A2E);
  
  // Gradients
  static const LinearGradient bgGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0F1729), Color(0xFF1A0F2E), Color(0xFF0A0E27)],
  );
  
  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1F2642), Color(0xFF1A1F3A)],
  );
  
  static const LinearGradient neonGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [neonCyan, neonPurple],
  );
  
  static const LinearGradient subtleGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [neonPurple, neonPink],
  );

  // Text colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B8CC);
  static const Color textTertiary = Color(0xFF6B7280);
  
  // Semantic colors
  static const Color success = Color(0xFF00FF88);
  static const Color error = Color(0xFFFF3366);
  static const Color warning = Color(0xFFFFAA00);
  static const Color info = neonCyan;
}
