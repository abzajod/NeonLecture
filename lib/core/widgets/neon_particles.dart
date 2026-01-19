import 'dart:math';
import 'package:flutter/material.dart';

class NeonParticles extends StatefulWidget {
  final Color color;
  final int count;

  const NeonParticles({
    super.key,
    this.color = Colors.cyan,
    this.count = 20,
  });

  @override
  State<NeonParticles> createState() => _NeonParticlesState();
}

class _NeonParticlesState extends State<NeonParticles>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Particle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    for (int i = 0; i < widget.count; i++) {
      _particles.add(Particle(
        position: Offset(_random.nextDouble(), _random.nextDouble()),
        velocity: Offset((_random.nextDouble() - 0.5) * 0.002,
            (_random.nextDouble() - 0.5) * 0.002),
        size: _random.nextDouble() * 3 + 1,
        opacity: _random.nextDouble() * 0.5 + 0.2,
      ));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        for (var p in _particles) {
          p.move();
        }
        return CustomPaint(
          painter: ParticlePainter(
            particles: _particles,
            color: widget.color,
          ),
          child: Container(),
        );
      },
    );
  }
}

class Particle {
  Offset position;
  Offset velocity;
  double size;
  double opacity;

  Particle({
    required this.position,
    required this.velocity,
    required this.size,
    required this.opacity,
  });

  void move() {
    position += velocity;
    if (position.dx < 0) position = Offset(1.0, position.dy);
    if (position.dx > 1) position = Offset(0.0, position.dy);
    if (position.dy < 0) position = Offset(position.dx, 1.0);
    if (position.dy > 1) position = Offset(position.dx, 0.0);
  }
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final Color color;

  ParticlePainter({required this.particles, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    for (var p in particles) {
      final paint = Paint()
        ..color = color.withValues(alpha: p.opacity)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, p.size);

      canvas.drawCircle(
        Offset(p.position.dx * size.width, p.position.dy * size.height),
        p.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
