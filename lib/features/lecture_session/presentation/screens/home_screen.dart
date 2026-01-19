import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/widgets/gradient_background.dart';
import '../../../../core/widgets/neon_button.dart';
import '../../../../core/widgets/neon_card.dart';
import '../../../../core/utils/haptic_utils.dart';
import 'live_lecture_screen.dart';
import '../../../lecture_library/presentation/screens/my_lectures_screen.dart';
import '../../../settings/presentation/settings_screen.dart';

/// Home screen of the application
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // App Title
                FadeInDown(
                  duration: const Duration(milliseconds: 600),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'NeonLecture',
                        style: NeonTextStyles.displayLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'AI-Powered Live Lecture Assistant',
                        style: NeonTextStyles.bodyLarge.copyWith(
                          color: NeonColors.neonPurple,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 48),

                // Main Action Card
                Expanded(
                  child: FadeInUp(
                    duration: const Duration(milliseconds: 600),
                    delay: const Duration(milliseconds: 200),
                    child: Center(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Hero Icon
                            Container(
                              padding: const EdgeInsets.all(32),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: NeonColors.neonGradient,
                                boxShadow: [
                                  BoxShadow(
                                    color: NeonColors.neonCyan.withValues(alpha: 0.5),
                                    blurRadius: 40,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.mic,
                                size: 80,
                                color: Colors.white,
                              ),
                            ),

                            const SizedBox(height: 48),

                            // Start Button
                            NeonButton(
                              text: 'Start New Lecture',
                              icon: Icons.play_arrow_rounded,
                              color: NeonColors.neonCyan,
                              onPressed: () {
                                HapticUtils.mediumImpact();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const LiveLectureScreen()),
                                );
                              },
                            ),

                            const SizedBox(height: 24),

                            // My Lectures Button
                            NeonButton(
                              text: 'My Lectures',
                              icon: Icons.library_books,
                              color: NeonColors.neonPurple,
                              isOutlined: true,
                              onPressed: () {
                                HapticUtils.lightImpact();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const MyLecturesScreen()),
                                );
                              },
                            ),

                            const SizedBox(height: 48),

                            // Feature Cards
                            _buildFeatureCards(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Settings Button
                FadeIn(
                  duration: const Duration(milliseconds: 600),
                  delay: const Duration(milliseconds: 400),
                  child: Center(
                    child: TextButton.icon(
                      onPressed: () {
                        HapticUtils.selectionClick();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SettingsScreen()),
                        );
                      },
                      icon: const Icon(Icons.settings, size: 20),
                      label: Text(
                        'Settings',
                        style: NeonTextStyles.labelLarge,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCards() {
    return Row(
      children: [
        Expanded(
          child: NeonCard(
            borderColor: NeonColors.neonCyan,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Icon(
                  Icons.translate,
                  size: 32,
                  color: NeonColors.neonCyan,
                ),
                const SizedBox(height: 8),
                Text(
                  'Real-time\nTranslation',
                  style: NeonTextStyles.labelMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: NeonCard(
            borderColor: NeonColors.neonPurple,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Icon(
                  Icons.image,
                  size: 32,
                  color: NeonColors.neonPurple,
                ),
                const SizedBox(height: 8),
                Text(
                  'Visual\nAids',
                  style: NeonTextStyles.labelMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: NeonCard(
            borderColor: NeonColors.neonPink,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Icon(
                  Icons.description,
                  size: 32,
                  color: NeonColors.neonPink,
                ),
                const SizedBox(height: 8),
                Text(
                  'Smart\nNotes',
                  style: NeonTextStyles.labelMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
