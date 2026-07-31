import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MoodOption {
  final String id;
  final String label;
  final String emoji;
  final String kaiReaction;
  final Color baseColor;
  final double tiltAngle;

  const MoodOption({
    required this.id,
    required this.label,
    required this.emoji,
    required this.kaiReaction,
    required this.baseColor,
    required this.tiltAngle,
  });
}

/// Interactive Mood Tiles grid with staggered rotations, scale bounce, and checkmark stickers.
class MoodTiles extends StatelessWidget {
  final String? selectedId;
  final ValueChanged<MoodOption> onMoodSelected;

  const MoodTiles({
    super.key,
    required this.selectedId,
    required this.onMoodSelected,
  });

  static const List<MoodOption> moods = [
    MoodOption(
      id: 'cozy',
      label: 'Lazy & Cozy',
      emoji: '😴',
      kaiReaction: 'Say less. Couch-adjacent activities incoming 🛌',
      baseColor: Color(0xFF8B5CF6),
      tiltAngle: -0.03,
    ),
    MoodOption(
      id: 'adventurous',
      label: 'Adventurous',
      emoji: '🔥',
      kaiReaction: 'Ooh spicy! Let\'s get your heart rate up 🧗‍♂️',
      baseColor: Color(0xFFFF7A59),
      tiltAngle: 0.03,
    ),
    MoodOption(
      id: 'romantic',
      label: 'Romantic',
      emoji: '💖',
      kaiReaction: 'Love is in the air! Preparing candlelit vibes 🕯️',
      baseColor: Color(0xFFFF5252),
      tiltAngle: -0.02,
    ),
    MoodOption(
      id: 'creative',
      label: 'Curious & Creative',
      emoji: '🎨',
      kaiReaction: 'Unlocking your inner Picasso! 🖌️',
      baseColor: Color(0xFF6C63FF),
      tiltAngle: 0.04,
    ),
    MoodOption(
      id: 'social',
      label: 'Social Butterfly',
      emoji: '🎉',
      kaiReaction: 'Party mode activated! Gathering the squad 🥳',
      baseColor: Color(0xFFFFB703),
      tiltAngle: -0.04,
    ),
    MoodOption(
      id: 'surprise',
      label: 'Surprise Me',
      emoji: '🎲',
      kaiReaction: 'Wildcard! Trusting Kai blindly is a pro move 🎰',
      baseColor: Color(0xFF2DD4BF),
      tiltAngle: 0.02,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.25,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
        ),
        itemCount: moods.length,
        itemBuilder: (context, index) {
          final item = moods[index];
          final isSelected = selectedId == item.id;

          return Transform.rotate(
            angle: item.tiltAngle,
            child: _MoodTileCard(
              option: item,
              isSelected: isSelected,
              onTap: () {
                HapticFeedback.lightImpact();
                onMoodSelected(item);
              },
            ),
          );
        },
      ),
    );
  }
}

class _MoodTileCard extends StatefulWidget {
  final MoodOption option;
  final bool isSelected;
  final VoidCallback onTap;

  const _MoodTileCard({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_MoodTileCard> createState() => _MoodTileCardState();
}

class _MoodTileCardState extends State<_MoodTileCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _bounceController;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      lowerBound: 0.94,
      upperBound: 1.0,
      value: 1.0,
    );
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _bounceController.reverse(),
      onTapUp: (_) {
        _bounceController.forward();
        widget.onTap();
      },
      onTapCancel: () => _bounceController.forward(),
      child: ScaleTransition(
        scale: _bounceController,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            color: widget.isSelected
                ? widget.option.baseColor.withValues(alpha: 0.3)
                : Colors.white.withValues(alpha: 0.1),
            border: Border.all(
              color: widget.isSelected
                  ? const Color(0xFFFF7A59)
                  : Colors.white.withValues(alpha: 0.2),
              width: widget.isSelected ? 2.5 : 1.2,
            ),
            boxShadow: widget.isSelected
                ? [
                    BoxShadow(
                      color: const Color(0xFFFF7A59).withValues(alpha: 0.45),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: Stack(
            children: [
              // Tile Emoji & Label Center
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.option.emoji,
                        style: const TextStyle(fontSize: 34),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.option.label,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: widget.isSelected ? FontWeight.w900 : FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Selected State Checkmark Sticker (Top-Right)
              if (widget.isSelected)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFFF7A59),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x60000000),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      size: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
