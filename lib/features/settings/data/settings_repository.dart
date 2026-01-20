import 'package:hive_flutter/hive_flutter.dart';
import 'user_settings_provider.dart';

class SettingsRepository {
  static const String _boxName = 'settings';

  static Future<void> init() async {
    // Hive.initFlutter() is likely controlled by the main app, but we ensure it's open here.
    // If main app init is centralized, we just open box.
    // We assume Hive.initFlutter() is called in main.
    await Hive.openBox(_boxName);
  }

  Box get _box => Hive.box(_boxName);

  UserSettings loadSettings() {
    final box = _box;
    return UserSettings(
      uiLanguage: box.get('uiLanguage', defaultValue: 'en'),
      sourceLanguage: box.get('sourceLanguage', defaultValue: 'en'),
      targetLanguage: box.get('targetLanguage', defaultValue: 'ar'),
      soundsEnabled: box.get('soundsEnabled', defaultValue: true),
      hapticsEnabled: box.get('hapticsEnabled', defaultValue: true),
      autoScroll: box.get('autoScroll', defaultValue: true),
    );
  }

  Future<void> saveSettings(UserSettings settings) async {
    final box = _box;
    await box.put('uiLanguage', settings.uiLanguage);
    await box.put('sourceLanguage', settings.sourceLanguage);
    await box.put('targetLanguage', settings.targetLanguage);
    await box.put('soundsEnabled', settings.soundsEnabled);
    await box.put('hapticsEnabled', settings.hapticsEnabled);
    await box.put('autoScroll', settings.autoScroll);
  }
}
