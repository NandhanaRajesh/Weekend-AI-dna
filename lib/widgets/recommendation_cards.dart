import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WeekendAdventure {
  final String title;
  final String category;
  final String matchScore;
  final String stickerText;
  final String distance;
  final String priceRange;
  final String weather;
  final String kaiReaction;
  final IconData weatherIcon;
  final List<Color> gradientColors;
  final IconData categoryIcon;

  const WeekendAdventure({
    required this.title,
    required this.category,
    required this.matchScore,
    required this.stickerText,
    required this.distance,
    required this.priceRange,
    required this.weather,
    required this.kaiReaction,
    required this.weatherIcon,
    required this.gradientColors,
    required this.categoryIcon,
  });
}

/// Physics-based tilted drag card stack with stamped sticker match badges
/// and Kai speech reaction callbacks.
class RecommendationCards extends StatefulWidget {
  final ValueChanged<String>? onCardChanged;

  const RecommendationCards({
    super.key,
    this.onCardChanged,
  });

  static const List<WeekendAdventure> adventures = [
    WeekendAdventure(
      title: 'Sunset Ridge Trek & Glamping',
      category: 'Adventure Escape',
      matchScore: '96%',
      stickerText: '96% VIBE MATCH',
      distance: '12 km',
      priceRange: '\$\$\$',
      weather: '24°C Sunny',
      kaiReaction: '96% match. Basically I know you better than your group chat does 😎',
      weatherIcon: Icons.wb_sunny_rounded,
      gradientColors: [Color(0xFFFF7A59), Color(0xFF8B5CF6)],
      categoryIcon: Icons.landscape_rounded,
    ),
    WeekendAdventure(
      title: 'Artisan Pottery & Wine Workshop',
      category: 'Creative Craft',
      matchScore: '94%',
      stickerText: '94% VIBE MATCH',
      distance: '4.5 km',
      priceRange: '\$\$',
      weather: 'Cozy Indoor',
      kaiReaction: 'Ta-da! I stalked the weather for you 👀 here\'s your weekend, served hot.',
      weatherIcon: Icons.palette_rounded,
      gradientColors: [Color(0xFF6C63FF), Color(0xFF2DD4BF)],
      categoryIcon: Icons.brush_rounded,
    ),
    WeekendAdventure(
      title: 'Retro Arcade & Mystery Speakeasy',
      category: 'Wildcard Night',
      matchScore: '62%',
      stickerText: '62% WILDCARD',
      distance: '3.8 km',
      priceRange: '\$\$',
      weather: '20°C Clear',
      kaiReaction: '62% — a wildcard pick. Might be great, might be weird. That\'s the fun part 🎯',
      weatherIcon: Icons.nightlight_round,
      gradientColors: [Color(0xFF8B5CF6), Color(0xFFFF7A59)],
      categoryIcon: Icons.sports_esports_rounded,
    ),
  ];

  @override
  State<RecommendationCards> createState() => _RecommendationCardsState();
}

class _RecommendationCardsState extends State<RecommendationCards>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  int _currentPage = 0;

  // Drag physics tracking
  double _dragOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.85, initialPage: 0);

    // Initial reaction callback on load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onCardChanged?.call(RecommendationCards.adventures[0].kaiReaction);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    HapticFeedback.lightImpact();
    setState(() {
      _currentPage = index;
      _dragOffset = 0.0;
    });
    widget.onCardChanged?.call(RecommendationCards.adventures[index].kaiReaction);
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
                    'Handpicked Plans',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: -0.3,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white.withValues(alpha: 0.12),
                ),
                child: Text(
                  'Swipe cards 👉',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF2DD4BF),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 10),

        // Horizontal Tilted Drag PageView
        SizedBox(
          height: 315,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: RecommendationCards.adventures.length,
            itemBuilder: (context, index) {
              final item = RecommendationCards.adventures[index];
              final isCurrent = index == _currentPage;

              // Tilt card rotation calculation (slightly tilted when peeking or dragging)
              final baseTiltAngle = isCurrent ? 0.0 : (index > _currentPage ? 0.06 : -0.06);
              final dynamicDragTilt = isCurrent ? (_dragOffset * 0.0004) : 0.0;
              final tiltAngle = baseTiltAngle + dynamicDragTilt;

              return GestureDetector(
                onHorizontalDragUpdate: (details) {
                  if (isCurrent) {
                    setState(() {
                      _dragOffset += details.delta.dx;
                    });
                  }
                },
                onHorizontalDragEnd: (details) {
                  if (isCurrent) {
                    setState(() {
                      _dragOffset = 0.0;
                    });
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOutCubic,
                  margin: EdgeInsets.only(
                    right: 12,
                    left: index == 0 ? 0 : 4,
                    top: isCurrent ? 0 : 12,
                    bottom: isCurrent ? 0 : 12,
                  ),
                  child: Transform.rotate(
                    angle: tiltAngle,
                    child: _StickerTiltedCard(
                      adventure: item,
                      isActive: isCurrent,
                    ),
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
          children: List.generate(RecommendationCards.adventures.length, (index) {
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

class _StickerTiltedCard extends StatefulWidget {
  final WeekendAdventure adventure;
  final bool isActive;

  const _StickerTiltedCard({
    required this.adventure,
    required this.isActive,
  });

  @override
  State<_StickerTiltedCard> createState() => _StickerTiltedCardState();
}

class _StickerTiltedCardState extends State<_StickerTiltedCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _stickerPopController;

  @override
  void initState() {
    super.initState();
    _stickerPopController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    if (widget.isActive) {
      _stickerPopController.forward();
    }
  }

  @override
  void didUpdateWidget(covariant _StickerTiltedCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _stickerPopController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _stickerPopController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          colors: [
            widget.adventure.gradientColors[0].withValues(alpha: 0.85),
            widget.adventure.gradientColors[1].withValues(alpha: 0.65),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: widget.adventure.gradientColors[0].withValues(alpha: 0.35),
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
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [
            // Background Artwork Illustration
            Positioned.fill(
              child: CustomPaint(
                painter: _PlayfulCardPainter(colors: widget.adventure.gradientColors),
              ),
            ),

            // Top Left Category Tag
            Positioned(
              top: 16,
              left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Colors.black.withValues(alpha: 0.3),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(widget.adventure.categoryIcon, size: 14, color: Colors.white),
                    const SizedBox(width: 6),
                    Text(
                      widget.adventure.category,
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

            // Top-Right Stamped Sticker Badge ("96% VIBE MATCH")
            Positioned(
              top: 14,
              right: 14,
              child: ScaleTransition(
                scale: CurvedAnimation(
                  parent: _stickerPopController,
                  curve: Curves.elasticOut,
                ),
                child: Transform.rotate(
                  angle: 0.12, // Slight tilt for sticker look
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFD166),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x60000000),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                      border: Border.all(
                        color: const Color(0xFF0F0E1A),
                        width: 2.0,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.local_fire_department_rounded,
                          size: 15,
                          color: Color(0xFFFF7A59),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          widget.adventure.stickerText,
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF0F0E1A),
                            letterSpacing: -0.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Bottom Glass Info Box
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
                      color: const Color(0xFF0F0E1A).withValues(alpha: 0.5),
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
                          widget.adventure.title,
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
                            _TagBadge(
                              icon: Icons.near_me_rounded,
                              label: widget.adventure.distance,
                            ),
                            _TagBadge(
                              icon: Icons.attach_money_rounded,
                              label: widget.adventure.priceRange,
                            ),
                            _TagBadge(
                              icon: widget.adventure.weatherIcon,
                              label: widget.adventure.weather,
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

class _TagBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? accentColor;

  const _TagBadge({
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

class _PlayfulCardPainter extends CustomPainter {
  final List<Color> colors;

  _PlayfulCardPainter({required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final bgPaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset.zero,
        Offset(size.width, size.height),
        [colors[0], colors[1]],
      );
    canvas.drawRect(rect, bgPaint);

    // Playful waves and doodle star shapes
    final wavePath = Path()
      ..moveTo(0, size.height * 0.45)
      ..quadraticBezierTo(
        size.width * 0.4,
        size.height * 0.3,
        size.width * 0.8,
        size.height * 0.5,
      )
      ..quadraticBezierTo(
        size.width * 0.95,
        size.height * 0.6,
        size.width,
        size.height * 0.45,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(
      wavePath,
      Paint()..color = Colors.black.withValues(alpha: 0.25),
    );
  }

  @override
  bool shouldRepaint(covariant _PlayfulCardPainter oldDelegate) => false;
}
