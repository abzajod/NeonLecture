import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/session_manager.dart';
import '../widgets/subtitle_display.dart';
import '../widgets/visual_aid_panel.dart';
import '../../../../core/widgets/gradient_background.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/widgets/neon_button.dart';

class LiveLectureScreen extends ConsumerWidget {
  final bool saveToHistory;

  const LiveLectureScreen({
    super.key,
    this.saveToHistory = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionState = ref.watch(sessionManagerProvider);
    final sessionManager = ref.read(sessionManagerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          sessionState.isRecording ? 'LIVE SESSION' : 'NEW SESSION',
          style: NeonTextStyles.headlineMedium.copyWith(
            color: sessionState.isRecording
                ? NeonColors.error
                : NeonColors.neonCyan,
          ),
        ),
        actions: [
          if (sessionState.isRecording)
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildDurationBadge(sessionState.duration),
                  if (sessionState.errorMessage != null) ...[
                    const SizedBox(width: 12),
                    _buildErrorIndicator(sessionState.errorMessage!),
                  ],
                ],
              ),
            ),
        ],
      ),
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Subtitle Area
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SubtitleDisplay(
                    originalLines: sessionState.transcript,
                    translatedLines: sessionState.translatedText,
                  ),
                ),
              ),

              // Image/Visual Aids Area
              Expanded(
                flex: 2,
                child: VisualAidPanel(
                  visualAids: sessionState.visualAids,
                ),
              ),

              // Controls
              _buildControls(context, sessionState, sessionManager),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDurationBadge(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: NeonColors.darkBg.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: NeonColors.neonPurple.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: NeonColors.error,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            "$twoDigitMinutes:$twoDigitSeconds",
            style: NeonTextStyles.labelMedium.copyWith(color: NeonColors.error),
          ),
        ],
      ),
    );
  }

  Widget _buildControls(
      BuildContext context, SessionState state, SessionManager manager) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: NeonColors.darkBg,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if (!state.isRecording)
            NeonButton(
              text: 'START RECORDING',
              icon: Icons.mic,
              color: NeonColors.neonCyan,
              onPressed: () =>
                  manager.startSession(saveToHistory: saveToHistory),
            )
          else ...[
            // Stop button
            IconButton(
              onPressed: () => manager.stopSession(),
              icon: const Icon(Icons.stop_circle,
                  size: 64, color: NeonColors.error),
            ),

            // Pause/Resume
            IconButton(
              onPressed: () {
                if (state.isPaused) {
                  manager.resumeSession();
                } else {
                  manager.pauseSession();
                }
              },
              icon: Icon(
                state.isPaused ? Icons.play_circle : Icons.pause_circle,
                size: 64,
                color: NeonColors.neonCyan,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildErrorIndicator(String message) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: NeonColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: NeonColors.error.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 14, color: NeonColors.error),
          const SizedBox(width: 4),
          Text(
            'ERROR',
            style: NeonTextStyles.labelSmall.copyWith(color: NeonColors.error),
          ),
        ],
      ),
    );
  }
}
