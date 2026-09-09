import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AnimatedBlobs extends StatefulWidget {
  const AnimatedBlobs({super.key});

  @override
  State<AnimatedBlobs> createState() => _AnimatedBlobsState();
}

class _AnimatedBlobsState extends State<AnimatedBlobs>
    with TickerProviderStateMixin {
  late final List<AnimationController> _controllers;
  late final List<Animation<Offset>> _animations;

  @override
  void initState() {
    super.initState();
    final random = Random(42);
    _controllers = List.generate(5, (i) {
      final durations = [14, 11, 16, 13, 15];
      return AnimationController(
        vsync: this,
        duration: Duration(seconds: durations[i]),
      )..repeat(reverse: true);
    });

    _animations = List.generate(5, (i) {
      return Tween<Offset>(
        begin: Offset.zero,
        end: Offset(
          (random.nextDouble() - 0.5) * 60,
          (random.nextDouble() - 0.5) * 60,
        ),
      ).animate(CurvedAnimation(
        parent: _controllers[i],
        curve: Curves.easeInOut,
      ));
    });
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sizes = [420.0, 350.0, 280.0, 200.0, 160.0];
    final positions = [
      const Offset(-0.08, -0.10),
      const Offset(0.94, 1.12),
      const Offset(0.60, 0.55),
      const Offset(0.85, 0.20),
      const Offset(0.15, 0.80),
    ];

    return Positioned.fill(
      child: Stack(
        children: List.generate(5, (i) {
          return AnimatedBuilder(
            animation: _animations[i],
            builder: (context, child) {
              return Positioned(
                left: MediaQuery.of(context).size.width * positions[i].dx -
                    sizes[i] / 2 +
                    _animations[i].value.dx,
                top: MediaQuery.of(context).size.height * positions[i].dy -
                    sizes[i] / 2 +
                    _animations[i].value.dy,
                child: Container(
                  width: sizes[i],
                  height: sizes[i],
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.blobColors[i].withOpacity(0.5),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
