import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class FloatingIconData {
  final IconData icon;
  final Offset relativePos; // (0..1, 0..1) relative position on screen
  final double size;
  final double opacity;
  final double blur;
  final double floatSpeed;
  final double phaseShift;
  final double radiusX;
  final double radiusY;

  const FloatingIconData({
    required this.icon,
    required this.relativePos,
    this.size = 28.0,
    this.opacity = 0.20,
    this.blur = 0.0,
    this.floatSpeed = 1.0,
    this.phaseShift = 0.0,
    this.radiusX = 14.0,
    this.radiusY = 18.0,
  });
}

/// Floating travel and lifestyle themed icons with depth-of-field and organic drift.
class FloatingIcons extends StatefulWidget {
  final Animation<double> entranceAnimation;

  const FloatingIcons({
    super.key,
    required this.entranceAnimation,
  });

  @override
  State<FloatingIcons> createState() => _FloatingIconsState();
}

class _FloatingIconsState extends State<FloatingIcons>
    with SingleTickerProviderStateMixin {
  late AnimationController _driftController;

  static const List<FloatingIconData> iconsList = [
    // Top-Left Cluster
    FloatingIconData(
      icon: Icons.coffee_rounded,
      relativePos: Offset(0.12, 0.15),
      size: 32,
      opacity: 0.22,
      blur: 0.0,
      floatSpeed: 0.9,
      phaseShift: 0.2,
    ),
    FloatingIconData(
      icon: Icons.auto_awesome_rounded,
      relativePos: Offset(0.28, 0.08),
      size: 24,
      opacity: 0.18,
      blur: 2.5,
      floatSpeed: 1.4,
      phaseShift: 1.2,
    ),

    // Top-Right Cluster
    FloatingIconData(
      icon: Icons.beach_access_rounded,
      relativePos: Offset(0.85, 0.14),
      size: 34,
      opacity: 0.20,
      blur: 0.0,
      floatSpeed: 1.1,
      phaseShift: 2.4,
    ),
    FloatingIconData(
      icon: Icons.music_note_rounded,
      relativePos: Offset(0.72, 0.22),
      size: 26,
      opacity: 0.16,
      blur: 3.0,
      floatSpeed: 0.8,
      phaseShift: 0.8,
    ),

    // Mid-Left & Center Outer
    FloatingIconData(
      icon: Icons.photo_camera_rounded,
      relativePos: Offset(0.08, 0.42),
      size: 30,
      opacity: 0.22,
      blur: 0.0,
      floatSpeed: 1.2,
      phaseShift: 3.1,
    ),
    FloatingIconData(
      icon: Icons.palette_rounded,
      relativePos: Offset(0.88, 0.48),
      size: 28,
      opacity: 0.19,
      blur: 1.5,
      floatSpeed: 1.0,
      phaseShift: 4.0,
    ),

    // Bottom-Left Cluster
    FloatingIconData(
      icon: Icons.filter_hdr_rounded, // Mountain
      relativePos: Offset(0.15, 0.72),
      size: 36,
      opacity: 0.24,
      blur: 0.0,
      floatSpeed: 0.75,
      phaseShift: 1.8,
    ),
    FloatingIconData(
      icon: Icons.restaurant_rounded,
      relativePos: Offset(0.30, 0.84),
      size: 26,
      opacity: 0.15,
      blur: 2.8,
      floatSpeed: 1.3,
      phaseShift: 5.2,
    ),

    // Bottom-Right Cluster
    FloatingIconData(
      icon: Icons.explore_rounded, // Compass
      relativePos: Offset(0.82, 0.76),
      size: 32,
      opacity: 0.21,
      blur: 0.0,
      floatSpeed: 1.0,
      phaseShift: 2.9,
    ),
    FloatingIconData(
      icon: Icons.wb_sunny_rounded,
      relativePos: Offset(0.68, 0.88),
      size: 28,
      opacity: 0.17,
      blur: 2.0,
      floatSpeed: 1.15,
      phaseShift: 3.7,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _driftController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _driftController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return AnimatedBuilder(
      animation: Listenable.merge([_driftController, widget.entranceAnimation]),
      builder: (context, child) {
        final entranceVal = widget.entranceAnimation.value;
        if (entranceVal <= 0.0) return const SizedBox.shrink();

        return Stack(
          children: iconsList.map((item) {
            final t = (_driftController.value * 2 * math.pi * item.floatSpeed) + item.phaseShift;

            // Smooth Lissajous floating offset
            final dx = math.sin(t) * item.radiusX;
            final dy = math.cos(t * 0.8) * item.radiusY;

            final baseX = item.relativePos.dx * screenSize.width;
            final baseY = item.relativePos.dy * screenSize.height;

            final currentX = baseX + dx;
            final currentY = baseY + dy;

            Widget iconWidget = Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.05),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
              child: Icon(
                item.icon,
                size: item.size,
                color: Colors.white.withValues(alpha: item.opacity * entranceVal),
              ),
            );

            // Apply blur for depth layer if configured
            if (item.blur > 0.0) {
              iconWidget = ImageFiltered(
                imageFilter: ui.ImageFilter.blur(
                  sigmaX: item.blur,
                  sigmaY: item.blur,
                ),
                child: iconWidget,
              );
            }

            return Positioned(
              left: currentX - item.size / 2,
              top: currentY - item.size / 2,
              child: Opacity(
                opacity: entranceVal,
                child: iconWidget,
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
