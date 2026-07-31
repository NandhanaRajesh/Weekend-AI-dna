import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

/// Center Logo Widget displaying the merged Compass + Sparkle emblem,
/// WeekendAI title, and tagline with staggered scale + fade animations.
class LogoWidget extends StatelessWidget {
  final Animation<double> logoScaleAnimation;
  final Animation<double> logoFadeAnimation;
  final Animation<double> titleFadeAnimation;
  final Animation<double> subtitleFadeAnimation;

  const LogoWidget({
    super.key,
    required this.logoScaleAnimation,
    required this.logoFadeAnimation,
    required this.titleFadeAnimation,
    required this.subtitleFadeAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Premium Circular Logo Emblem
        AnimatedBuilder(
          animation: Listenable.merge([logoScaleAnimation, logoFadeAnimation]),
          builder: (context, child) {
            final scale = logoScaleAnimation.value;
            final opacity = logoFadeAnimation.value;

            return Transform.scale(
              scale: scale,
              child: Opacity(
                opacity: opacity,
                child: child,
              ),
            );
          },
          child: const _LogoEmblem(),
        ),

        const SizedBox(height: 28),

        // "WeekendAI" Title
        AnimatedBuilder(
          animation: titleFadeAnimation,
          builder: (context, child) {
            final opacity = titleFadeAnimation.value;
            return Opacity(
              opacity: opacity,
              child: Transform.translate(
                offset: Offset(0, 10 * (1 - opacity)),
                child: child,
              ),
            );
          },
          child: ShaderMask(
            shaderCallback: (bounds) {
              return const LinearGradient(
                colors: [
                  Color(0xFFFFFFFF),
                  Color(0xFFF0EFFF),
                  Color(0xFFD4D0FF),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ).createShader(bounds);
            },
            child: const Text(
              'WeekendAI',
              style: TextStyle(
                fontSize: 38,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
                color: Colors.white,
                fontFamily: 'Roboto',
                shadows: [
                  Shadow(
                    color: Color(0x606C63FF),
                    blurRadius: 20,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 10),

        // Subtitle: "Your AI Companion for Every Weekend"
        AnimatedBuilder(
          animation: subtitleFadeAnimation,
          builder: (context, child) {
            final opacity = subtitleFadeAnimation.value;
            return Opacity(
              opacity: opacity,
              child: Transform.translate(
                offset: Offset(0, 8 * (1 - opacity)),
                child: child,
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white.withValues(alpha: 0.06),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.12),
                width: 1,
              ),
            ),
            child: Text(
              'Your AI Companion for Every Weekend',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.2,
                color: Colors.white.withValues(alpha: 0.88),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Frosted Glass Circle with Glowing Ambient Ring & Merged Compass-Sparkle Custom Paint
class _LogoEmblem extends StatefulWidget {
  const _LogoEmblem();

  @override
  State<_LogoEmblem> createState() => _LogoEmblemState();
}

class _LogoEmblemState extends State<_LogoEmblem>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double size = 110.0;

    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        final glowScale = 1.0 + (_pulseController.value * 0.05);
        final glowAlpha = 0.35 + (_pulseController.value * 0.25);

        return SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Ambient Glow Background Shadow
              Transform.scale(
                scale: glowScale,
                child: Container(
                  width: size * 0.9,
                  height: size * 0.9,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6C63FF).withValues(alpha: glowAlpha),
                        blurRadius: 32,
                        spreadRadius: 8,
                      ),
                      BoxShadow(
                        color: const Color(0xFF2DD4BF).withValues(alpha: glowAlpha * 0.5),
                        blurRadius: 44,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                ),
              ),

              // Frosted Glass Circle Container
              ClipRRect(
                borderRadius: BorderRadius.circular(size / 2),
                child: BackdropFilter(
                  filter: ui.ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          Colors.white.withValues(alpha: 0.25),
                          Colors.white.withValues(alpha: 0.08),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.35),
                        width: 1.5,
                      ),
                    ),
                    child: CustomPaint(
                      painter: _CompassSparklePainter(
                        pulse: _pulseController.value,
                      ),
                    ),
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

/// Custom Painter drawing a Compass dial merged with an AI Sparkle star emblem.
class _CompassSparklePainter extends CustomPainter {
  final double pulse;

  _CompassSparklePainter({required this.pulse});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // 1. Compass Ring tick marks
    final tickPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.4)
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 12; i++) {
      final angle = (i * 30) * math.pi / 180;
      final isMajor = i % 3 == 0;
      final startLen = radius * (isMajor ? 0.76 : 0.82);
      final endLen = radius * 0.86;

      final p1 = center + Offset(math.cos(angle) * startLen, math.sin(angle) * startLen);
      final p2 = center + Offset(math.cos(angle) * endLen, math.sin(angle) * endLen);
      tickPaint.color = isMajor
          ? Colors.white.withValues(alpha: 0.7)
          : Colors.white.withValues(alpha: 0.3);
      canvas.drawLine(p1, p2, tickPaint);
    }

    // 2. Merged Compass Needle + AI Sparkle Star Core
    // North Needle (Gradient Primary Indigo/Violet)
    final northPath = Path()
      ..moveTo(center.dx, center.dy - radius * 0.58) // Pointing North
      ..lineTo(center.dx + 7, center.dy)
      ..lineTo(center.dx - 7, center.dy)
      ..close();

    final northPaint = Paint()
      ..shader = ui.Gradient.linear(
        center + const Offset(0, -30),
        center,
        [const Color(0xFF2DD4BF), const Color(0xFF6C63FF)],
      );
    canvas.drawPath(northPath, northPaint);

    // South Needle (Translucent Soft Glass)
    final southPath = Path()
      ..moveTo(center.dx, center.dy + radius * 0.58) // Pointing South
      ..lineTo(center.dx + 7, center.dy)
      ..lineTo(center.dx - 7, center.dy)
      ..close();

    final southPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.35);
    canvas.drawPath(southPath, southPaint);

    // East/West Subtle Accent Wings
    final eastWestPath = Path()
      ..moveTo(center.dx + radius * 0.45, center.dy)
      ..lineTo(center.dx, center.dy - 5)
      ..lineTo(center.dx - radius * 0.45, center.dy)
      ..lineTo(center.dx, center.dy + 5)
      ..close();
    canvas.drawPath(
      eastWestPath,
      Paint()..color = const Color(0xFFFF7A59).withValues(alpha: 0.6),
    );

    // 3. Central AI Sparkle Star Overlay
    final sparkleSize = 16.0 + (pulse * 2.0);
    final sparklePath = Path();

    // 4-point bezier curvature sparkle emblem
    sparklePath.moveTo(center.dx, center.dy - sparkleSize);
    sparklePath.quadraticBezierTo(center.dx, center.dy, center.dx + sparkleSize, center.dy);
    sparklePath.quadraticBezierTo(center.dx, center.dy, center.dx, center.dy + sparkleSize);
    sparklePath.quadraticBezierTo(center.dx, center.dy, center.dx - sparkleSize, center.dy);
    sparklePath.quadraticBezierTo(center.dx, center.dy, center.dx, center.dy - sparkleSize);
    sparklePath.close();

    final sparklePaint = Paint()
      ..shader = ui.Gradient.radial(
        center,
        sparkleSize,
        [
          Colors.white,
          const Color(0xFF2DD4BF),
        ],
      )
      ..style = PaintingStyle.fill;

    canvas.drawPath(sparklePath, sparklePaint);

    // Core Glow center dot
    canvas.drawCircle(
      center,
      3.0,
      Paint()..color = Colors.white,
    );
  }

  @override
  bool shouldRepaint(covariant _CompassSparklePainter oldDelegate) {
    return oldDelegate.pulse != pulse;
  }
}
