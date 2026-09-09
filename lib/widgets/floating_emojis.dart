import 'dart:math';
import 'package:flutter/material.dart';

class FloatingEmojis extends StatefulWidget {
  const FloatingEmojis({super.key});

  @override
  State<FloatingEmojis> createState() => _FloatingEmojisState();
}

class _FloatingEmojisState extends State<FloatingEmojis>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final List<_EmojiData> _emojis = [];

  @override
  void initState() {
    super.initState();
    final random = Random(42);
    final emojiList = ['✨', '🌸', '⭐', '💖', '✨', '🍀'];

    for (var i = 0; i < emojiList.length; i++) {
      _emojis.add(_EmojiData(
        emoji: emojiList[i],
        x: 0.08 + random.nextDouble() * 0.84,
        delay: random.nextDouble() * 10,
        duration: 16 + random.nextDouble() * 6,
        size: 1.0 + random.nextDouble() * 0.6,
      ));
    }

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 22),
    )..repeat();
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
        return Positioned.fill(
          child: Stack(
            children: _emojis.map((data) {
              final progress = (_controller.value * data.duration + data.delay) %
                  data.duration;
              final normalized = progress / data.duration;
              final screenHeight = MediaQuery.of(context).size.height;
              final y = screenHeight * (1 - normalized);

              return Positioned(
                left: MediaQuery.of(context).size.width * data.x,
                top: y,
                child: Opacity(
                  opacity: normalized < 0.1
                      ? normalized * 7
                      : normalized > 0.9
                          ? (1 - normalized) * 7
                          : 0.7,
                  child: Transform.rotate(
                    angle: normalized * 2 * pi,
                    child: Text(
                      data.emoji,
                      style: TextStyle(fontSize: 24 * data.size),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

class _EmojiData {
  final String emoji;
  final double x;
  final double delay;
  final double duration;
  final double size;

  _EmojiData({
    required this.emoji,
    required this.x,
    required this.delay,
    required this.duration,
    required this.size,
  });
}
