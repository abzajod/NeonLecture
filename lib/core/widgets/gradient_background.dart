import 'package:flutter/material.dart';
import '../theme/colors.dart';
import 'neon_particles.dart';

/// Gradient background widget for consistent neon backgrounds
class GradientBackground extends StatelessWidget {
  final Widget child;
  final Gradient? gradient;

  const GradientBackground({
    super.key,
    required this.child,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient ?? NeonColors.bgGradient,
      ),
      child: Stack(
        children: [
          const NeonParticles(color: NeonColors.neonCyan, count: 15),
          const NeonParticles(color: NeonColors.neonPurple, count: 10),
          child,
        ],
      ),
    );
  }
}
