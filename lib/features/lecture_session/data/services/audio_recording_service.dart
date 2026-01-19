import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:record/record.dart';
import '../../../../core/utils/permission_utils.dart';
import '../../domain/entities/audio_chunk.dart';

// Conditional import for web interop
import 'dart:js_interop';
import '../../../../core/interop/web_recorder_interop.dart'
    if (dart.library.io) '../../../../core/interop/stub_web_recorder_interop.dart';

/// Service responsible for recording audio and emitting chunks
class AudioRecordingService {
  final AudioRecorder _recorder = AudioRecorder();
  StreamSubscription<Uint8List>? _audioStreamSubscription;

  // Controller for emitting audio chunks
  final _chunkController = StreamController<AudioChunk>.broadcast();
  Stream<AudioChunk> get audioChunkStream => _chunkController.stream;

  bool _isRecording = false;
  bool get isRecording => _isRecording;

  // Web specific state
  String? _sessionId;
  int _mobileChunkIndex = 0;

  /// Start recording audio and streaming chunks
  Future<void> startRecording() async {
    if (_isRecording) return;

    if (!kIsWeb) {
      final hasPermission = await PermissionUtils.requestMicrophonePermission();
      if (!hasPermission) {
        throw Exception('Microphone permission not granted');
      }
    }

    try {
      if (kIsWeb) {
        // Native Web Recording
        _setupWebCallback();

        // Start JS recorder with 1500ms timeslice
        final promise = micRecorder.start(1500);
        final sessionId = await promise.toDart;
        _sessionId = sessionId.toDart;

        debugPrint('Web recording started, session: $_sessionId');
      } else {
        // Mobile Recording
        _mobileChunkIndex = 0;
        const config = RecordConfig(
          encoder: AudioEncoder.wav,
          numChannels: 1,
          sampleRate: 16000,
        );
        final stream = await _recorder.startStream(config);
        _audioStreamSubscription = stream.listen((chunk) {
          // On mobile, we emit raw chunks with a dummy index or handle accumulation in AudioChunker
          // However, to satisfy the Stream<AudioChunk> signature:
          _chunkController.add(AudioChunk(
            bytes: Uint8List.fromList(chunk),
            index: _mobileChunkIndex++, // Incrementing index for raw stream
            mimeType: 'audio/wav',
          ));
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

  void _setupWebCallback() {
    // Define the callback function using toJS
    onMicData = ((JSObject data, JSString mimeType, JSNumber index,
        JSString sessionId) {
      if (data.isA<JSUint8Array>()) {
        final array = data as JSUint8Array;
        final dartData = array.toDart;

        // Fix: Use index.toDartDouble.toInt() for JSNumber
        final chunkIndex = index.toDartDouble.toInt();

        _chunkController.add(AudioChunk(
          bytes: dartData,
          index: chunkIndex,
          mimeType: mimeType.toDart,
          sessionId: sessionId.toDart,
        ));
        debugPrint("Received JS Chunk $chunkIndex, size: ${dartData.length}");
      }
    }).toJS;
  }

  /// Stop recording
  Future<void> stopRecording() async {
    if (!_isRecording) return;

    try {
      if (kIsWeb) {
        micRecorder.stop();
      } else {
        await _audioStreamSubscription?.cancel();
        await _recorder.stop();
      }
      _isRecording = false;
      debugPrint('Audio recording stopped.');
    } catch (e) {
      debugPrint('Error stopping audio recording: $e');
    }
  }

  /// Pause recording
  Future<void> pauseRecording() async {
    if (kIsWeb) return;

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
    if (kIsWeb) return;

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
    stopRecording();
    _audioStreamSubscription?.cancel();
    _chunkController.close();
    if (!kIsWeb) _recorder.dispose();
  }
}
