import 'package:flutter/material.dart';
import '../widgets/animated_background.dart';
import '../widgets/greeting_header.dart';
import '../widgets/kai_bubble.dart';
import '../widgets/recommendation_cards.dart';
import '../widgets/hidden_gems.dart';
import '../widgets/bottom_nav_bar.dart';

/// Full interactive HomeScreen implementation with reactive Kai AI mascot,
/// goofy speech reactions, tilted drag cards, and hidden gems.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentTab = 0;
  String _kaiSpeechText = "Ta-da! I stalked the weather for you 👀 here's your weekend, served hot.";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Animated Mesh Gradient
          const AnimatedBackground(),

          // Main Scrollable Content Area
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top Greeting Header with Vector Kai AI Mascot
                        const GreetingHeader(userName: 'Alex'),

                        const SizedBox(height: 8),

                        // Goofy Reactive Kai Speech Bubble
                        KaiBubble(text: _kaiSpeechText),

                        const SizedBox(height: 14),

                        // Horizontally-Swipeable Tilted Recommendation Cards Stack
                        RecommendationCards(
                          onCardChanged: (reactionText) {
                            setState(() {
                              _kaiSpeechText = reactionText;
                            });
                          },
                        ),

                        const SizedBox(height: 18),

                        // Nearby Hidden Gems Section
                        const HiddenGems(),
                      ],
                    ),
                  ),
                ),

                // Floating Glassmorphic Bottom Navigation Bar
                BottomNavBar(
                  selectedIndex: _currentTab,
                  onTabSelected: (index) {
                    setState(() => _currentTab = index);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
