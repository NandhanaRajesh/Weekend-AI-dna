import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

/// AI Thinking Loading Step (Step 9 of 9) in storybook UI style featuring Kai in deep concentration pose,
/// rotating goofy thinking lines every 1.5s, 3-star constellation fill, and minimum 2.5s execution timer.
class AiThinkingStep extends StatefulWidget {
  final VoidCallback onComplete;

  const AiThinkingStep({
    super.key,
    required this.onComplete,
  });

  static const List<String> thinkingLines = [
    "Cross-referencing your vibe with the weather...",
    "Politely fighting your friends' bad ideas for you... 🤺",
    "Double-checking that café isn't closed on Sundays... ☕",
    "Doing math. I hate math. Doing it anyway, for you. 🧮",
    "Almost there — just adding a little chaos for flavor 🌶️",
  ];

  @override
  State<AiThinkingStep> createState() => _AiThinkingStepState();
}

class _AiThinkingStepState extends State<AiThinkingStep>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;
  Timer? _lineTimer;
  Timer? _completeTimer;

  int _lineIndex = 0;
  int _starCount = 1;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    // Cycle thinking lines & star constellation every 1.5 seconds
    _lineTimer = Timer.periodic(const Duration(milliseconds: 1500), (timer) {
      if (mounted) {
        setState(() {
          _lineIndex = (_lineIndex + 1) % AiThinkingStep.thinkingLines.length;
          _starCount = (_starCount % 3) + 1;
        });
      }
    });

    // Enforce minimum 2.5s loading time for narrative hook
    _completeTimer = Timer(const Duration(milliseconds: 2800), () {
      if (mounted) {
        widget.onComplete();
      }
    });
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _lineTimer?.cancel();
    _completeTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Dynamic Rotating Speech Bubble
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 350),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(scale: animation, child: child),
              );
            },
            child: Container(
              key: ValueKey<int>(_lineIndex),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1B33).withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: const Color(0xFF2DD4BF), width: 1.5),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x602DD4BF),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: Text(
                AiThinkingStep.thinkingLines[_lineIndex],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  height: 1.3,
                ),
              ),
            ),
          ),

          const SizedBox(height: 36),

          // Center Stage Deep Concentration Kai Mascot Painter with Glowing Orbit
          AnimatedBuilder(
            animation: _rotationController,
            builder: (context, child) {
              return CustomPaint(
                size: const Size(180, 180),
                painter: _DeepThinkingKaiPainter(
                  rotationProgress: _rotationController.value,
                ),
              );
            },
          ),

          const SizedBox(height: 32),

          // 3-Star Constellation Progress Indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              final isFilled = index < _starCount;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 6),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isFilled
                      ? const Color(0xFFFF7A59).withValues(alpha: 0.3)
                      : Colors.white.withValues(alpha: 0.08),
                  border: Border.all(
                    color: isFilled ? const Color(0xFFFF7A59) : Colors.white.withValues(alpha: 0.2),
                    width: isFilled ? 2 : 1,
                  ),
                ),
                child: Icon(
                  Icons.star_rounded,
                  size: 20,
                  color: isFilled ? const Color(0xFFFFD166) : Colors.white.withValues(alpha: 0.3),
                ),
              );
            }),
          ),

          const SizedBox(height: 12),

          Text(
            'Kai is cooking your custom weekend itinerary... 🍳',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}

/// CustomPainter rendering Kai in deep concentration with orbiting sparkle doodles.
class _DeepThinkingKaiPainter extends CustomPainter {
  final double rotationProgress;

  _DeepThinkingKaiPainter({required this.rotationProgress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.38;

    // Glowing Ambient Radial Halo
    final haloPaint = Paint()
      ..shader = ui.Gradient.radial(
        center,
        radius * 1.5,
        [
          const Color(0xFF6C63FF).withValues(alpha: 0.4),
          const Color(0xFF2DD4BF).withValues(alpha: 0.2),
          Colors.transparent,
        ],
      );
    canvas.drawCircle(center, radius * 1.5, haloPaint);

    // Kai Blob Body
    final bodyPaint = Paint()
      ..shader = ui.Gradient.linear(
        center - Offset(radius, radius),
        center + Offset(radius, radius),
        [
          const Color(0xFFFF7A59),
          const Color(0xFFFFB703),
          const Color(0xFFFFD166),
        ],
      );
    canvas.drawCircle(center, radius, bodyPaint);

    // Eyes Squeezed Shut in Concentration (> <)
    final eyePaint = Paint()
      ..color = const Color(0xFF0F0E1A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.2
      ..strokeCap = StrokeCap.round;

    final leftEye = center + Offset(-radius * 0.3, -radius * 0.1);
    final rightEye = center + Offset(radius * 0.3, -radius * 0.1);

    // Left eye ">"
    final leftEyePath = Path()
      ..moveTo(leftEye.dx - 6, leftEye.dy - 5)
      ..lineTo(leftEye.dx + 4, leftEye.dy)
      ..lineTo(leftEye.dx - 6, leftEye.dy + 5);
    canvas.drawPath(leftEyePath, eyePaint);

    // Right eye "<"
    final rightEyePath = Path()
      ..moveTo(rightEye.dx + 6, rightEye.dy - 5)
      ..lineTo(rightEye.dx - 4, rightEye.dy)
      ..lineTo(rightEye.dx + 6, rightEye.dy + 5);
    canvas.drawPath(rightEyePath, eyePaint);

    // Paws to Temples
    final pawPaint = Paint()..color = const Color(0xFFFF7A59);
    canvas.drawCircle(leftEye + const Offset(-14, 8), 8, pawPaint);
    canvas.drawCircle(rightEye + const Offset(14, 8), 8, pawPaint);

    // Concentrating Mouth
    final mouthPath = Path()
      ..moveTo(center.dx - 6, center.dy + 14)
      ..lineTo(center.dx + 6, center.dy + 14);
    canvas.drawPath(mouthPath, eyePaint);

    // Orbiting Thinking Doodles (Gears & Sparkles)
    final angle = rotationProgress * 2 * math.pi;
    for (int i = 0; i < 4; i++) {
      final orbitAngle = angle + (i * math.pi / 2);
      final orbitPos = center + Offset(math.cos(orbitAngle) * (radius + 20), math.sin(orbitAngle) * (radius + 20));

      final sparklePaint = Paint()..color = const Color(0xFFFFD166);
      canvas.drawCircle(orbitPos, 4, sparklePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _DeepThinkingKaiPainter oldDelegate) {
    return oldDelegate.rotationProgress != rotationProgress;
  }
}
