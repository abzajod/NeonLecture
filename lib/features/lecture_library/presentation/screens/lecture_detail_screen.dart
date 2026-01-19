import 'package:flutter/material.dart';
import '../../../lecture_session/domain/entities/lecture_note.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/widgets/gradient_background.dart';
import '../../../../core/widgets/neon_card.dart';
import '../../../lecture_session/presentation/widgets/visual_aid_panel.dart';
import 'package:share_plus/share_plus.dart';

class LectureDetailScreen extends StatelessWidget {
  final LectureNote note;

  const LectureDetailScreen({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(note.title.toUpperCase()),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_rounded),
            onPressed: () => _shareNote(note),
          ),
        ],
      ),
      body: GradientBackground(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            // Summary Section
            _buildSectionHeader('SUMMARY'),
            NeonCard(
              borderColor: NeonColors.neonCyan,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: note.summaryPoints
                    .map((point) => Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('• ',
                                  style: TextStyle(
                                      color: NeonColors.neonCyan,
                                      fontSize: 20)),
                              Expanded(
                                  child: Text(point,
                                      style: NeonTextStyles.bodyLarge)),
                            ],
                          ),
                        ))
                    .toList(),
              ),
            ),

            const SizedBox(height: 32),

            // Visual Aids Section
            _buildSectionHeader('VISUAL AIDS'),
            SizedBox(
              height: 240,
              child: VisualAidPanel(visualAids: note.images),
            ),

            const SizedBox(height: 32),

            // Transcript Tabs
            _buildSectionHeader('TRANSCRIPT'),
            DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  TabBar(
                    indicatorColor: NeonColors.neonCyan,
                    labelColor: NeonColors.neonCyan,
                    unselectedLabelColor: NeonColors.textTertiary,
                    tabs: const [
                      Tab(text: 'ORIGINAL'),
                      Tab(text: 'TRANSLATED'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 300,
                    child: TabBarView(
                      children: [
                        _buildTranscriptView(note.originalTranscript),
                        _buildTranscriptView(note.translatedTranscript),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 12),
      child: Text(
        title,
        style: NeonTextStyles.labelSmall
            .copyWith(color: NeonColors.neonPink, letterSpacing: 2),
      ),
    );
  }

  Widget _buildTranscriptView(String text) {
    return NeonCard(
      borderColor: NeonColors.neonPurple.withValues(alpha: 0.3),
      child: SingleChildScrollView(
        child: Text(
          text,
          style: NeonTextStyles.bodyMedium.copyWith(height: 1.8),
        ),
      ),
    );
  }

  void _shareNote(LectureNote note) async {
    final text = '''
${note.title}
Date: ${note.date}

SUMMARY:
${note.summaryPoints.map((p) => "• $p").join("\n")}

ORIGINAL TRANSCRIPT:
${note.originalTranscript}

TRANSLATED TRANSCRIPT:
${note.translatedTranscript}
    ''';

    await Share.share(text, subject: note.title);
  }
}
