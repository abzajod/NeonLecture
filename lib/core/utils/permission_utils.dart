import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart';

/// Utility for handling device permissions
class PermissionUtils {
  PermissionUtils._();

  /// Request microphone permission
  static Future<bool> requestMicrophonePermission() async {
    if (kIsWeb) {
      // On web, permission is handled by the browser when recording starts
      return true;
    }

    try {
      final status = await Permission.microphone.status;
      if (status.isGranted) {
        return true;
      }

      final result = await Permission.microphone.request();
      return result.isGranted;
    } catch (e) {
      debugPrint('Error requesting microphone permission: $e');
      return false;
    }
  }

  /// Check if microphone permission is granted
  static Future<bool> isMicrophonePermissionGranted() async {
    if (kIsWeb) return true;
    return await Permission.microphone.isGranted;
  }

  /// Open app settings if permission is permanently denied
  static Future<void> openSettings() async {
    await openAppSettings();
  }
}
