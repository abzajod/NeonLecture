import 'dart:typed_data';

class AudioChunk {
  final Uint8List bytes;
  final int index;
  final String mimeType;
  final String? sessionId;

  AudioChunk({
    required this.bytes,
    required this.index,
    required this.mimeType,
    this.sessionId,
  });
}
