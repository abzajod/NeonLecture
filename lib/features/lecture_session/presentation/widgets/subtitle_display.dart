import 'package:flutter/material.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_styles.dart';

/// Displays live subtitles with dual-language support
class SubtitleDisplay extends StatelessWidget {
  final List<String> originalLines;
  final List<String> translatedLines;

  const SubtitleDisplay({
    super.key,
    required this.originalLines,
    required this.translatedLines,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: NeonColors.cardBg.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: NeonColors.neonCyan.withValues(alpha: 0.3),
        ),
      ),
      child: ListView.builder(
        reverse: true, // Newest subtitles at the bottom
        shrinkWrap: true,
        itemCount: originalLines.length,
        itemBuilder: (context, index) {
          final reverseIndex = originalLines.length - 1 - index;
          return Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Original Text
                Text(
                  originalLines[reverseIndex],
                  style: NeonTextStyles.subtitle,
                ),
                const SizedBox(height: 8),
                // Translated Text
                Text(
                  translatedLines[reverseIndex],
                  style: NeonTextStyles.subtitleTranslated,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
