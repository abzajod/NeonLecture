import 'dart:async';
import 'dart:typed_data';
import 'audio_recording_service.dart';

/// Manages the chunking logic for audio data to be sent to n8n
class AudioChunker {
  final AudioRecordingService _audioService;
  final Duration chunkDuration;

  StreamSubscription? _rawStreamSubscription;
  final _chunkedStreamController = StreamController<Uint8List>.broadcast();

  Stream<Uint8List> get chunkedStream => _chunkedStreamController.stream;

  List<int> _buffer = [];
  Timer? _chunkTimer;

  AudioChunker(this._audioService,
      {this.chunkDuration = const Duration(milliseconds: 500)});

  void start() {
    _rawStreamSubscription = _audioService.audioChunkStream.listen((data) {
      _buffer.addAll(data.bytes);
    });

    // Strategy: Emit buffer every [chunkDuration]
    _chunkTimer = Timer.periodic(chunkDuration, (timer) {
      if (_buffer.isNotEmpty) {
        _chunkedStreamController.add(Uint8List.fromList(_buffer));
        _buffer = [];
      }
    });
  }

  void stop() {
    _chunkTimer?.cancel();
    _rawStreamSubscription?.cancel();

    // Send remaining buffer
    if (_buffer.isNotEmpty) {
      _chunkedStreamController.add(Uint8List.fromList(_buffer));
      _buffer = [];
    }
  }

  void dispose() {
    stop();
    _chunkedStreamController.close();
  }
}
