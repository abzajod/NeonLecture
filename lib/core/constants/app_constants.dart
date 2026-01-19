/// Application-wide constants
class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'NeonLecture AI';
  static const String appVersion = '1.0.0';

  // Audio Recording
  static const int audioChunkDurationSeconds = 3;
  static const int audioSampleRate = 16000; // 16kHz
  static const int audioBitRate = 128000; // 128kbps

  // API Timeouts
  static const int transcriptionTimeoutSeconds = 30;
  static const int imageRequestTimeoutSeconds = 20;
  static const int summaryTimeoutSeconds = 60;

  // UI
  static const int maxVisibleImages = 5;
  static const int maxSubtitleLines = 3;
  static const double glowBlurRadius = 20.0;
  static const double glowSpreadRadius = 2.0;

  // Auto-save interval (milliseconds)
  static const int autoSaveIntervalMs = 30000; // 30 seconds

  // Animations
  static const Duration fadeAnimationDuration = Duration(milliseconds: 300);
  static const Duration slideAnimationDuration = Duration(milliseconds: 400);
  static const Duration pageTransitionDuration = Duration(milliseconds: 250);

  // Haptic patterns
  static const Duration lightHapticDuration = Duration(milliseconds: 50);
  static const Duration mediumHapticDuration = Duration(milliseconds: 100);

  // Supported languages (ISO codes)
  static const List<String> supportedLanguages = [
    'en', // English
    'ar', // Arabic
    'es', // Spanish
    'fr', // French
    'de', // German
  ];

  // Language display names
  static const Map<String, String> languageNames = {
    'en': 'English',
    'ar': 'العربية',
    'es': 'Español',
    'fr': 'Français',
    'de': 'Deutsch',
  };
}
