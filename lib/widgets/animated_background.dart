import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

/// Animated Mesh Background with dynamic color transitions, subtle noise texture, and vignette.
class AnimatedBackground extends StatefulWidget {
  const AnimatedBackground({super.key});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // Ultra smooth, slow looping animation (16 seconds duration)
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 16),
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
      builder: (context, child) {
        return CustomPaint(
          size: Size.infinite,
          painter: MeshGradientPainter(progress: _controller.value),
        );
      },
    );
  }
}

class MeshGradientPainter extends CustomPainter {
  final double progress;

  MeshGradientPainter({required this.progress});

  // Target palette: #6C63FF, #8B5CF6, #FF7A59, #2DD4BF
  static const Color c1 = Color(0xFF6C63FF);
  static const Color c2 = Color(0xFF8B5CF6);
  static const Color c3 = Color(0xFFFF7A59);
  static const Color c4 = Color(0xFF2DD4BF);

  @override
  void paint(Canvas canvas, Size size) {
    final t = progress * 2 * math.pi;

    // Background base dark tint for deep pop
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = const Color(0xFF0F0E1A),
    );

    // Orbiting focal centers for the mesh blobs
    final p1 = Offset(
      size.width * (0.3 + 0.25 * math.sin(t)),
      size.height * (0.2 + 0.2 * math.cos(t * 0.8)),
    );
    final p2 = Offset(
      size.width * (0.7 + 0.2 * math.cos(t * 1.1)),
      size.height * (0.4 + 0.25 * math.sin(t * 0.7)),
    );
    final p3 = Offset(
      size.width * (0.4 + 0.3 * math.sin(t * 0.9 + 1)),
      size.height * (0.8 + 0.15 * math.cos(t * 1.2)),
    );
    final p4 = Offset(
      size.width * (0.8 + 0.15 * math.cos(t * 0.6 + 2)),
      size.height * (0.7 + 0.2 * math.sin(t * 1.3 + 1)),
    );

    final maxDim = math.max(size.width, size.height);

    // Draw mesh gradient metaball layers with BlendMode.plus for fluid luxury blending
    _drawBlob(canvas, p1, maxDim * 0.75, c1, BlendMode.screen);
    _drawBlob(canvas, p2, maxDim * 0.70, c2, BlendMode.screen);
    _drawBlob(canvas, p3, maxDim * 0.65, c3, BlendMode.screen);
    _drawBlob(canvas, p4, maxDim * 0.60, c4, BlendMode.screen);

    // Subtle Noise Texture Pass
    _paintNoiseTexture(canvas, size);

    // Vignette Pass
    final vignettePaint = Paint()
      ..shader = ui.Gradient.radial(
        Offset(size.width / 2, size.height / 2),
        maxDim * 0.75,
        [
          Colors.transparent,
          const Color(0x400A0A12),
          const Color(0xB306060A),
        ],
        [0.4, 0.8, 1.0],
      );
    canvas.drawRect(Offset.zero & size, vignettePaint);
  }

  void _drawBlob(Canvas canvas, Offset center, double radius, Color color, BlendMode blendMode) {
    final paint = Paint()
      ..blendMode = blendMode
      ..shader = ui.Gradient.radial(
        center,
        radius,
        [
          color.withValues(alpha: 0.65),
          color.withValues(alpha: 0.3),
          color.withValues(alpha: 0.0),
        ],
        [0.0, 0.5, 1.0],
      );
    canvas.drawCircle(center, radius, paint);
  }

  void _paintNoiseTexture(Canvas canvas, Size size) {
    // Generate fine subtle noise stippling overlay for tactile premium feel
    final noisePaint = Paint()..strokeWidth = 1.0;
    final random = math.Random(42); // Consistent seed for stable texture distribution

    final dotCount = (size.width * size.height / 450).clamp(600, 2500).toInt();
    for (int i = 0; i < dotCount; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final alpha = random.nextDouble() * 0.03 + 0.01;
      final isWhite = random.nextBool();
      
      noisePaint.color = isWhite 
          ? Colors.white.withValues(alpha: alpha)
          : Colors.black.withValues(alpha: alpha * 1.5);
      
      canvas.drawOffset(Offset(x, y), noisePaint);
    }
  }

  @override
  bool shouldRepaint(covariant MeshGradientPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

extension CanvasOffset on Canvas {
  void drawOffset(Offset p, Paint paint) {
    drawPoints(ui.PointMode.points, [p], paint);
  }
}
