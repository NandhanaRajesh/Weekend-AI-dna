import 'package:flutter/material.dart';

/// Animated Glowing Progress Line replacing standard loading indicators.
/// Grows left-to-right from 1.8s to 2.5s with subtle neon glow.
class ProgressLine extends StatelessWidget {
  final Animation<double> progressAnimation;

  const ProgressLine({
    super.key,
    required this.progressAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progressAnimation,
      builder: (context, child) {
        final value = progressAnimation.value.clamp(0.0, 1.0);

        return Container(
          width: 220,
          height: 6,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white.withValues(alpha: 0.1),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.15),
              width: 0.8,
            ),
          ),
          child: Stack(
            children: [
              // Filled glowing progress indicator
              FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: value,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF6C63FF),
                        Color(0xFF8B5CF6),
                        Color(0xFF2DD4BF),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF2DD4BF).withValues(alpha: 0.8),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                      BoxShadow(
                        color: const Color(0xFF6C63FF).withValues(alpha: 0.6),
                        blurRadius: 16,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),

              // Leading edge glowing spark dot
              if (value > 0.02 && value < 0.99)
                Positioned(
                  left: (220 * value) - 6,
                  top: -2,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF2DD4BF),
                          blurRadius: 8,
                          spreadRadius: 3,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
