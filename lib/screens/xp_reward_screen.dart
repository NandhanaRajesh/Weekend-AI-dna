import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/animated_background.dart';
import '../widgets/kai_mascot.dart';
import '../widgets/kai_bubble.dart';
import 'planner_flow_screen.dart';

/// XP Reward Celebration Screen featuring radiant glow, wax seal +150 XP medallion,
/// star vine level progress bar, passport stamp stickers, and cartwheel Kai commentary.
class XpRewardScreen extends StatefulWidget {
  const XpRewardScreen({super.key});

  @override
  State<XpRewardScreen> createState() => _XpRewardScreenState();
}

class _XpRewardScreenState extends State<XpRewardScreen> {
  String _kaiSpeechText = "LOOK AT YOU. Certified Weekend Legend in training. I'm so proud I could cry (I don't have tear ducts, but the feeling's there) 🎉";

  void _onBadgeTap(String badgeName) {
    HapticFeedback.lightImpact();
    setState(() {
      _kaiSpeechText = "New badge unlocked: $badgeName! I'm framing this. Metaphorically. I don't have walls 🖼️";
    });
  }

  void _planNextWeekend() {
    HapticFeedback.heavyImpact();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const PlannerFlowScreen()),
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
                        'Level Rewards',
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

                // Cartwheel Kai Mascot Header
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

                // Main Celebration Content
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Column(
                      children: [
                        // Large Wax Seal +150 XP Medallion
                        Container(
                          padding: const EdgeInsets.all(28),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFFFFD166),
                            border: Border.all(color: const Color(0xFF0F0E1A), width: 3),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x80FFD166),
                                blurRadius: 30,
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                          child: Column(
                            children: const [
                              Icon(Icons.military_tech_rounded, size: 48, color: Color(0xFFFF7A59)),
                              SizedBox(height: 4),
                              Text(
                                '+150 XP',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF0F0E1A),
                                  letterSpacing: -1,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 22),

                        // Star Vine Level Progress Card
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            color: Colors.white.withValues(alpha: 0.1),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text(
                                    'Level 4: Local Guide 🌿',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF2DD4BF),
                                    ),
                                  ),
                                  Text(
                                    'Level 5: Adventure Master 👑',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFFFFD166),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 12),

                              // Progress Bar
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: LinearProgressIndicator(
                                  value: 320 / 500,
                                  minHeight: 12,
                                  backgroundColor: Colors.white.withValues(alpha: 0.15),
                                  color: const Color(0xFFFF7A59),
                                ),
                              ),

                              const SizedBox(height: 8),

                              const Text(
                                '320 / 500 XP  •  180 XP to Level 5',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 22),

                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Earned Passport Stamps:',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Passport Stamp Stickers Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _PassportStamp(
                              emoji: '🗺️',
                              title: 'First Hidden Spot',
                              onTap: () => _onBadgeTap('First Hidden Spot 🗺️'),
                              angle: -0.08,
                            ),
                            _PassportStamp(
                              emoji: '📸',
                              title: 'Photo Uploaded',
                              onTap: () => _onBadgeTap('Photo Uploaded 📸'),
                              angle: 0.05,
                            ),
                            _PassportStamp(
                              emoji: '✅',
                              title: 'Trip Completed',
                              onTap: () => _onBadgeTap('Trip Completed ✅'),
                              angle: -0.04,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Bottom Action Button ("Plan Next Weekend 🚀")
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                  child: ElevatedButton(
                    onPressed: _planNextWeekend,
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
                          'Plan Next Weekend 🚀',
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

class _PassportStamp extends StatelessWidget {
  final String emoji;
  final String title;
  final VoidCallback onTap;
  final double angle;

  const _PassportStamp({
    required this.emoji,
    required this.title,
    required this.onTap,
    required this.angle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Transform.rotate(
        angle: angle,
        child: Container(
          width: 92,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white.withValues(alpha: 0.12),
            border: Border.all(color: const Color(0xFFFFD166), width: 1.8),
            boxShadow: const [
              BoxShadow(
                color: Color(0x40000000),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 28)),
              const SizedBox(height: 6),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
