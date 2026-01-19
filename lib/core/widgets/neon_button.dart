import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../theme/text_styles.dart';

/// Neon-styled button with glow effect
class NeonButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final Color? textColor;
  final IconData? icon;
  final bool isLoading;
  final bool isOutlined;

  const NeonButton({
    super. key,
    required this.text,
    required this.onPressed,
    this.color,
    this.textColor,
    this.icon,
    this.isLoading = false,
    this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    final buttonColor = color ?? NeonColors.neonCyan;
    final foregroundColor = textColor ?? Colors.white;

    return Container(
      decoration: BoxDecoration(
        gradient: isOutlined ? null : LinearGradient(
          colors: [buttonColor, buttonColor.withOpacity(0.7)],
        ),
        borderRadius: BorderRadius.circular(12),
        border: isOutlined ? Border.all(color: buttonColor, width: 2) : null,
        boxShadow: isOutlined ? null : [
          BoxShadow(
            color: buttonColor.withOpacity(0.5),
            blurRadius: 20,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 32,
              vertical: 16,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isLoading)
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: foregroundColor,
                      strokeWidth: 2,
                    ),
                  )
                else ...[
                  if (icon != null) ...[
                    Icon(icon, color: foregroundColor, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: NeonTextStyles.button.copyWith(
                      color: foregroundColor,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
