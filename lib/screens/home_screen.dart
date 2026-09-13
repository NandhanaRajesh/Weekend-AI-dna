import 'package:flutter/material.dart';
import '../widgets/animated_background.dart';
import '../widgets/greeting_header.dart';
import '../widgets/kai_bubble.dart';
import '../widgets/recommendation_cards.dart';
import '../widgets/hidden_gems.dart';
import '../widgets/bottom_nav_bar.dart';
import 'planner_flow_screen.dart';
import 'memory_recap_screen.dart';
import 'public_trips_screen.dart';
import 'auth_screen.dart';
import '../services/auth_service.dart';

/// Full interactive HomeScreen implementation with reactive Kai AI mascot,
/// goofy speech reactions, tilted drag cards, and hidden gems.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentTab = 0;
  String _kaiSpeechText = "TA-DA. Three weekends, all designed by yours truly. Try not to cry 🪄";

  Future<void> _showProfileMenu() async {
    final email = AuthService.currentUser?.email ?? 'Signed-in account';
    final shouldSignOut = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: const Color(0xFF161426),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Your profile',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              Text(email, style: TextStyle(color: Colors.white.withValues(alpha: 0.7))),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => Navigator.of(context).pop(true),
                  icon: const Icon(Icons.logout_rounded),
                  label: const Text('Log out'),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (shouldSignOut != true || !mounted) return;
    await AuthService.signOut();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const AuthScreen()),
      (_) => false,
    );
  }

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
                    if (index == 1) {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const PlannerFlowScreen()),
                      );
                    } else if (index == 2) {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const PublicTripsScreen()),
                      );
                    } else if (index == 3) {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const MemoryRecapScreen()),
                      );
                    } else if (index == 4) {
                      _showProfileMenu();
                    } else {
                      setState(() => _currentTab = index);
                    }
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
