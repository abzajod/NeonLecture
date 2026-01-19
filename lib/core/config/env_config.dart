import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Environment configuration for n8n endpoints and other services
class EnvConfig {
  EnvConfig._();

  static String get n8nBaseUrl => dotenv.env['N8N_BASE_URL'] ?? '';
  static String get n8nSttEndpoint => dotenv.env['N8N_STT_ENDPOINT'] ?? '';
  static String get n8nImagesEndpoint =>
      dotenv.env['N8N_IMAGES_ENDPOINT'] ?? '';
  static String get n8nSummaryEndpoint =>
      dotenv.env['N8N_SUMMARY_ENDPOINT'] ?? '';

  // Helper to get full URLs
  // Production Webhook URL
  static String get n8nSttUrl =>
      'https://nonmediative-suitably-ellen.ngrok-free.dev/webhook/neon-lecture';
  static String get sttUrl => n8nSttUrl;
  static String get imagesUrl => '$n8nBaseUrl$n8nImagesEndpoint';
  static String get summaryUrl => '$n8nBaseUrl$n8nSummaryEndpoint';

  // Validate configuration
  static bool get isConfigured => true; // n8nBaseUrl.isNotEmpty;
}
