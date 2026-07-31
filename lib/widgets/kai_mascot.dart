import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

enum KaiExpression { happy, winking, excited, thinking }

/// Animated vector Kai Mascot widget with expressive eyes, antenna sparkle,
/// mischievous grin, waving arms, and squash-and-stretch micro-animations.
class KaiMascot extends StatefulWidget {
  final double size;
  final KaiExpression expression;

  const KaiMascot({
    super.key,
    this.size = 72.0,
    this.expression = KaiExpression.excited,
  });

  @override
  State<KaiMascot> createState() => _KaiMascotState();
}

class _KaiMascotState extends State<KaiMascot>
    with SingleTickerProviderStateMixin {
  late AnimationController _idleController;

  @override
  void initState() {
    super.initState();
    _idleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _idleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _idleController,
      builder: (context, child) {
        // Idle squash-and-stretch math
        final squashY = 1.0 - (_idleController.value * 0.04);
        final stretchX = 1.0 + (_idleController.value * 0.04);
        final armWaveAngle = math.sin(_idleController.value * math.pi * 2) * 0.25;

        return Transform.scale(
          scaleX: stretchX,
          scaleY: squashY,
          child: CustomPaint(
            size: Size(widget.size, widget.size * 1.1),
            painter: _KaiMascotPainter(
              expression: widget.expression,
              pulse: _idleController.value,
              armWaveAngle: armWaveAngle,
            ),
          ),
        );
      },
    );
  }
}

class _KaiMascotPainter extends CustomPainter {
  final KaiExpression expression;
  final double pulse;
  final double armWaveAngle;

  _KaiMascotPainter({
    required this.expression,
    required this.pulse,
    required this.armWaveAngle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.55);
    final radius = size.width * 0.42;

    // 1. Floating Antenna Sparkle
    final antennaTop = Offset(center.dx, center.dy - radius - 16);
    final antennaBase = Offset(center.dx, center.dy - radius + 2);

    final antennaPaint = Paint()
      ..color = const Color(0xFFFFD166)
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(antennaBase, antennaTop, antennaPaint);

    // Antenna Sparkle Star
    final starSize = 7.0 + (pulse * 2.0);
    final starPath = Path();
    starPath.moveTo(antennaTop.dx, antennaTop.dy - starSize);
    starPath.quadraticBezierTo(antennaTop.dx, antennaTop.dy, antennaTop.dx + starSize, antennaTop.dy);
    starPath.quadraticBezierTo(antennaTop.dx, antennaTop.dy, antennaTop.dx, antennaTop.dy + starSize);
    starPath.quadraticBezierTo(antennaTop.dx, antennaTop.dy, antennaTop.dx - starSize, antennaTop.dy);
    starPath.quadraticBezierTo(antennaTop.dx, antennaTop.dy, antennaTop.dx, antennaTop.dy - starSize);
    starPath.close();

    final starPaint = Paint()
      ..shader = ui.Gradient.radial(
        antennaTop,
        starSize,
        [const Color(0xFFFFFFFF), const Color(0xFFFFD166)],
      );
    canvas.drawPath(starPath, starPaint);

    // 2. Main Blob Body (Warm Coral to Sunburst Yellow Gradient)
    final bodyPaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(center.dx - radius, center.dy - radius),
        Offset(center.dx + radius, center.dy + radius),
        [
          const Color(0xFFFF7A59), // Coral
          const Color(0xFFFFB703), // Golden Orange
          const Color(0xFFFFD166), // Yellow
        ],
      );

    // Drop shadow under body
    canvas.drawCircle(
      center + const Offset(0, 4),
      radius,
      Paint()
        ..color = const Color(0x40FF7A59)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12),
    );

    // Blob shape
    canvas.drawCircle(center, radius, bodyPaint);

    // Highlights for 3D volume
    final highlightPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.35);
    canvas.drawCircle(
      center + Offset(-radius * 0.3, -radius * 0.3),
      radius * 0.25,
      highlightPaint,
    );

    // 3. Tiny Stubby Arms
    final leftArmPath = Path()
      ..moveTo(center.dx - radius + 4, center.dy)
      ..quadraticBezierTo(
        center.dx - radius - 12,
        center.dy - 6 + (armWaveAngle * 10),
        center.dx - radius - 6,
        center.dy + 10,
      )
      ..close();
    canvas.drawPath(leftArmPath, Paint()..color = const Color(0xFFFF7A59));

    // Right Waving Arm (Presenting pose)
    canvas.save();
    canvas.translate(center.dx + radius - 4, center.dy);
    canvas.rotate(-0.4 + armWaveAngle);
    final rightArmPath = Path()
      ..moveTo(0, 0)
      ..quadraticBezierTo(14, -12, 18, -2)
      ..quadraticBezierTo(10, 8, 0, 8)
      ..close();
    canvas.drawPath(rightArmPath, Paint()..color = const Color(0xFFFFB703));
    canvas.restore();

    // 4. Expressive Eyes
    final eyePaint = Paint()..color = const Color(0xFF0F0E1A);
    final pupilPaint = Paint()..color = Colors.white;

    final leftEyeCenter = Offset(center.dx - radius * 0.32, center.dy - radius * 0.12);
    final rightEyeCenter = Offset(center.dx + radius * 0.32, center.dy - radius * 0.12);

    // Left Eye (Big and open)
    canvas.drawCircle(leftEyeCenter, 6.5, eyePaint);
    canvas.drawCircle(leftEyeCenter + const Offset(-1.5, -1.5), 2.2, pupilPaint);

    // Right Eye (Winking arc if winking / excited)
    if (expression == KaiExpression.winking || expression == KaiExpression.excited) {
      final winkPath = Path()
        ..moveTo(rightEyeCenter.dx - 6, rightEyeCenter.dy + 1)
        ..quadraticBezierTo(
          rightEyeCenter.dx,
          rightEyeCenter.dy - 6,
          rightEyeCenter.dx + 6,
          rightEyeCenter.dy + 1,
        );
      final winkPaint = Paint()
        ..color = const Color(0xFF0F0E1A)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0
        ..strokeCap = StrokeCap.round;
      canvas.drawPath(winkPath, winkPaint);
    } else {
      canvas.drawCircle(rightEyeCenter, 6.5, eyePaint);
      canvas.drawCircle(rightEyeCenter + const Offset(-1.5, -1.5), 2.2, pupilPaint);
    }

    // 5. Mischievous Lopsided Grin
    final mouthPath = Path()
      ..moveTo(center.dx - 10, center.dy + 10)
      ..quadraticBezierTo(
        center.dx + 2,
        center.dy + 22,
        center.dx + 12,
        center.dy + 8,
      );

    final mouthPaint = Paint()
      ..color = const Color(0xFF0F0E1A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(mouthPath, mouthPaint);

    // Cheerful Pink Cheeks
    final cheekPaint = Paint()..color = const Color(0xFFFF5252).withValues(alpha: 0.45);
    canvas.drawCircle(center + Offset(-radius * 0.48, radius * 0.18), 5.5, cheekPaint);
    canvas.drawCircle(center + Offset(radius * 0.48, radius * 0.18), 5.5, cheekPaint);
  }

  @override
  bool shouldRepaint(covariant _KaiMascotPainter oldDelegate) {
    return oldDelegate.pulse != pulse || oldDelegate.expression != expression;
  }
}
