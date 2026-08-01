import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/animated_background.dart';
import '../widgets/kai_mascot.dart';
import '../widgets/kai_bubble.dart';
import 'xp_reward_screen.dart';

/// Post-Trip Memory Recap Screen featuring open scrapbook layout, tilted polaroid frames,
/// washi-tape strips, wax-seal stat badges, and photo-album Kai commentary.
class MemoryRecapScreen extends StatefulWidget {
  const MemoryRecapScreen({super.key});

  @override
  State<MemoryRecapScreen> createState() => _MemoryRecapScreenState();
}

class _MemoryRecapScreenState extends State<MemoryRecapScreen> {
  String _kaiSpeechText = "This one's going in my favorites folder. Don't tell the other weekends 📖";
  bool _hasShared = false;

  void _onAddPhotos() {
    HapticFeedback.lightImpact();
    setState(() {
      _kaiSpeechText = "Ooh yes! Add more memories to our picture book 📸";
    });
  }

  void _onShareStory() {
    HapticFeedback.heavyImpact();
    setState(() {
      _hasShared = true;
      _kaiSpeechText = "Sent! Now everyone gets to be jealous of us. As they should 💌";
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const XpRewardScreen()),
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
                // Top App Bar
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
                        'Scrapbook Memory',
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

                // Kai Photo Album Mascot Header
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

                // Main Scrapbook Page Content
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Journal Heading
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Cozy Saturday, Aug 2 📔',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: -0.5,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: const Color(0xFFFFD166),
                                border: Border.all(color: const Color(0xFF0F0E1A), width: 1.5),
                              ),
                              child: const Text(
                                '+250 XP 🌟',
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF0F0E1A),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Polaroid Photo Collage Grid with Tilt Angles & Washi Tape
                        Row(
                          children: [
                            Expanded(
                              child: Transform.rotate(
                                angle: -0.06,
                                child: const _PolaroidCard(
                                  emoji: '🏔️',
                                  caption: 'Sunset Trail View',
                                  tapeColor: Color(0xFFFF7A59),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Transform.rotate(
                                angle: 0.05,
                                child: const _PolaroidCard(
                                  emoji: '🎨',
                                  caption: 'Pottery Workshop',
                                  tapeColor: Color(0xFF2DD4BF),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 22),

                        // Route Line Recap Box
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(22),
                            color: Colors.white.withValues(alpha: 0.08),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Day Recap:',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF2DD4BF),
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                'Sunset Hike ➔ Clay Pottery ➔ Rooftop Jazz & Dinner',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Wax Seal Stat Badges Row
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: const [
                            _WaxSealBadge(icon: Icons.near_me_rounded, label: '12 km Distance', color: Color(0xFFFF7A59)),
                            _WaxSealBadge(icon: Icons.attach_money_rounded, label: '₹1,600 Spent', color: Color(0xFFFFD166)),
                            _WaxSealBadge(icon: Icons.wb_sunny_rounded, label: '24°C Sunny', color: Color(0xFF2DD4BF)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Bottom Action Buttons ("Add More Photos" vs "Share Story")
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                  child: Row(
                    children: [
                      // Secondary Button
                      Expanded(
                        flex: 2,
                        child: OutlinedButton(
                          onPressed: _onAddPhotos,
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(54),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            side: BorderSide(color: Colors.white.withValues(alpha: 0.3), width: 1.5),
                          ),
                          child: const Text(
                            'Add Photos 📸',
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Primary Button
                      Expanded(
                        flex: 3,
                        child: ElevatedButton(
                          onPressed: _onShareStory,
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
                              gradient: LinearGradient(
                                colors: _hasShared
                                    ? [const Color(0xFF2DD4BF), const Color(0xFF6C63FF)]
                                    : [const Color(0xFFFF7A59), const Color(0xFF8B5CF6)],
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x60FF7A59),
                                  blurRadius: 16,
                                  offset: Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                _hasShared ? 'Story Shared! 💌' : 'Share Story 📤',
                                style: const TextStyle(
                                  fontSize: 15.5,
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

class _PolaroidCard extends StatelessWidget {
  final String emoji;
  final String caption;
  final Color tapeColor;

  const _PolaroidCard({
    required this.emoji,
    required this.caption,
    required this.tapeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Color(0x50000000),
                blurRadius: 12,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                height: 110,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color(0xFF1E1B33),
                ),
                child: Center(
                  child: Text(emoji, style: const TextStyle(fontSize: 42)),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                caption,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F0E1A),
                ),
              ),
            ],
          ),
        ),

        // Washi Tape Strip
        Positioned(
          top: -6,
          left: 30,
          child: Container(
            width: 44,
            height: 16,
            decoration: BoxDecoration(
              color: tapeColor.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ],
    );
  }
}

class _WaxSealBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _WaxSealBadge({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: color.withValues(alpha: 0.25),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
