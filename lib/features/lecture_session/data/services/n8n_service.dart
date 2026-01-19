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
  }) async {
    if (!EnvConfig.isConfigured) {
      // Mock response if not configured
      await Future.delayed(const Duration(seconds: 1));
      return {
        'original_text': 'This is a mock transcription of the audio chunk.',
        'translated_text': 'هذا ترجمة وهمية للمقطع الصوتي.',
      };
    }

    try {
      final formData = FormData.fromMap({
        'session_id': sessionId,
        'audio': MultipartFile.fromBytes(audioData, filename: 'chunk.wav'),
        'source_lang': sourceLang,
        'target_lang': targetLang,
      });

      final response = await _dio.post(
        EnvConfig.n8nSttUrl,
        data: formData,
      );

      return response.data;
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
