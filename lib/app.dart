import 'package:flutter/material.dart';
import 'core/theme/neon_theme.dart';
import 'features/lecture_session/presentation/screens/onboarding_screen.dart';

/// Main application widget
class NeonLectureApp extends StatelessWidget {
  const NeonLectureApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NeonLecture AI',
      debugShowCheckedModeBanner: false,
      theme: NeonTheme.darkTheme,
      home: const OnboardingScreen(),
    );
  }
}
