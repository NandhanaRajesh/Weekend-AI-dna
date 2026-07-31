import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/animated_background.dart';
import '../widgets/kai_mascot.dart';
import '../widgets/kai_bubble.dart';
import 'weekend_dna_screen.dart';

/// Kai Welcome Screen (celebratory intro post-signup)
class KaiWelcomeScreen extends StatelessWidget {
  const KaiWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Mesh
          const AnimatedBackground(),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),

                  // Speech Bubble Top
                  const KaiBubble(
                    text: "Hi, I'm Kai! Your slightly chaotic, extremely enthusiastic weekend planner. Let's build your Weekend DNA 🧬",
                  ),

                  const SizedBox(height: 36),

                  // Center Stage Kai Mascot with Ambient Glow
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 200,
                        height: 200,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x70FF7A59),
                              blurRadius: 50,
                              spreadRadius: 20,
                            ),
                            BoxShadow(
                              color: Color(0x502DD4BF),
                              blurRadius: 60,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                      ),
                      const KaiMascot(size: 140, expression: KaiExpression.excited),
                    ],
                  ),

                  const Spacer(),

                  // Single Coral "Let's go ➔" Pill Button
                  ElevatedButton(
                    onPressed: () {
                      HapticFeedback.heavyImpact();
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const WeekendDnaScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 0,
                    ),
                    child: Container(
                      height: 58,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFFF7A59),
                            Color(0xFF8B5CF6),
                            Color(0xFF2DD4BF),
                          ],
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x70FF7A59),
                            blurRadius: 20,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              "Let's go ➔",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
