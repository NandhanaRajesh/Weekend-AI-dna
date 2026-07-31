import 'package:flutter/material.dart';

class HiddenGemItem {
  final String title;
  final String category;
  final String distance;
  final String rating;
  final IconData icon;
  final Color accentColor;

  const HiddenGemItem({
    required this.title,
    required this.category,
    required this.distance,
    required this.rating,
    required this.icon,
    required this.accentColor,
  });
}

/// Horizontal scrollable row labeled "Nearby Hidden Gems" with compact thumbnail cards.
class HiddenGems extends StatelessWidget {
  const HiddenGems({super.key});

  static const List<HiddenGemItem> items = [
    HiddenGemItem(
      title: 'Cozy Bookshop Cafe',
      category: 'Coffee & Books',
      distance: '1.2 km',
      rating: '4.9',
      icon: Icons.menu_book_rounded,
      accentColor: Color(0xFFFF7A59),
    ),
    HiddenGemItem(
      title: 'Secret Waterfall Trail',
      category: 'Outdoor Discovery',
      distance: '6.8 km',
      rating: '4.8',
      icon: Icons.water_drop_rounded,
      accentColor: Color(0xFF2DD4BF),
    ),
    HiddenGemItem(
      title: 'Stargazing Observatory',
      category: 'Night Wonder',
      distance: '9.0 km',
      rating: '4.9',
      icon: Icons.star_rounded,
      accentColor: Color(0xFF8B5CF6),
    ),
    HiddenGemItem(
      title: 'Retro Arcade Lounge',
      category: 'Nightlife & Games',
      distance: '3.1 km',
      rating: '4.7',
      icon: Icons.sports_esports_rounded,
      accentColor: Color(0xFF6C63FF),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Nearby Hidden Gems',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -0.3,
                ),
              ),
              Text(
                'Explore Map',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2DD4BF),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 10),

        // Horizontal List View
        SizedBox(
          height: 135,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final gem = items[index];
              return Container(
                width: 175,
                margin: const EdgeInsets.only(right: 14),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white.withValues(alpha: 0.08),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.16),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: gem.accentColor.withValues(alpha: 0.2),
                          ),
                          child: Icon(
                            gem.icon,
                            size: 18,
                            color: gem.accentColor,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white.withValues(alpha: 0.12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.star_rounded, size: 12, color: Colors.amber),
                              const SizedBox(width: 3),
                              Text(
                                gem.rating,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          gem.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_rounded,
                              size: 12,
                              color: Colors.white.withValues(alpha: 0.6),
                            ),
                            const SizedBox(width: 2),
                            Text(
                              gem.distance,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: Colors.white.withValues(alpha: 0.6),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
