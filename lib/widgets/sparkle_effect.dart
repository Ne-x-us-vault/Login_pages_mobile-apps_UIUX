import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class SparkleEffect extends StatefulWidget {
  final Offset position;
  final VoidCallback onComplete;

  const SparkleEffect({
    super.key,
    required this.position,
    required this.onComplete,
  });

  @override
  State<SparkleEffect> createState() => _SparkleEffectState();
}

class _SparkleEffectState extends State<SparkleEffect>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<_Sparkle> _sparkles;

  @override
  void initState() {
    super.initState();
    final random = Random();
    _sparkles = List.generate(8, (i) {
      final angle = (2 * pi * i) / 8;
      final distance = 20 + random.nextDouble() * 18;
      return _Sparkle(
        offset: Offset(cos(angle) * distance, sin(angle) * distance),
        color: AppColors.sparkleColors[i % AppColors.sparkleColors.length],
      );
    });

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward().then((_) => widget.onComplete());
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
      builder: (context, _) {
        return CustomPaint(
          size: const Size(100, 100),
          painter: _SparklePainter(
            sparkles: _sparkles,
            progress: _controller.value,
          ),
        );
      },
    );
  }
}

class _Sparkle {
  final Offset offset;
  final Color color;

  _Sparkle({required this.offset, required this.color});
}

class _SparklePainter extends CustomPainter {
  final List<_Sparkle> sparkles;
  final double progress;

  _SparklePainter({required this.sparkles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (final sparkle in sparkles) {
      final paint = Paint()
        ..color = sparkle.color.withValues(alpha: 1 - progress)
        ..style = PaintingStyle.fill;

      final position = Offset(
        size.width / 2 + sparkle.offset.dx * progress,
        size.height / 2 + sparkle.offset.dy * progress,
      );

      canvas.drawCircle(position, 3 * (1 - progress), paint);
    }
  }

  @override
  bool shouldRepaint(_SparklePainter oldDelegate) => true;
}
