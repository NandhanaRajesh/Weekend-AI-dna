import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/animated_background.dart';
import '../widgets/kai_mascot.dart';
import '../widgets/kai_bubble.dart';
import 'expense_prediction_screen.dart';

class PlanOptionItem {
  final String id;
  final String title;
  final String category;
  final String matchScore;
  final String ribbonLabel;
  final String distance;
  final String priceRange;
  final String weather;
  final String marginNote;
  final String kaiLine;
  final List<Color> gradientColors;
  final IconData icon;

  const PlanOptionItem({
    required this.id,
    required this.title,
    required this.category,
    required this.matchScore,
    required this.ribbonLabel,
    required this.distance,
    required this.priceRange,
    required this.weather,
    required this.marginNote,
    required this.kaiLine,
    required this.gradientColors,
    required this.icon,
  });
}

/// Recommendations Choose Your Plan Screen featuring vertical storybook plan cards,
/// Kai perched presentation, hand-drawn marker scribbles, margin notes, and reactive Kai lines.
class RecommendationsScreen extends StatefulWidget {
  const RecommendationsScreen({super.key});

  static const List<PlanOptionItem> planList = [
    PlanOptionItem(
      id: 'adventure',
      title: 'Adventure Escape: Sunset Ridge & Glamping',
      category: 'Mountain Trail',
      matchScore: '96%',
      ribbonLabel: '96% MATCH',
      distance: '12 km',
      priceRange: '\$\$\$',
      weather: '24°C Sunny',
      marginNote: '✨ fits your sunset & trail mood',
      kaiLine: "96% match. I'm never wrong about these.",
      gradientColors: [Color(0xFFFF7A59), Color(0xFF8B5CF6)],
      icon: Icons.landscape_rounded,
    ),
    PlanOptionItem(
      id: 'cozy',
      title: 'Cozy Saturday: Pottery & Wine Workshop',
      category: 'Creative Studio',
      matchScore: '88%',
      ribbonLabel: '88% MATCH',
      distance: '4.5 km',
      priceRange: '\$\$',
      weather: 'Cozy Indoor',
      marginNote: '☕ perfect for coffee & pottery',
      kaiLine: "Ooh, good choice! I have opinions about that one too.",
      gradientColors: [Color(0xFF6C63FF), Color(0xFF2DD4BF)],
      icon: Icons.palette_rounded,
    ),
    PlanOptionItem(
      id: 'datenight',
      title: 'Date Night: Rooftop Jazz & Speakeasy',
      category: 'Skyline Bar',
      matchScore: '74%',
      ribbonLabel: '74% WILDCARD',
      distance: '3.8 km',
      priceRange: '\$\$\$\$',
      weather: '21°C Clear',
      marginNote: '🎷 wildcard jazz & rooftop',
      kaiLine: "This one's riskier. But sometimes the weird pick is the best story later.",
      gradientColors: [Color(0xFF8B5CF6), Color(0xFFFF7A59)],
      icon: Icons.nightlife_rounded,
    ),
  ];

  @override
  State<RecommendationsScreen> createState() => _RecommendationsScreenState();
}

class _RecommendationsScreenState extends State<RecommendationsScreen> {
  int _selectedIndex = 0;
  String _kaiSpeechText = "Ta-da! Three weekends, all designed by yours truly. Pick your favorite — I'll only be a LITTLE offended if it's not the first one.";

  void _onSelectPlan(int index) {
    HapticFeedback.lightImpact();
    setState(() {
      _selectedIndex = index;
      _kaiSpeechText = RecommendationsScreen.planList[index].kaiLine;
    });
  }

  void _confirmChoice() {
    HapticFeedback.heavyImpact();
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ExpensePredictionScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedPlan = RecommendationsScreen.planList[_selectedIndex];

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
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white.withValues(alpha: 0.1),
                        ),
                      ),
                      const Text(
                        'Choose Your Plan',
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

                // Perched Kai Presentation Header & Speech Bubble
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const KaiMascot(size: 64, expression: KaiExpression.excited),
                      const SizedBox(width: 8),
                      Expanded(
                        child: KaiBubble(text: _kaiSpeechText),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Vertical List of Hand-Painted Storybook Plan Cards
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    physics: const BouncingScrollPhysics(),
                    itemCount: RecommendationsScreen.planList.length,
                    itemBuilder: (context, index) {
                      final item = RecommendationsScreen.planList[index];
                      final isSelected = index == _selectedIndex;

                      return GestureDetector(
                        onTap: () => _onSelectPlan(index),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: _VerticalStorybookCard(
                            plan: item,
                            isSelected: isSelected,
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Bottom Hand-Painted Wooden-Sign Button ("Choose This Plan")
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                  child: ElevatedButton(
                    onPressed: _confirmChoice,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 0,
                    ),
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: LinearGradient(
                          colors: [
                            selectedPlan.gradientColors[0],
                            selectedPlan.gradientColors[1],
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: selectedPlan.gradientColors[0].withValues(alpha: 0.5),
                            blurRadius: 18,
                            offset: const Offset(0, 6),
                          ),
                        ],
                        border: Border.all(
                          color: const Color(0xFFFFD166),
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'Choose "${selectedPlan.category}" 🚀',
                              style: const TextStyle(
                                fontSize: 16.5,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                          ],
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

class _VerticalStorybookCard extends StatelessWidget {
  final PlanOptionItem plan;
  final bool isSelected;

  const _VerticalStorybookCard({
    required this.plan,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [
            plan.gradientColors[0].withValues(alpha: isSelected ? 0.9 : 0.4),
            plan.gradientColors[1].withValues(alpha: isSelected ? 0.7 : 0.2),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: isSelected ? const Color(0xFFFFD166) : Colors.white.withValues(alpha: 0.2),
          width: isSelected ? 2.8 : 1.2,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: plan.gradientColors[0].withValues(alpha: 0.45),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ]
            : null,
      ),
      child: Stack(
        children: [
          // Marker Circle Scribble Highlight Painter on Selected Card
          if (isSelected)
            Positioned.fill(
              child: CustomPaint(
                painter: _MarkerHighlightPainter(color: const Color(0xFFFFD166)),
              ),
            ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Category Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.black.withValues(alpha: 0.35),
                    ),
                    child: Row(
                      children: [
                        Icon(plan.icon, size: 14, color: Colors.white),
                        const SizedBox(width: 6),
                        Text(
                          plan.category,
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Top Right Wax Seal Ribbon Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFD166),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFF0F0E1A), width: 1.5),
                    ),
                    child: Text(
                      plan.ribbonLabel,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF0F0E1A),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Title
              Text(
                plan.title,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: -0.3,
                ),
              ),

              const SizedBox(height: 10),

              // Metadata Row
              Row(
                children: [
                  _IconTag(icon: Icons.near_me_rounded, text: plan.distance),
                  const SizedBox(width: 12),
                  _IconTag(icon: Icons.attach_money_rounded, text: plan.priceRange),
                  const SizedBox(width: 12),
                  _IconTag(icon: Icons.wb_sunny_rounded, text: plan.weather, color: const Color(0xFF2DD4BF)),
                ],
              ),

              const SizedBox(height: 10),

              // Handwritten Margin Note
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white.withValues(alpha: 0.12),
                ),
                child: Text(
                  plan.marginNote,
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFFFD166),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _IconTag extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? color;

  const _IconTag({
    required this.icon,
    required this.text,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = color ?? Colors.white.withValues(alpha: 0.85);

    return Row(
      children: [
        Icon(icon, size: 13, color: textColor),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
      ],
    );
  }
}

class _MarkerHighlightPainter extends CustomPainter {
  final Color color;

  _MarkerHighlightPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(1, 1, size.width - 2, size.height - 2);
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(22));

    final paint = Paint()
      ..color = color.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant _MarkerHighlightPainter oldDelegate) => false;
}
