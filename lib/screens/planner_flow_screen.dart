import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/animated_background.dart';
import '../widgets/kai_mascot.dart';
import '../widgets/kai_bubble.dart';
import '../widgets/mood_tiles.dart';
import '../widgets/friends_step.dart';
import '../widgets/budget_step.dart';
import '../widgets/distance_step.dart';
import '../widgets/transport_step.dart';
import '../widgets/activities_step.dart';
import '../widgets/food_step.dart';
import '../widgets/weather_step.dart';
import '../widgets/ai_thinking_step.dart';
import 'home_screen.dart';
import 'final_itinerary_screen.dart';

/// 9-Step Weekend Planning Flow Screen featuring PageView deck transitions,
/// progress dots, Kai speech commentary, and interactive mood check tiles.
class PlannerFlowScreen extends StatefulWidget {
  const PlannerFlowScreen({super.key});

  @override
  State<PlannerFlowScreen> createState() => _PlannerFlowScreenState();
}

class _PlannerFlowScreenState extends State<PlannerFlowScreen> {
  late PageController _pageController;
  int _currentStep = 0;

  // Selected State
  String? _selectedMood = 'adventurous';
  String _selectedSquad = 'Squad (3-4)';
  String _selectedBudget = 'Moderate (\$\$)';
  String _selectedDistance = 'Short Drive (15-30m)';

  // Kai Speech Commentary per Step
  String _kaiSpeechText = "How's your energy today? Be honest, I won't judge 👀";

  static const int totalSteps = 9;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextStep() {
    HapticFeedback.mediumImpact();

    // Auto-skip Weather step (Step 7 -> 8) with Kai commentary if reaching weather
    if (_currentStep == 6) {
      // Step 7: Food -> Step 8: Weather (Auto-skipped to Step 9)
      setState(() {
        _kaiSpeechText = "Already checked the weather — 72°F and sunny, no umbrella needed ☀️ skipping right to AI itinerary!";
      });
      _pageController.animateToPage(
        8,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
      return;
    }

    if (_currentStep < totalSteps - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
    } else {
      // Complete flow -> Navigate back to Home
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
    } else {
      Navigator.of(context).pop();
    }
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
                // Top App Bar Navigation Row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: _previousStep,
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white.withValues(alpha: 0.1),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white.withValues(alpha: 0.12),
                        ),
                        child: Text(
                          'Step ${_currentStep + 1} of $totalSteps',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF2DD4BF),
                          ),
                        ),
                      ),
                      const SizedBox(width: 44), // Alignment balance
                    ],
                  ),
                ),

                // Peeking Kai Mascot Header & Reactive Speech Bubble
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const KaiMascot(size: 58, expression: KaiExpression.happy),
                      const SizedBox(width: 10),
                      Expanded(
                        child: KaiBubble(text: _kaiSpeechText),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Main PageView Flow Decks
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentStep = index;
                      });
                    },
                    children: [
                      // Step 1: Mood Check
                      _buildStepContainer(
                        child: SingleChildScrollView(
                          child: MoodTiles(
                            selectedId: _selectedMood,
                            onMoodSelected: (mood) {
                              setState(() {
                                _selectedMood = mood.id;
                                _kaiSpeechText = mood.kaiReaction;
                              });
                            },
                          ),
                        ),
                      ),

                      // Step 2: Squad & Friends
                      _buildStepContainer(
                        child: SingleChildScrollView(
                          child: FriendsStep(
                            selectedMode: _selectedSquad == 'friends' ? 'friends' : 'solo',
                            onModeChanged: (mode) {
                              setState(() {
                                _selectedSquad = mode;
                                _kaiSpeechText = mode == 'friends'
                                    ? "Chaos squad assemble! 👯 Let's see who's tagging along."
                                    : "Flying solo! Time for some quality Me-Time 🧍";
                              });
                            },
                          ),
                        ),
                      ),

                      // Step 3: Budget
                      _buildStepContainer(
                        child: SingleChildScrollView(
                          child: BudgetStep(
                            currentBudget: 1500,
                            onBudgetChanged: (val) {
                              setState(() {
                                _selectedBudget = '₹${val.toInt()}';
                              });
                              debugPrint('Budget updated: $_selectedBudget');
                            },
                            onKaiReactionChanged: (reaction) {
                              setState(() {
                                _kaiSpeechText = reaction;
                              });
                            },
                          ),
                        ),
                      ),

                      // Step 4: Distance
                      _buildStepContainer(
                        child: SingleChildScrollView(
                          child: DistanceStep(
                            currentDistance: 15,
                            onDistanceChanged: (val) {
                              setState(() {
                                _selectedDistance = '${val.toInt()} km';
                              });
                              debugPrint('Distance updated: $_selectedDistance');
                            },
                            onKaiReactionChanged: (reaction) {
                              setState(() {
                                _kaiSpeechText = reaction;
                              });
                            },
                          ),
                        ),
                      ),

                      // Step 5: Transport
                      _buildStepContainer(
                        child: SingleChildScrollView(
                          child: TransportStep(
                            selectedTransport: 'car',
                            onTransportChanged: (val) {
                              debugPrint('Transport selected: $val');
                            },
                            onKaiReactionChanged: (reaction) {
                              setState(() {
                                _kaiSpeechText = reaction;
                              });
                            },
                          ),
                        ),
                      ),

                      // Step 6: Activities
                      _buildStepContainer(
                        child: SingleChildScrollView(
                          child: ActivitiesStep(
                            selectedActivities: const {'creative', 'adventure', 'food'},
                            onActivitiesChanged: (selected) {
                              debugPrint('Activities selected: $selected');
                            },
                            onKaiReactionChanged: (reaction) {
                              setState(() {
                                _kaiSpeechText = reaction;
                              });
                            },
                          ),
                        ),
                      ),

                      // Step 7: Food Vibes
                      _buildStepContainer(
                        child: SingleChildScrollView(
                          child: FoodStep(
                            selectedFoodId: 'cafe',
                            selectedDietary: 'No Preference 😋',
                            onFoodChanged: (val) {
                              debugPrint('Food selected: $val');
                            },
                            onDietaryChanged: (diet) {
                              debugPrint('Dietary selected: $diet');
                            },
                            onKaiReactionChanged: (reaction) {
                              setState(() {
                                _kaiSpeechText = reaction;
                              });
                            },
                          ),
                        ),
                      ),

                      // Step 8: Weather (Auto-skipped preview)
                      _buildStepContainer(
                        child: WeatherStep(
                          onAutoAdvance: () {
                            _pageController.animateToPage(
                              8,
                              duration: const Duration(milliseconds: 600),
                              curve: Curves.easeInOutCubic,
                            );
                          },
                        ),
                      ),

                      // Step 9: AI Generation
                      _buildStepContainer(
                        child: AiThinkingStep(
                          onComplete: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (_) => const FinalItineraryScreen()),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                // Bottom Progress Dots & Next Button
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                  child: Column(
                    children: [
                      // 9 Progress Dots Indicator
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(totalSteps, (index) {
                          final isSelected = index == _currentStep;
                          final isPassed = index < _currentStep;

                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 3.5),
                            width: isSelected ? 18 : 7,
                            height: 7,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: isSelected
                                  ? const Color(0xFFFF7A59)
                                  : (isPassed
                                      ? const Color(0xFF2DD4BF)
                                      : Colors.white.withValues(alpha: 0.2)),
                            ),
                          );
                        }),
                      ),

                      const SizedBox(height: 14),

                      // Coral Pill Next Button
                      ElevatedButton(
                        onPressed: _nextStep,
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
                              colors: [
                                Color(0xFFFF7A59),
                                Color(0xFF8B5CF6),
                              ],
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _currentStep == totalSteps - 1 ? 'View My Itinerary 🚀' : 'Next Step ➔',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepContainer({required Widget child}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      child: child,
    );
  }




}
