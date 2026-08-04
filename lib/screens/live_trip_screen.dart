import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../controllers/kai_controller.dart';
import '../widgets/animated_background.dart';
import '../widgets/kai_mascot.dart';
import '../widgets/kai_bubble.dart';

/// Live Trip Companion Screen featuring treasure-map navigation, active stop countdown postcard,
/// emergency flare beacon button, and sun-hat Kai commentary.
class LiveTripScreen extends StatefulWidget {
  const LiveTripScreen({super.key});

  @override
  State<LiveTripScreen> createState() => _LiveTripScreenState();
}

class _LiveTripScreenState extends State<LiveTripScreen> {
  String _kaiSpeechText = "Having fun without me? Rude. (Kidding. Go enjoy, I'm just watching the clock.) 🏖️";
  bool _isLiveLocationSharing = true;
  int _currentStopIndex = 1; // Stop 2 of 3

  void _markCurrentStopDone() {
    HapticFeedback.heavyImpact();
    setState(() {
      if (_currentStopIndex < 2) {
        _currentStopIndex++;
        _kaiSpeechText = "You made it! I was tracking your little dot the whole time, very wholesome, not concerning at all 📍";
      } else {
        _kaiSpeechText = "Last stop coming up. Savor it. Then come back and tell me everything 📸";
      }
    });
  }

  void _triggerEmergencyBeacon() {
    HapticFeedback.vibrate();
    // Hard Rule 1: Emergency Mode overrides everything to Worried state (no jokes)
    KaiController.instance.react(KaiTrigger.emergencyModeOpened);
    setState(() {
      _kaiSpeechText = KaiController.instance.currentSpeech;
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1B33),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: const [
            Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 28),
            SizedBox(width: 8),
            Text('Emergency Beacon 🚨', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
          ],
        ),
        content: const Text(
          'Sharing instant live coordinates & alert to your trusted emergency squad contacts.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text('Send Alert 🚨', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Mesh
          const AnimatedBackground(),

          SafeArea(
            child: Column(
              children: [
                // Top Header Row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white.withValues(alpha: 0.1),
                        ),
                      ),
                      Row(
                        children: const [
                          Icon(Icons.near_me_rounded, color: Color(0xFF2DD4BF), size: 18),
                          SizedBox(width: 6),
                          Text(
                            'Live Outing Companion',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 44),
                    ],
                  ),
                ),

                // Sun Hat Kai Companion Mascot Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const KaiMascot(size: 58, expression: KaiExpression.happy),
                      const SizedBox(width: 8),
                      Expanded(
                        child: KaiBubble(text: _kaiSpeechText),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // Storybook Treasure Map View
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(26),
                      color: Colors.white.withValues(alpha: 0.08),
                      border: Border.all(color: const Color(0xFF2DD4BF).withValues(alpha: 0.4), width: 1.5),
                    ),
                    child: Stack(
                      children: [
                        // Map Painter
                        CustomPaint(
                          size: Size.infinite,
                          painter: _TreasureMapPainter(),
                        ),

                        // Emergency Flare Beacon Floating Button
                        Positioned(
                          top: 14,
                          right: 14,
                          child: GestureDetector(
                            onTap: _triggerEmergencyBeacon,
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.redAccent,
                                border: Border.all(color: Colors.white, width: 2),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.redAccent.withValues(alpha: 0.6),
                                    blurRadius: 16,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Icon(Icons.sos_rounded, color: Colors.white, size: 22),
                            ),
                          ),
                        ),

                        // Live Location Sharing Toggle
                        Positioned(
                          top: 14,
                          left: 14,
                          child: GestureDetector(
                            onTap: () {
                              HapticFeedback.lightImpact();
                              setState(() => _isLiveLocationSharing = !_isLiveLocationSharing);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: const Color(0xFFFFD166),
                                border: Border.all(color: const Color(0xFF0F0E1A), width: 1.5),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    _isLiveLocationSharing ? Icons.location_on_rounded : Icons.location_off_rounded,
                                    size: 14,
                                    color: const Color(0xFF0F0E1A),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    _isLiveLocationSharing ? 'Location ON' : 'Location OFF',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w900,
                                      color: Color(0xFF0F0E1A),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // Active Stop Postcard Card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: Colors.white.withValues(alpha: 0.1),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: const Color(0xFFFF7A59).withValues(alpha: 0.25),
                              ),
                              child: Text(
                                'CURRENT STOP (${_currentStopIndex + 1} of 3)',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFFFF7A59),
                                ),
                              ),
                            ),

                            // Hourglass Countdown Timer Badge
                            Row(
                              children: const [
                                Icon(Icons.hourglass_bottom_rounded, size: 16, color: Color(0xFFFFD166)),
                                SizedBox(width: 4),
                                Text(
                                  '42 mins left',
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFFFFD166),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        Text(
                          _currentStopIndex == 0
                              ? 'Sunset Ridge Hike & Viewpoint 🏔️'
                              : (_currentStopIndex == 1
                                  ? 'Artisan Pottery & Clay Workshop 🎨'
                                  : 'Rooftop Jazz & Tapas Dinner 🍷'),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          _currentStopIndex < 2
                              ? 'Next: Rooftop Jazz & Tapas Dinner at 8:30 PM'
                              : 'Next: Homeward Bound 🏡',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withValues(alpha: 0.65),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // "Mark as Done" Wooden-Sign Button
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: ElevatedButton(
                    onPressed: _markCurrentStopDone,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 0,
                    ),
                    child: Container(
                      height: 54,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF7A59), Color(0xFF8B5CF6)],
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x60FF7A59),
                            blurRadius: 16,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          'Mark Stop as Done ✓',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// CustomPainter drawing storybook treasure map route with character pin and flags.
class _TreasureMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    path.moveTo(size.width * 0.2, size.height * 0.2);
    path.cubicTo(
      size.width * 0.8,
      size.height * 0.35,
      size.width * 0.1,
      size.height * 0.65,
      size.width * 0.75,
      size.height * 0.85,
    );

    // Dashed Route Line
    final linePaint = Paint()
      ..color = const Color(0xFF2DD4BF).withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, linePaint);

    // Character Pin Marker (Current Location)
    final currentPos = Offset(size.width * 0.42, size.height * 0.48);
    final pinPaint = Paint()..color = const Color(0xFFFF7A59);
    canvas.drawCircle(currentPos, 10, pinPaint);

    final innerPinPaint = Paint()..color = Colors.white;
    canvas.drawCircle(currentPos, 4, innerPinPaint);

    // Waypoint Flags
    final flagPositions = [
      Offset(size.width * 0.2, size.height * 0.2),
      Offset(size.width * 0.75, size.height * 0.85),
    ];

    for (final pos in flagPositions) {
      final flagPaint = Paint()..color = const Color(0xFFFFD166);
      canvas.drawCircle(pos, 7, flagPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
  