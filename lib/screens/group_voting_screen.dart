import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/animated_background.dart';
import '../widgets/kai_mascot.dart';
import '../widgets/kai_bubble.dart';

class VoterStatus {
  final String name;
  final String avatarEmoji;
  final String voteState; // 'yes', 'skip', 'deciding'
  final Color ringColor;

  const VoterStatus({
    required this.name,
    required this.avatarEmoji,
    required this.voteState,
    required this.ringColor,
  });
}

/// Group Voting Screen featuring Tinder-style card swipe deck, friend vote status bubbles,
/// torn paper progress ribbon, and Kai referee commentary.
class GroupVotingScreen extends StatefulWidget {
  const GroupVotingScreen({super.key});

  static const List<VoterStatus> voters = [
    VoterStatus(name: 'Alex', avatarEmoji: '👦', voteState: 'yes', ringColor: Color(0xFFFF7A59)),
    VoterStatus(name: 'Maya', avatarEmoji: '👧', voteState: 'yes', ringColor: Color(0xFF2DD4BF)),
    VoterStatus(name: 'Jordan', avatarEmoji: '🧒', voteState: 'deciding', ringColor: Color(0xFF8B5CF6)),
  ];

  @override
  State<GroupVotingScreen> createState() => _GroupVotingScreenState();
}

class _GroupVotingScreenState extends State<GroupVotingScreen> {
  String _kaiSpeechText = "Democracy time. Try to agree quickly, I get anxious watching group chats argue 📣";
  double _swipeDragOffset = 0.0;
  bool _hasRevealedWinner = false;

  void _onSwipeLeft() {
    HapticFeedback.mediumImpact();
    setState(() {
      _swipeDragOffset = -150.0;
      _kaiSpeechText = "Skipped! Moving to the next adventure option ⏩";
    });
  }

  void _onSwipeRight() {
    HapticFeedback.mediumImpact();
    setState(() {
      _swipeDragOffset = 150.0;
      _kaiSpeechText = "Voted YES! Adding your vote to the tally 💖";
    });
  }

  void _revealWinner() {
    HapticFeedback.heavyImpact();
    setState(() {
      _hasRevealedWinner = true;
      _kaiSpeechText = "And the winner is... Sunset Ridge Trek & Glamping! 🏆 Actual consensus!";
    });
  }

  @override
  Widget build(BuildContext context) {
    final votedCount = GroupVotingScreen.voters.where((v) => v.voteState != 'deciding').length;

    return Scaffold(
      body: Stack(
        children: [
          // Background Mesh
          const AnimatedBackground(),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Column(
                children: [
                  // App Bar
                  Row(
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
                        'Squad Voting Deck',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 44),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Kai Referee Mascot Header
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const KaiMascot(size: 60, expression: KaiExpression.excited),
                      const SizedBox(width: 8),
                      Expanded(
                        child: KaiBubble(text: _kaiSpeechText),
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // Tinder-Style Swipeable Plan Card Deck
                  Expanded(
                    child: Center(
                      child: GestureDetector(
                        onHorizontalDragUpdate: (details) {
                          setState(() {
                            _swipeDragOffset += details.delta.dx;
                          });
                        },
                        onHorizontalDragEnd: (details) {
                          if (_swipeDragOffset > 80) {
                            _onSwipeRight();
                          } else if (_swipeDragOffset < -80) {
                            _onSwipeLeft();
                          } else {
                            setState(() => _swipeDragOffset = 0.0);
                          }
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeOutCubic,
                          transform: Matrix4.translationValues(_swipeDragOffset, 0, 0)
                            ..rotateZ(_swipeDragOffset * 0.001),
                          child: const _VotingPlanCard(),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Friend Avatar Status Bubbles (Heart, X, Hourglass)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: GroupVotingScreen.voters.map((voter) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                Container(
                                  width: 52,
                                  height: 52,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withValues(alpha: 0.1),
                                    border: Border.all(color: voter.ringColor, width: 2.5),
                                  ),
                                  child: Center(
                                    child: Text(voter.avatarEmoji, style: const TextStyle(fontSize: 24)),
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: voter.voteState == 'yes'
                                          ? const Color(0xFFFF7A59)
                                          : (voter.voteState == 'skip'
                                              ? const Color(0xFFFF5252)
                                              : const Color(0xFFFFB703)),
                                    ),
                                    child: Icon(
                                      voter.voteState == 'yes'
                                          ? Icons.favorite_rounded
                                          : (voter.voteState == 'skip'
                                              ? Icons.close_rounded
                                              : Icons.hourglass_top_rounded),
                                      size: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              voter.name,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 14),

                  // Torn Paper Ribbon Progress Banner
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFD166),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF0F0E1A), width: 1.8),
                    ),
                    child: Text(
                      '$votedCount of ${GroupVotingScreen.voters.length} friends have voted 🗳️',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF0F0E1A),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // "Reveal Winner" Button
                  ElevatedButton(
                    onPressed: _revealWinner,
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
                          colors: _hasRevealedWinner
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
                          _hasRevealedWinner ? 'Winner Revealed! 🏆' : 'Reveal Winner 🏆',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VotingPlanCard extends StatelessWidget {
  const _VotingPlanCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 290,
      height: 320,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: const LinearGradient(
          colors: [Color(0xFFFF7A59), Color(0xFF8B5CF6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF7A59).withValues(alpha: 0.35),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1.5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: Stack(
          children: [
            // Center Vignette Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: Colors.black.withValues(alpha: 0.3),
                    ),
                    child: const Text(
                      'Option 1 of 3',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                  ),

                  const Spacer(),

                  const Text(
                    'Sunset Ridge Trek & Glamping',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: const [
                      Icon(Icons.near_me_rounded, size: 14, color: Colors.white),
                      SizedBox(width: 4),
                      Text('12 km  •  \$\$\$  •  24°C Sunny', style: TextStyle(fontSize: 12, color: Colors.white)),
                    ],
                  ),
                ],
              ),
            ),

            // Left Skip Stamp Indicator
            Positioned(
              top: 20,
              left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.red.withValues(alpha: 0.8),
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
                child: const Text(
                  'SKIP ✖',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.white),
                ),
              ),
            ),

            // Right Yes Stamp Indicator
            Positioned(
              top: 20,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: const Color(0xFF2DD4BF),
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
                child: const Text(
                  'YES 💖',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
