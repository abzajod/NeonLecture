import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app.dart';
import 'features/lecture_library/data/repositories/lecture_repository.dart';
import 'features/settings/data/settings_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  try {
    await dotenv.load(fileName: '.env');
  } catch (e) {
    debugPrint('Warning: .env file not found. Using default configuration.');
  }

  // Initialize Local Database
  await LectureRepository.init();
  await SettingsRepository.init();

  runApp(
    const ProviderScope(
      child: NeonLectureApp(),
    ),
  );
}
