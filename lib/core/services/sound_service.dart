import 'package:audioplayers/audioplayers.dart';

/// Service for playing UI sound effects
class SoundService {
  SoundService._();
  
  static final SoundService _instance = SoundService._();
  static SoundService get instance => _instance;

  final AudioPlayer _player = AudioPlayer();
  bool _soundsEnabled = true;

  /// Enable or disable sound effects
  void setSoundsEnabled(bool enabled) {
    _soundsEnabled = enabled;
  }

  /// Play session start sound
  Future<void> playSessionStart() async {
    if (!_soundsEnabled) return;
    try {
      await _player.play(AssetSource('sounds/session_start.wav'));
    } catch (e) {
      // Silently fail if sound file doesn't exist
    }
  }

  /// Play session end sound
  Future<void> playSessionEnd() async {
    if (!_soundsEnabled) return;
    try {
      await _player.play(AssetSource('sounds/session_end.wav'));
    } catch (e) {
      // Silently fail if sound file doesn't exist
    }
  }

  /// Play save success sound
  Future<void> playSaveSuccess() async {
    if (!_soundsEnabled) return;
    try {
      await _player.play(AssetSource('sounds/save_success.wav'));
    } catch (e) {
      // Silently fail if sound file doesn't exist
    }
  }

  /// Play error notification sound
  Future<void> playError() async {
    if (!_soundsEnabled) return;
    try {
      await _player.play(AssetSource('sounds/error.wav'));
    } catch (e) {
      // Silently fail if sound file doesn't exist
    }
  }

  /// Dispose audio player
  void dispose() {
    _player.dispose();
  }
}
