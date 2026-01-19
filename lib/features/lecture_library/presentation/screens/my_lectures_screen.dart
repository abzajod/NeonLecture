import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/widgets/gradient_background.dart';
import '../../../../core/widgets/neon_card.dart';
import '../../../lecture_session/domain/entities/lecture_note.dart';
import '../../presentation/screens/lecture_detail_screen.dart';
import '../../../lecture_session/data/services/session_manager.dart';

class MyLecturesScreen extends ConsumerStatefulWidget {
  const MyLecturesScreen({super.key});

  @override
  ConsumerState<MyLecturesScreen> createState() => _MyLecturesScreenState();
}

class _MyLecturesScreenState extends ConsumerState<MyLecturesScreen> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repository = ref.watch(lectureRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('MY LECTURES'),
      ),
      body: GradientBackground(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              _buildSearchBar(),
              const SizedBox(height: 24),
              
              Text(
                'Past Sessions',
                style: NeonTextStyles.headlineMedium.copyWith(color: NeonColors.neonPurple),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: repository.lecturesListenable,
                  builder: (context, Box<LectureNote> box, _) {
                    final allLectures = box.values.toList()..sort((a, b) => b.date.compareTo(a.date));
                    final filteredLectures = allLectures.where((l) => 
                      l.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                      l.originalTranscript.toLowerCase().contains(_searchQuery.toLowerCase())
                    ).toList();

                    if (filteredLectures.isEmpty) {
                      return _buildEmptyState();
                    }

                    return ListView.separated(
                      itemCount: filteredLectures.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        return _buildLectureCard(context, filteredLectures[index]);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: NeonColors.cardBg.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: NeonColors.neonCyan.withValues(alpha: 0.3)),
      ),
      child: TextField(
        controller: _searchController,
        style: NeonTextStyles.bodyMedium,
        decoration: InputDecoration(
          hintText: 'Search lectures...',
          prefixIcon: const Icon(Icons.search, color: NeonColors.neonCyan),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.library_books_outlined, size: 64, color: NeonColors.textTertiary),
          const SizedBox(height: 16),
          Text(
            'No lectures saved yet.',
            style: NeonTextStyles.bodyLarge.copyWith(color: NeonColors.textTertiary),
          ),
        ],
      ),
    );
  }

  Widget _buildLectureCard(BuildContext context, LectureNote note) {
    return NeonCard(
      borderColor: NeonColors.neonCyan,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LectureDetailScreen(note: note)),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  note.title, 
                  style: NeonTextStyles.headlineSmall,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                "${note.date.year}-${note.date.month.toString().padLeft(2, '0')}-${note.date.day.toString().padLeft(2, '0')}", 
                style: NeonTextStyles.labelSmall,
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.delete_outline, color: NeonColors.error, size: 20),
                onPressed: () => _confirmDelete(context, ref, note.id),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            note.originalTranscript.length > 100 
                ? "${note.originalTranscript.substring(0, 100)}..."
                : note.originalTranscript.isEmpty ? "No transcript recorded." : note.originalTranscript,
            style: NeonTextStyles.bodyMedium,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildBadge(Icons.translate, '${note.sourceLanguage.toUpperCase()} → ${note.targetLanguage.toUpperCase()}'),
              const SizedBox(width: 8),
              _buildBadge(Icons.timer, '${note.duration.inMinutes} min'),
              const SizedBox(width: 8),
              _buildBadge(Icons.image, '${note.images.length} aids'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: NeonColors.neonCyan.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: NeonColors.neonCyan.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: NeonColors.neonCyan),
          const SizedBox(width: 4),
          Text(text, style: NeonTextStyles.labelSmall.copyWith(color: NeonColors.neonCyan)),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: NeonColors.darkBg,
        title: Text('Delete Lecture?', style: NeonTextStyles.headlineSmall.copyWith(color: NeonColors.error)),
        content: Text('This action cannot be undone.', style: NeonTextStyles.bodyMedium),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('CANCEL', style: NeonTextStyles.labelLarge),
          ),
          TextButton(
            onPressed: () {
              ref.read(lectureRepositoryProvider).deleteLecture(id);
              Navigator.pop(context);
              setState(() {}); // Refresh list
            },
            child: Text('DELETE', style: NeonTextStyles.labelLarge.copyWith(color: NeonColors.error)),
          ),
        ],
      ),
    );
  }
}
