import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';
import '../widgets/neon_button.dart';

class ErrorDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onRetry;

  const ErrorDialog({
    super.key,
    this.title = 'Oops! Something went wrong',
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: NeonColors.cardBg.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: NeonColors.error.withValues(alpha: 0.3)),
          boxShadow: [
            BoxShadow(
              color: NeonColors.error.withValues(alpha: 0.2),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: NeonColors.error,
              size: 48,
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: NeonTextStyles.headlineSmall.copyWith(color: NeonColors.error),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: NeonTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'Dismiss',
                      style: NeonTextStyles.labelLarge.copyWith(color: NeonColors.textTertiary),
                    ),
                  ),
                ),
                if (onRetry != null) ...[
                  const SizedBox(width: 16),
                  Expanded(
                    child: NeonButton(
                      text: 'Retry',
                      color: NeonColors.error,
                      onPressed: () {
                        Navigator.pop(context);
                        onRetry!();
                      },
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  static void show(BuildContext context, {
    String? title,
    required String message,
    VoidCallback? onRetry,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => ErrorDialog(
        title: title ?? 'Connection Error',
        message: message,
        onRetry: onRetry,
      ),
    );
  }
}
