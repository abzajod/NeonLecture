import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

/// Neon-themed text styles
class NeonTextStyles {
  NeonTextStyles._();

  // Display styles
  static TextStyle displayLarge = GoogleFonts.outfit(
    fontSize: 48,
    fontWeight: FontWeight.bold,
    color: NeonColors.textPrimary,
    height: 1.2,
    shadows: [
      Shadow(
        color: NeonColors.neonCyan.withValues(alpha: 0.5),
        blurRadius: 20,
      ),
    ],
  );

  static TextStyle displayMedium = GoogleFonts.outfit(
    fontSize: 36,
    fontWeight: FontWeight.bold,
    color: NeonColors.textPrimary,
    shadows: [
      Shadow(
        color: NeonColors.neonPurple.withValues(alpha: 0.4),
        blurRadius: 15,
      ),
    ],
  );

  static TextStyle displaySmall = GoogleFonts.outfit(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: NeonColors.textPrimary,
  );

  // Heading styles
  static TextStyle headlineLarge = GoogleFonts.outfit(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: NeonColors.textPrimary,
  );

  static TextStyle headlineMedium = GoogleFonts.outfit(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: NeonColors.textPrimary,
  );

  static TextStyle headlineSmall = GoogleFonts.outfit(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: NeonColors.textPrimary,
  );

  // Body styles
  static TextStyle bodyLarge = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: NeonColors.textPrimary,
    height: 1.5,
  );

  static TextStyle bodyMedium = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: NeonColors.textSecondary,
    height: 1.5,
  );

  static TextStyle bodySmall = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: NeonColors.textTertiary,
    height: 1.4,
  );

  // Label styles
  static TextStyle labelLarge = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: NeonColors.textPrimary,
    letterSpacing: 0.5,
  );

  static TextStyle labelMedium = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: NeonColors.textSecondary,
    letterSpacing: 0.5,
  );

  static TextStyle labelSmall = GoogleFonts.inter(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: NeonColors.textTertiary,
    letterSpacing: 0.5,
  );

  // Special styles
  static TextStyle subtitle = GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: NeonColors.neonCyan,
    height: 1.6,
    shadows: [
      Shadow(
        color: NeonColors.neonCyan.withValues(alpha: 0.3),
        blurRadius: 10,
      ),
    ],
  );

  static TextStyle subtitleTranslated = GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: NeonColors.neonPurple,
    height: 1.6,
    shadows: [
      Shadow(
        color: NeonColors.neonPurple.withValues(alpha: 0.3),
        blurRadius: 10,
      ),
    ],
  );

  static TextStyle button = GoogleFonts.outfit(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: NeonColors.textPrimary,
    letterSpacing: 1,
  );

  static TextStyle caption = GoogleFonts.inter(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: NeonColors.textTertiary,
  );
}
