import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:animate_do/animate_do.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../domain/entities/visual_aid.dart';

/// Panel to display visual aids (images + captions)
class VisualAidPanel extends StatelessWidget {
  final List<VisualAid> visualAids;

  const VisualAidPanel({
    super.key,
    required this.visualAids,
  });

  @override
  Widget build(BuildContext context) {
    if (visualAids.isEmpty) {
      return Center(
        child: Text(
          'Visual aids will appear here based on the lecture content.',
          style: NeonTextStyles.bodySmall.copyWith(color: NeonColors.textTertiary),
          textAlign: TextAlign.center,
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      scrollDirection: Axis.horizontal,
      itemCount: visualAids.length,
      separatorBuilder: (context, index) => const SizedBox(width: 16),
      itemBuilder: (context, index) {
        final aid = visualAids[index];
        return FadeInRight(
          duration: const Duration(milliseconds: 500),
          child: _buildImageCard(context, aid),
        );
      },
    );
  }

  Widget _buildImageCard(BuildContext context, VisualAid aid) {
    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: NeonColors.cardBg.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: NeonColors.neonPurple.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: NeonColors.neonPurple.withValues(alpha: 0.2),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: CachedNetworkImage(
              imageUrl: aid.imageUrl,
              height: 140,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: NeonColors.surfaceBg,
                child: const Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (context, url, error) => Container(
                color: NeonColors.surfaceBg,
                child: const Icon(Icons.broken_image, color: NeonColors.neonPink),
              ),
            ),
          ),
          
          // Keyword & Caption
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  aid.keyword.toUpperCase(),
                  style: NeonTextStyles.labelSmall.copyWith(
                    color: NeonColors.neonPink,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  aid.caption,
                  style: NeonTextStyles.bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
