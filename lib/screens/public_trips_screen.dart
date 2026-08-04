import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/animated_background.dart';
import '../widgets/kai_mascot.dart';
import '../widgets/kai_bubble.dart';

class PublicTripItem {
  final String id;
  final String title;
  final String hostName;
  final String hostHandle;
  final String hostEmoji;
  final String matchScore;
  final String seatsLeft;
  final String location;
  final String date;
  final List<Color> gradientColors;

  const PublicTripItem({
    required this.id,
    required this.title,
    required this.hostName,
    required this.hostHandle,
    required this.hostEmoji,
    required this.matchScore,
    required this.seatsLeft,
    required this.location,
    required this.date,
    required this.gradientColors,
  });
}

/// Public Stranger Trips Screen featuring user-posted itineraries, seat availability counters,
/// Kai Verified Safe Vibe badges, request-to-join modals, and host-a-trip creator.
class PublicTripsScreen extends StatefulWidget {
  const PublicTripsScreen({super.key});

  static const List<PublicTripItem> publicTrips = [
    PublicTripItem(
      id: 'trip1',
      title: 'Sunset Ridge Camping & Stargazing 🌌',
      hostName: 'Alex',
      hostHandle: '@Alex_Explorer',
      hostEmoji: '👦',
      matchScore: '94% VIBE MATCH',
      seatsLeft: '3 / 5 Seats Left',
      location: 'Sunset Ridge (12 km)',
      date: 'This Saturday, 5:00 PM',
      gradientColors: [Color(0xFFFF7A59), Color(0xFF8B5CF6)],
    ),
    PublicTripItem(
      id: 'trip2',
      title: 'Artisan Pottery & Wine Tasting 🍷',
      hostName: 'Maya',
      hostHandle: '@Maya_Creative',
      hostEmoji: '👧',
      matchScore: '91% VIBE MATCH',
      seatsLeft: '2 / 4 Seats Left',
      location: 'Creative Studio (4.5 km)',
      date: 'This Sunday, 3:00 PM',
      gradientColors: [Color(0xFF6C63FF), Color(0xFF2DD4BF)],
    ),
    PublicTripItem(
      id: 'trip3',
      title: 'Rooftop Jazz & Street Food Crawl 🎷',
      hostName: 'Jordan',
      hostHandle: '@Jordan_Vibes',
      hostEmoji: '🧒',
      matchScore: '87% VIBE MATCH',
      seatsLeft: '1 / 6 Seats Left',
      location: 'Skyline Terrace (3.8 km)',
      date: 'This Saturday, 8:00 PM',
      gradientColors: [Color(0xFFFFB703), Color(0xFFFF7A59)],
    ),
  ];

  @override
  State<PublicTripsScreen> createState() => _PublicTripsScreenState();
}

class _PublicTripsScreenState extends State<PublicTripsScreen> {
  String _kaiSpeechText = "Public Stranger Trips mode! I'll screen the vibes and manage squad requests. Safety first! 🛡️";
  String _selectedFilter = 'All Trips 🗺️';

  final Set<String> _requestedTripIds = {};

  void _requestToJoin(PublicTripItem trip) {
    HapticFeedback.heavyImpact();
    setState(() {
      _requestedTripIds.add(trip.id);
      _kaiSpeechText = "Request sent to ${trip.hostHandle}! I'm keeping an eye on the group chat vibes 🛡️";
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF2DD4BF),
        content: Text(
          'Join request sent to ${trip.hostName}! Kai is screening the match.',
          style: const TextStyle(color: Color(0xFF0F0E1A), fontWeight: FontWeight.w800),
        ),
      ),
    );
  }

  void _hostNewStrangerTrip() {
    HapticFeedback.mediumImpact();
    setState(() {
      _kaiSpeechText = "Let's package your AI itinerary into a public stranger trip invite! 📢";
    });

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1B33),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Icon(Icons.public_rounded, color: Color(0xFFFF7A59), size: 24),
                  SizedBox(width: 8),
                  Text(
                    'Post Public Stranger Trip',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'Share your generated AI itinerary publicly! Friendly strangers can apply to join, and Kai will manage your squad requests.',
                style: TextStyle(fontSize: 13, color: Colors.white70),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Color(0xFFFF7A59),
                      content: Text('Your trip was published to the Public Stranger Board! 🚀'),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF7A59),
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: const Text('Publish Trip 📢', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.white)),
              ),
            ],
          ),
        );
      },
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
                        'Public Stranger Trips',
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

                // Kai Bouncer / Referee Header & Speech Bubble
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const KaiMascot(size: 60, expression: KaiExpression.excited),
                      const SizedBox(width: 8),
                      Expanded(
                        child: KaiBubble(text: _kaiSpeechText),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // Category Filter Pills
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: ['All Trips 🗺️', 'Solo Welcome 🙋‍♂️', 'Group Outings 👯', 'Weekend Getaway 🏔️'].map((filter) {
                      final isSelected = _selectedFilter == filter;
                      return GestureDetector(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          setState(() => _selectedFilter = filter);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: isSelected
                                ? const Color(0xFFFF7A59).withValues(alpha: 0.3)
                                : Colors.white.withValues(alpha: 0.08),
                            border: Border.all(
                              color: isSelected ? const Color(0xFFFF7A59) : Colors.white.withValues(alpha: 0.18),
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Text(
                            filter,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 12),

                // List of Public Stranger Trip Cards
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    physics: const BouncingScrollPhysics(),
                    itemCount: PublicTripsScreen.publicTrips.length,
                    itemBuilder: (context, index) {
                      final trip = PublicTripsScreen.publicTrips[index];
                      final isRequested = _requestedTripIds.contains(trip.id);

                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          gradient: LinearGradient(
                            colors: [
                              trip.gradientColors[0].withValues(alpha: 0.45),
                              trip.gradientColors[1].withValues(alpha: 0.25),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1.2),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Host Avatar & Vibe Badge Row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white.withValues(alpha: 0.15),
                                        border: Border.all(color: const Color(0xFFFFD166), width: 1.5),
                                      ),
                                      child: Text(trip.hostEmoji, style: const TextStyle(fontSize: 18)),
                                    ),
                                    const SizedBox(width: 8),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          trip.hostName,
                                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white),
                                        ),
                                        Text(
                                          trip.hostHandle,
                                          style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.65)),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFD166),
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(color: const Color(0xFF0F0E1A), width: 1.5),
                                  ),
                                  child: Text(
                                    trip.matchScore,
                                    style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w900, color: Color(0xFF0F0E1A)),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            // Trip Title
                            Text(
                              trip.title,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: -0.3,
                              ),
                            ),

                            const SizedBox(height: 8),

                            // Location & Date
                            Row(
                              children: [
                                const Icon(Icons.near_me_rounded, size: 13, color: Color(0xFF2DD4BF)),
                                const SizedBox(width: 4),
                                Text(trip.location, style: const TextStyle(fontSize: 11.5, color: Colors.white70)),
                                const SizedBox(width: 12),
                                const Icon(Icons.calendar_month_rounded, size: 13, color: Color(0xFFFFD166)),
                                const SizedBox(width: 4),
                                Text(trip.date, style: const TextStyle(fontSize: 11.5, color: Colors.white70)),
                              ],
                            ),

                            const SizedBox(height: 12),

                            // Safety Badge & Join Button Row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: const Color(0xFF2DD4BF).withValues(alpha: 0.2),
                                    border: Border.all(color: const Color(0xFF2DD4BF)),
                                  ),
                                  child: Row(
                                    children: const [
                                      Icon(Icons.shield_rounded, size: 12, color: Color(0xFF2DD4BF)),
                                      SizedBox(width: 4),
                                      Text(
                                        'Kai Verified Safe Vibe ✓',
                                        style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: Color(0xFF2DD4BF)),
                                      ),
                                    ],
                                  ),
                                ),

                                ElevatedButton(
                                  onPressed: isRequested ? null : () => _requestToJoin(trip),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: isRequested ? Colors.white24 : const Color(0xFFFF7A59),
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  ),
                                  child: Text(
                                    isRequested ? 'Requested ⏳' : 'Request to Join 🤝',
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // Bottom "Host a Stranger Trip ➕" Wooden Sign Button
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                  child: ElevatedButton(
                    onPressed: _hostNewStrangerTrip,
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
                          'Host a Stranger Trip ➕',
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
