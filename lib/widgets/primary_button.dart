import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'sparkle_effect.dart';

class PrimaryButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  final List<_SparkleData> _sparkles = [];
  int _sparkleId = 0;

  void _addSparkle(Offset position) {
    setState(() {
      _sparkles.add(_SparkleData(id: _sparkleId++, position: position));
    });
  }

  void _removeSparkle(int id) {
    setState(() {
      _sparkles.removeWhere((s) => s.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        _addSparkle(details.localPosition);
        widget.onPressed?.call();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.pink, AppColors.lavender],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: AppColors.pink.withValues(alpha: 0.35),
              blurRadius: 18,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(
              widget.isLoading ? '✨ Loading...' : widget.text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 16,
                letterSpacing: 0.1,
              ),
            ),
            ..._sparkles.map((sparkle) {
              return Positioned(
                left: sparkle.position.dx - 50,
                top: sparkle.position.dy - 50,
                child: SparkleEffect(
                  position: sparkle.position,
                  onComplete: () => _removeSparkle(sparkle.id),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _SparkleData {
  final int id;
  final Offset position;

  _SparkleData({required this.id, required this.position});
}
