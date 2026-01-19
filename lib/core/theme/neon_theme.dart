import 'package:flutter/material.dart';
import 'colors.dart';
import 'text_styles.dart';

/// Main theme configuration for NeonLecture AI
class NeonTheme {
  NeonTheme._();

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: NeonColors.darkBg,
      colorScheme: const ColorScheme.dark(
        primary: NeonColors.neonCyan,
        secondary: NeonColors.neonPurple,
        tertiary: NeonColors.neonPink,
        surface: NeonColors.cardBg,
        error: NeonColors.error,
        onPrimary: Colors.black,
        onSecondary: Colors.white,
        onSurface: NeonColors.textPrimary,
        onError: Colors.white,
      ),

      // App Bar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: NeonTextStyles.headlineSmall.copyWith(
          color: NeonColors.neonCyan,
          letterSpacing: 2,
        ),
        iconTheme: const IconThemeData(color: NeonColors.neonCyan),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.macOS: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
        },
      ),

      // Card Theme
      cardTheme: const CardThemeData(
        color: NeonColors.cardBg,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          side: BorderSide(
            color:
                Color(0x4D00FFFF), // NeonColors.neonCyan.withValues(alpha: 0.3)
            width: 1,
          ),
        ),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: NeonColors.textPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: NeonTextStyles.button,
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: NeonColors.neonCyan,
          textStyle: NeonTextStyles.labelLarge,
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: NeonColors.surfaceBg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: NeonColors.neonCyan.withValues(alpha: 0.3),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: NeonColors.neonCyan.withValues(alpha: 0.2),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: NeonColors.neonCyan,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: NeonColors.error,
          ),
        ),
        labelStyle: NeonTextStyles.bodyMedium,
        hintStyle: NeonTextStyles.bodySmall,
      ),

      // Icon Theme
      iconTheme: const IconThemeData(
        color: NeonColors.neonCyan,
        size: 24,
      ),

      // Divider Theme
      dividerTheme: DividerThemeData(
        color: NeonColors.neonCyan.withValues(alpha: 0.2),
        thickness: 1,
        space: 24,
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: NeonColors.cardBg,
        selectedItemColor: NeonColors.neonCyan,
        unselectedItemColor: NeonColors.textTertiary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: NeonTextStyles.labelSmall,
        unselectedLabelStyle: NeonTextStyles.labelSmall,
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: NeonColors.cardBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: NeonColors.neonCyan.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        titleTextStyle: NeonTextStyles.headlineSmall,
        contentTextStyle: NeonTextStyles.bodyMedium,
      ),

      // Progress Indicator Theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: NeonColors.neonCyan,
        circularTrackColor: NeonColors.surfaceBg,
      ),

      // Text Theme
      textTheme: TextTheme(
        displayLarge: NeonTextStyles.displayLarge,
        displayMedium: NeonTextStyles.displayMedium,
        displaySmall: NeonTextStyles.displaySmall,
        headlineLarge: NeonTextStyles.headlineLarge,
        headlineMedium: NeonTextStyles.headlineMedium,
        headlineSmall: NeonTextStyles.headlineSmall,
        bodyLarge: NeonTextStyles.bodyLarge,
        bodyMedium: NeonTextStyles.bodyMedium,
        bodySmall: NeonTextStyles.bodySmall,
        labelLarge: NeonTextStyles.labelLarge,
        labelMedium: NeonTextStyles.labelMedium,
        labelSmall: NeonTextStyles.labelSmall,
      ),
    );
  }

  // Helper decoration with glow effect
  static BoxDecoration get neonGlowDecoration {
    return BoxDecoration(
      border: Border.all(
        color: NeonColors.neonCyan,
        width: 2,
      ),
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: NeonColors.neonCyan.withValues(alpha: 0.5),
          blurRadius: 20,
          spreadRadius: 2,
        ),
      ],
    );
  }

  static BoxDecoration neonGlowDecorationWithColor(Color color) {
    return BoxDecoration(
      border: Border.all(
        color: color,
        width: 2,
      ),
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: color.withValues(alpha: 0.5),
          blurRadius: 20,
          spreadRadius: 2,
        ),
      ],
    );
  }
}
