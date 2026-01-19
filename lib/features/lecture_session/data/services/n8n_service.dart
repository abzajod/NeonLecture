import 'package:dio/dio.dart';
import '../../../../core/config/env_config.dart';

/// Service to interact with n8n webhooks
class N8nService {
  final Dio _dio = Dio();

  N8nService() {
    _dio.options.baseUrl = EnvConfig.n8nBaseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 15);
    _dio.options.receiveTimeout = const Duration(seconds: 45);

    // Add logging and simple retry interceptor if needed
    _dio.interceptors.add(InterceptorsWrapper(
      onError: (e, handler) async {
        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.sendTimeout) {
          // Could implement automatic retry here
        }
        return handler.next(e);
      },
    ));
  }

  /// Sends an audio chunk to n8n for transcription and translation
  Future<Map<String, dynamic>> sendAudioChunk({
    required String sessionId,
    required List<int> audioData,
    required String sourceLang,
    required String targetLang,
    int? chunkIndex,
    String? mimeType,
  }) async {
    if (!EnvConfig.isConfigured) {
      // Mock response if not configured
      await Future.delayed(const Duration(seconds: 1));
      return {
        'original_text': 'This is a mock transcription of the audio chunk.',
        'translated_text': 'هذا ترجمة وهمية للمقطع الصوتي.',
        'script': 'This is a mock transcription of the audio chunk.',
        'translation': 'هذا ترجمة وهمية للمقطع الصوتي.',
      };
    }

    try {
      final formData = FormData.fromMap({
        'session_id': sessionId,
        'audio': MultipartFile.fromBytes(
          audioData,
          filename: 'chunk_${chunkIndex ?? 0}.wav',
          contentType: mimeType != null ? DioMediaType.parse(mimeType) : null,
        ),
        'source_lang': sourceLang,
        'target_lang': targetLang,
        if (chunkIndex != null) 'chunk_index': chunkIndex,
        if (mimeType != null) 'mime_type': mimeType,
      });

      final response = await _dio.post(
        EnvConfig.n8nSttUrl,
        data: formData,
      );

      final data = response.data;
      return {
        'original_text': data['script'] ?? data['original_text'],
        'translated_text': data['translation'] ?? data['translated_text'],
      };
    } catch (e) {
      print("Error sending audio chunk to n8n: $e");
      rethrow;
    }
  }

  /// Fetches visual aids based on keywords
  Future<List<Map<String, dynamic>>> fetchVisualAids({
    required String sessionId,
    required List<String> keywords,
  }) async {
    if (!EnvConfig.isConfigured) {
      return [];
    }

    try {
      final response = await _dio.post(
        EnvConfig.n8nImagesEndpoint,
        data: {
          'session_id': sessionId,
          'keywords': keywords,
        },
      );

      return List<Map<String, dynamic>>.from(response.data['items'] ?? []);
    } catch (e) {
      print("Error fetching visual aids: $e");
      return [];
    }
  }

  /// ... other n8n methods will be added here
}
