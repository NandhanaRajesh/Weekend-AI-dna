import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StorybookPlan {
  final String title;
  final String category;
  final String matchScore;
  final String ribbonLabel;
  final String distance;
  final String priceRange;
  final String weather;
  final String kaiCommentary;
  final IconData weatherIcon;
  final List<Color> gradientColors;
  final IconData categoryIcon;

  const StorybookPlan({
    required this.title,
    required this.category,
    required this.matchScore,
    required this.ribbonLabel,
    required this.distance,
    required this.priceRange,
    required this.weather,
    required this.kaiCommentary,
    required this.weatherIcon,
    required this.gradientColors,
    required this.categoryIcon,
  });
}

/// Fanned Storybook Playing-Card Stack with Wax Seal Ribbon Match Badges & Reactive Kai Lines.
class RecommendationCards extends StatefulWidget {
  final ValueChanged<String>? onCardChanged;

  const RecommendationCards({
    super.key,
    this.onCardChanged,
  });

  static const List<StorybookPlan> plans = [
    StorybookPlan(
      title: 'Sunset Ridge Trek & Glamping',
      category: 'Adventure Escape',
      matchScore: '96%',
      ribbonLabel: '96% MATCH',
      distance: '12 km',
      priceRange: '\$\$\$',
      weather: '24°C Sunny',
      kaiCommentary: "This one's a 96% match. I don't like to brag but I'm never wrong about these 😎",
      weatherIcon: Icons.wb_sunny_rounded,
      gradientColors: [Color(0xFFFF7A59), Color(0xFF8B5CF6)],
      categoryIcon: Icons.landscape_rounded,
    ),
    StorybookPlan(
      title: 'Artisan Pottery & Wine Workshop',
      category: 'Cozy Saturday',
      matchScore: '94%',
      ribbonLabel: '94% MATCH',
      distance: '4.5 km',
      priceRange: '\$\$',
      weather: 'Cozy Indoor',
      kaiCommentary: "Ooh, good choice to look at next. I have opinions about that one too 💬",
      weatherIcon: Icons.palette_rounded,
      gradientColors: [Color(0xFF6C63FF), Color(0xFF2DD4BF)],
      categoryIcon: Icons.brush_rounded,
    ),
    StorybookPlan(
      title: 'Rooftop Jazz & Wildcard Speakeasy',
      category: 'Date Night',
      matchScore: '62%',
      ribbonLabel: '62% WILDCARD',
      distance: '3.8 km',
      priceRange: '\$\$\$\$',
      weather: '21°C Clear',
      kaiCommentary: "This one's riskier — 62%. But sometimes the weird pick is the best story later 🎰",
      weatherIcon: Icons.nightlight_round,
      gradientColors: [Color(0xFF8B5CF6), Color(0xFFFF7A59)],
      categoryIcon: Icons.local_bar_rounded,
    ),
  ];

  @override
  State<RecommendationCards> createState() => _RecommendationCardsState();
}

class _RecommendationCardsState extends State<RecommendationCards> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.84, initialPage: 0);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onCardChanged?.call(RecommendationCards.plans[0].kaiCommentary);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    HapticFeedback.lightImpact();
    setState(() => _currentPage = index);
    widget.onCardChanged?.call(RecommendationCards.plans[index].kaiCommentary);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Section Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 20,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF7A59), Color(0xFFFFD166)],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Revealed Plans',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: -0.3,
                    ),
                  ),
                ],
              ),
              const Text(
                'swipe to see more →',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2DD4BF),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 10),

        // Fanned PageView Cards
        SizedBox(
          height: 315,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: RecommendationCards.plans.length,
            itemBuilder: (context, index) {
              final plan = RecommendationCards.plans[index];
              final isCurrent = index == _currentPage;

              // Fanned rotation angles
              final rotationAngle = isCurrent ? 0.0 : (index > _currentPage ? 0.05 : -0.05);

              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                margin: EdgeInsets.only(
                  right: 12,
                  top: isCurrent ? 0 : 12,
                  bottom: isCurrent ? 0 : 12,
                ),
                child: Transform.rotate(
                  angle: rotationAngle,
                  child: _FannedStorybookCard(
                    plan: plan,
                    isActive: isCurrent,
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 14),

        // Page Indicator Dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(RecommendationCards.plans.length, (index) {
            final isSelected = _currentPage == index;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: isSelected ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: isSelected
                    ? const LinearGradient(
                        colors: [Color(0xFFFF7A59), Color(0xFFFFD166)],
                      )
                    : null,
                color: isSelected ? null : Colors.white.withValues(alpha: 0.2),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _FannedStorybookCard extends StatelessWidget {
  final StorybookPlan plan;
  final bool isActive;

  const _FannedStorybookCard({
    required this.plan,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: LinearGradient(
          colors: [
            plan.gradientColors[0].withValues(alpha: 0.85),
            plan.gradientColors[1].withValues(alpha: 0.65),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: plan.gradientColors[0].withValues(alpha: 0.35),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: Stack(
          children: [
            // Category Top Left
            Positioned(
              top: 14,
              left: 14,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Colors.black.withValues(alpha: 0.35),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Icon(plan.categoryIcon, size: 14, color: Colors.white),
                    const SizedBox(width: 6),
                    Text(
                      plan.category,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Top-Right Wax Seal Ribbon Badge
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD166),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF0F0E1A), width: 1.8),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x60000000),
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.verified_rounded, size: 14, color: Color(0xFFFF7A59)),
                    const SizedBox(width: 4),
                    Text(
                      plan.ribbonLabel,
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF0F0E1A),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Information Overlay
            Positioned(
              left: 14,
              right: 14,
              bottom: 14,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ui.ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color(0xFF0F0E1A).withValues(alpha: 0.55),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.25),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          plan.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: -0.4,
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Metadata Tag Badges
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _MetaItem(icon: Icons.near_me_rounded, label: plan.distance),
                            _MetaItem(icon: Icons.attach_money_rounded, label: plan.priceRange),
                            _MetaItem(
                              icon: plan.weatherIcon,
                              label: plan.weather,
                              accentColor: const Color(0xFF2DD4BF),
                            ),
                          ],
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
    );
  }
}

class _MetaItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? accentColor;

  const _MetaItem({
    required this.icon,
    required this.label,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = accentColor ?? Colors.white.withValues(alpha: 0.9);

    return Row(
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }
}
