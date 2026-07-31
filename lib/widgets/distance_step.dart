import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Distance Step Widget (Step 4 of 9) with animated concentric radius map painter,
/// sticker distance handle, presets, and live Kai speech callbacks.
class DistanceStep extends StatefulWidget {
  final double currentDistance;
  final ValueChanged<double> onDistanceChanged;
  final ValueChanged<String> onKaiReactionChanged;

  const DistanceStep({
    super.key,
    required this.currentDistance,
    required this.onDistanceChanged,
    required this.onKaiReactionChanged,
  });

  @override
  State<DistanceStep> createState() => _DistanceStepState();
}

class _DistanceStepState extends State<DistanceStep> {
  late double _distanceKm;

  @override
  void initState() {
    super.initState();
    _distanceKm = widget.currentDistance;
  }

  void _updateDistance(double val) {
    setState(() {
      _distanceKm = val;
    });
    widget.onDistanceChanged(val);

    String reaction;
    if (val < 8) {
      reaction = "Nearby & cozy! Keeping it local & easy 🚲";
    } else if (val <= 25) {
      reaction = "City-wide it is — plenty of hidden gems in range 🗺️";
    } else {
      reaction = "Road trip mode! Pack some snacks & a playlist 🚘";
    }
    widget.onKaiReactionChanged(reaction);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Radius Map Card Container
          Container(
            height: 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(26),
              color: Colors.white.withValues(alpha: 0.08),
              border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(26),
              child: Stack(
                children: [
                  // Animated Concentric Radius Map CustomPainter
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _RadiusMapPainter(distanceKm: _distanceKm),
                    ),
                  ),

                  // Distance Sticker Badge Overlay (Top Right)
                  Positioned(
                    top: 14,
                    right: 14,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFD166),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFF0F0E1A), width: 2),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x60000000),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        '${_distanceKm.toInt()} km',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF0F0E1A),
                        ),
                      ),
                    ),
                  ),

                  // Slider Overlaid at Bottom of Map Card
                  Positioned(
                    left: 12,
                    right: 12,
                    bottom: 12,
                    child: SliderTheme(
                      data: SliderThemeData(
                        trackHeight: 10,
                        activeTrackColor: const Color(0xFFFF7A59),
                        inactiveTrackColor: Colors.white.withValues(alpha: 0.25),
                        thumbColor: const Color(0xFF2DD4BF),
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 14),
                      ),
                      child: Slider(
                        value: _distanceKm,
                        min: 1,
                        max: 50,
                        divisions: 49,
                        onChanged: (val) {
                          HapticFeedback.selectionClick();
                          _updateDistance(val);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 18),

          const Text(
            'Quick Distance Presets:',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 10),

          // 3 Preset Pill Buttons
          Row(
            children: [
              Expanded(
                child: _DistancePresetPill(
                  label: 'Nearby',
                  valueLabel: '5 km',
                  isSelected: _distanceKm <= 8,
                  onTap: () => _updateDistance(5),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _DistancePresetPill(
                  label: 'City-wide',
                  valueLabel: '15 km',
                  isSelected: _distanceKm > 8 && _distanceKm <= 25,
                  onTap: () => _updateDistance(15),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _DistancePresetPill(
                  label: 'Road Trip',
                  valueLabel: '50 km+',
                  isSelected: _distanceKm > 25,
                  onTap: () => _updateDistance(50),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DistancePresetPill extends StatelessWidget {
  final String label;
  final String valueLabel;
  final bool isSelected;
  final VoidCallback onTap;

  const _DistancePresetPill({
    required this.label,
    required this.valueLabel,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: isSelected
              ? const Color(0xFFFF7A59).withValues(alpha: 0.3)
              : Colors.white.withValues(alpha: 0.08),
          border: Border.all(
            color: isSelected ? const Color(0xFFFF7A59) : Colors.white.withValues(alpha: 0.18),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFFFF7A59).withValues(alpha: 0.35),
                    blurRadius: 12,
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              valueLabel,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: isSelected ? const Color(0xFF2DD4BF) : Colors.white.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// CustomPainter drawing animated concentric dashed rings and center "You" pin marker.
class _RadiusMapPainter extends CustomPainter {
  final double distanceKm;

  _RadiusMapPainter({required this.distanceKm});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2 - 10);
    final maxRadius = math.min(size.width, size.height) * 0.42;

    // Radius ratio (1..50 km maps to 0.2..1.0 maxRadius)
    final currentRadius = maxRadius * (0.2 + (distanceKm / 50.0) * 0.8);

    // Grid map lines
    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.06)
      ..strokeWidth = 1.0;

    for (double i = 0; i < size.width; i += 30) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), gridPaint);
    }
    for (double j = 0; j < size.height; j += 30) {
      canvas.drawLine(Offset(0, j), Offset(size.width, j), gridPaint);
    }

    // Concentric Dashed Ring Shader Fill
    final fillPaint = Paint()
      ..color = const Color(0xFFFF7A59).withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, currentRadius, fillPaint);

    // Dashed Ring Stroke
    final ringStroke = Paint()
      ..color = const Color(0xFFFF7A59).withValues(alpha: 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    _drawDashedCircle(canvas, center, currentRadius, ringStroke);

    // Outer Ring Accent
    final outerRingStroke = Paint()
      ..color = const Color(0xFF2DD4BF).withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    _drawDashedCircle(canvas, center, currentRadius * 0.5, outerRingStroke);

    // Center "You" Pin Marker
    final pinBgPaint = Paint()..color = const Color(0xFF2DD4BF);
    canvas.drawCircle(center, 12, pinBgPaint);

    final pinDotPaint = Paint()..color = Colors.white;
    canvas.drawCircle(center, 4, pinDotPaint);
  }

  void _drawDashedCircle(Canvas canvas, Offset center, double radius, Paint paint) {
    const dashAngle = math.pi / 24;
    for (double i = 0; i < 2 * math.pi; i += dashAngle * 2) {
      final rect = Rect.fromCircle(center: center, radius: radius);
      canvas.drawArc(rect, i, dashAngle, false, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _RadiusMapPainter oldDelegate) {
    return oldDelegate.distanceKm != distanceKm;
  }
}
