import 'package:flutter_riverpod/flutter_riverpod.dart';

/// User preferences model
class UserSettings {
  final String uiLanguage;
  final String sourceLanguage;
  final String targetLanguage;
  final bool soundsEnabled;
  final bool hapticsEnabled;
  final bool autoScroll;

  UserSettings({
    this.uiLanguage = 'en',
    this.sourceLanguage = 'en',
    this.targetLanguage = 'ar',
    this.soundsEnabled = true,
    this.hapticsEnabled = true,
    this.autoScroll = true,
  });

  UserSettings copyWith({
    String? uiLanguage,
    String? sourceLanguage,
    String? targetLanguage,
    bool? soundsEnabled,
    bool? hapticsEnabled,
    bool? autoScroll,
  }) {
    return UserSettings(
      uiLanguage: uiLanguage ?? this.uiLanguage,
      sourceLanguage: sourceLanguage ?? this.sourceLanguage,
      targetLanguage: targetLanguage ?? this.targetLanguage,
      soundsEnabled: soundsEnabled ?? this.soundsEnabled,
      hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
      autoScroll: autoScroll ?? this.autoScroll,
    );
  }
}

/// Provider for user settings
class UserSettingsNotifier extends StateNotifier<UserSettings> {
  UserSettingsNotifier() : super(UserSettings());

  void setUiLanguage(String lang) => state = state.copyWith(uiLanguage: lang);
  void setSourceLanguage(String lang) => state = state.copyWith(sourceLanguage: lang);
  void setTargetLanguage(String lang) => state = state.copyWith(targetLanguage: lang);
  void toggleSounds(bool value) => state = state.copyWith(soundsEnabled: value);
  void toggleHaptics(bool value) => state = state.copyWith(hapticsEnabled: value);
  void toggleAutoScroll(bool value) => state = state.copyWith(autoScroll: value);
}

final userSettingsProvider = StateNotifierProvider<UserSettingsNotifier, UserSettings>((ref) {
  return UserSettingsNotifier();
});
