import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/animated_background.dart';
import '../widgets/kai_mascot.dart';
import '../widgets/kai_bubble.dart';
import 'live_trip_screen.dart';

class ItineraryStop {
  final String time;
  final String title;
  final String category;
  final String cost;
  final IconData icon;
  final Color accentColor;

  const ItineraryStop({
    required this.time,
    required this.title,
    required this.category,
    required this.cost,
    required this.icon,
    required this.accentColor,
  });
}

/// Final Confirmed Itinerary Screen featuring winding storybook treasure-map route,
/// stop waypoint flags, total cost ribbon, party hat Kai, and action buttons.
class FinalItineraryScreen extends StatefulWidget {
  const FinalItineraryScreen({super.key});

  static const List<ItineraryStop> stops = [
    ItineraryStop(
      time: '5:00 PM',
      title: 'Sunset Ridge Hike & Viewpoint',
      category: 'Outdoor Trail',
      cost: 'FREE',
      icon: Icons.landscape_rounded,
      accentColor: Color(0xFFFF7A59),
    ),
    ItineraryStop(
      time: '7:30 PM',
      title: 'Artisan Pottery & Clay Workshop',
      category: 'Creative Craft',
      cost: '₹800',
      icon: Icons.palette_rounded,
      accentColor: Color(0xFF2DD4BF),
    ),
    ItineraryStop(
      time: '9:30 PM',
      title: 'Rooftop Jazz & Tapas Dinner',
      category: 'Skyline Dining',
      cost: '₹800',
      icon: Icons.nightlife_rounded,
      accentColor: Color(0xFF8B5CF6),
    ),
  ];

  @override
  State<FinalItineraryScreen> createState() => _FinalItineraryScreenState();
}

class _FinalItineraryScreenState extends State<FinalItineraryScreen> {
  String _kaiSpeechText = "I've mentally rehearsed this itinerary about six times already. It's good. Trust me 😎";

  void _onEditPlan() {
    HapticFeedback.lightImpact();
    setState(() {
      _kaiSpeechText = "Wait, you don't like it?? Okay okay, tell me what to fix 🥺";
    });
  }

  void _onLetsGo() {
    HapticFeedback.heavyImpact();
    setState(() {
      _kaiSpeechText = "YES. Okay go have fun. I'll be here refreshing for updates like a worried parent 📸";
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const LiveTripScreen()),
        );
      }
    });
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
                // Top Navigation Bar
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
                      const Text(
                        'Confirmed Itinerary',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 44),
                    ],
                  ),
                ),

                // Party Hat Kai Mascot Header & Reactive Speech Bubble
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const KaiMascot(size: 62, expression: KaiExpression.excited),
                      const SizedBox(width: 8),
                      Expanded(
                        child: KaiBubble(text: _kaiSpeechText),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Winding Storybook Treasure-Map Timeline Content
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Column(
                      children: [
                        // Vertical Timeline Stops
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: FinalItineraryScreen.stops.length,
                          itemBuilder: (context, index) {
                            final stop = FinalItineraryScreen.stops[index];
                            final isLast = index == FinalItineraryScreen.stops.length - 1;

                            return IntrinsicHeight(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Waypoint Flag Timeline Line
                                  Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: stop.accentColor.withValues(alpha: 0.3),
                                          border: Border.all(color: stop.accentColor, width: 2),
                                        ),
                                        child: Icon(Icons.flag_rounded, size: 16, color: stop.accentColor),
                                      ),
                                      if (!isLast)
                                        Expanded(
                                          child: Container(
                                            width: 2,
                                            margin: const EdgeInsets.symmetric(vertical: 4),
                                            color: Colors.white.withValues(alpha: 0.25),
                                          ),
                                        ),
                                    ],
                                  ),

                                  const SizedBox(width: 14),

                                  // Stop Details Card
                                  Expanded(
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 18),
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(22),
                                        color: Colors.white.withValues(alpha: 0.08),
                                        border: Border.all(
                                          color: Colors.white.withValues(alpha: 0.18),
                                          width: 1,
                                        ),
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
                                                  color: stop.accentColor.withValues(alpha: 0.2),
                                                ),
                                                child: Text(
                                                  stop.time,
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w800,
                                                    color: stop.accentColor,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  color: Colors.white.withValues(alpha: 0.1),
                                                ),
                                                child: Text(
                                                  stop.cost,
                                                  style: const TextStyle(
                                                    fontSize: 11.5,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),

                                          const SizedBox(height: 10),

                                          Text(
                                            stop.title,
                                            style: const TextStyle(
                                              fontSize: 16.5,
                                              fontWeight: FontWeight.w900,
                                              color: Colors.white,
                                            ),
                                          ),

                                          const SizedBox(height: 4),

                                          Row(
                                            children: [
                                              Icon(stop.icon, size: 14, color: Colors.white70),
                                              const SizedBox(width: 6),
                                              Text(
                                                stop.category,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white.withValues(alpha: 0.65),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 10),

                        // Total Cost & Distance Ribbon Banner
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFD166),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xFF0F0E1A), width: 1.8),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x60000000),
                                blurRadius: 12,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                'Total: ₹1,600',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF0F0E1A),
                                ),
                              ),
                              Text(
                                '12 km  •  24°C Sunny ☀️',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF0F0E1A),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Bottom Action Buttons Row ("Edit Plan" vs "Let's Go!")
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                  child: Row(
                    children: [
                      // Secondary "Edit Plan" Button
                      Expanded(
                        flex: 2,
                        child: OutlinedButton(
                          onPressed: _onEditPlan,
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(54),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            side: BorderSide(color: Colors.white.withValues(alpha: 0.3), width: 1.5),
                          ),
                          child: const Text(
                            'Edit Plan',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Primary "Let's Go!" Button
                      Expanded(
                        flex: 3,
                        child: ElevatedButton(
                          onPressed: _onLetsGo,
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
                                "Let's Go! 🚀",
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
          ),
        ],
      ),
    );
  }
}
