import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';

/// Utilities for haptic feedback
class HapticUtils {
  HapticUtils._();

  /// Light impact feedback (for subtle interactions)
  static Future<void> lightImpact() async {
    try {
      await HapticFeedback.lightImpact();
    } catch (e) {
      // Silently fail on platforms that don't support haptics
    }
  }

  /// Medium impact feedback (for button taps)
  static Future<void> mediumImpact() async {
    try {
      await HapticFeedback.mediumImpact();
    } catch (e) {
      // Silently fail on platforms that don't support haptics
    }
  }

  /// Heavy impact feedback (for important events)
  static Future<void> heavyImpact() async {
    try {
      await HapticFeedback.heavyImpact();
    } catch (e) {
      // Silently fail on platforms that don't support haptics
    }
  }

  /// Selection click feedback
  static Future<void> selectionClick() async {
    try {
      await HapticFeedback.selectionClick();
    } catch (e) {
      // Silently fail on platforms that don't support haptics
    }
  }

  /// Custom vibration (mobile only)
  static Future<void> customVibrate({
    int duration = 50,
  }) async {
    try {
      final hasVibrator = await Vibration.hasVibrator();
      if (hasVibrator == true) {
        await Vibration.vibrate(duration: duration);
      }
    } catch (e) {
      // Silently fail on platforms that don't support vibration
    }
  }

  /// Success haptic pattern
  static Future<void> success() async {
    await mediumImpact();
  }

  /// Error haptic pattern
  static Future<void> error() async {
    await heavyImpact();
  }

  /// New subtitle line haptic
  static Future<void> newSubtitle() async {
    await lightImpact();
  }
}
