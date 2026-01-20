import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'settings_repository.dart';

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
  final SettingsRepository _repository;

  UserSettingsNotifier(this._repository) : super(UserSettings()) {
    _loadSettings();
  }

  void _loadSettings() {
    state = _repository.loadSettings();
  }

  void _save() {
    _repository.saveSettings(state);
  }

  void setUiLanguage(String lang) {
    state = state.copyWith(uiLanguage: lang);
    _save();
  }

  void setSourceLanguage(String lang) {
    state = state.copyWith(sourceLanguage: lang);
    _save();
  }

  void setTargetLanguage(String lang) {
    state = state.copyWith(targetLanguage: lang);
    _save();
  }

  void toggleSounds(bool value) {
    state = state.copyWith(soundsEnabled: value);
    _save();
  }

  void toggleHaptics(bool value) {
    state = state.copyWith(hapticsEnabled: value);
    _save();
  }

  void toggleAutoScroll(bool value) {
    state = state.copyWith(autoScroll: value);
    _save();
  }
}

final userSettingsProvider =
    StateNotifierProvider<UserSettingsNotifier, UserSettings>((ref) {
  final repository =
      SettingsRepository(); // Ideally accessed via provider, but direct for now to match simplicity
  return UserSettingsNotifier(repository);
});
