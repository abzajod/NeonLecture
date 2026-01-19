import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:record/record.dart';
import '../../../../core/utils/permission_utils.dart';

/// Service responsible for recording audio and emitting chunks
class AudioRecordingService {
  final AudioRecorder _recorder = AudioRecorder();
  StreamSubscription<Uint8List>? _audioStreamSubscription;

  // Controller for emitting audio chunks
  final _chunkController = StreamController<Uint8List>.broadcast();
  Stream<Uint8List> get audioChunkStream => _chunkController.stream;

  bool _isRecording = false;
  bool get isRecording => _isRecording;

  /// Start recording audio and streaming chunks
  Future<void> startRecording() async {
    if (_isRecording) return;

    final hasPermission = await PermissionUtils.requestMicrophonePermission();
    if (!hasPermission) {
      throw Exception('Microphone permission not granted');
    }

    try {
      // Configuration for high quality STT
      const config = RecordConfig(
        encoder: AudioEncoder.wav, // Using WAV for better STT accuracy
        numChannels: 1,
        sampleRate: 16000,
      );

      if (kIsWeb) {
        // For web, we might use a different approach or stream directly
        // But the record package supports web streaming
        final stream = await _recorder.startStream(config);
        _audioStreamSubscription = stream.listen((chunk) {
          _chunkController.add(Uint8List.fromList(chunk));
        });
      } else {
        // On mobile, we can also stream or record to file
        // To support "chunks", we can either use startStream or manually split files
        // startStream is more efficient for real-time STT
        final stream = await _recorder.startStream(config);
        _audioStreamSubscription = stream.listen((chunk) {
          _chunkController.add(Uint8List.fromList(chunk));
        });
      }

      _isRecording = true;
      debugPrint('Audio recording started...');
    } catch (e) {
      debugPrint('Error starting audio recording: $e');
      _isRecording = false;
      rethrow;
    }
  }

  /// Stop recording
  Future<void> stopRecording() async {
    if (!_isRecording) return;

    try {
      await _audioStreamSubscription?.cancel();
      await _recorder.stop();
      _isRecording = false;
      debugPrint('Audio recording stopped.');
    } catch (e) {
      debugPrint('Error stopping audio recording: $e');
    }
  }

  /// Pause recording
  Future<void> pauseRecording() async {
    if (!_isRecording) return;
    try {
      await _recorder.pause();
      debugPrint('Audio recording paused.');
    } catch (e) {
      debugPrint('Error pausing audio recording: $e');
    }
  }

  /// Resume recording
  Future<void> resumeRecording() async {
    if (!_isRecording) return;
    try {
      await _recorder.resume();
      debugPrint('Audio recording resumed.');
    } catch (e) {
      debugPrint('Error resuming audio recording: $e');
    }
  }

  /// Clean up resources
  void dispose() {
    _audioStreamSubscription?.cancel();
    _chunkController.close();
    _recorder.dispose();
  }
}
