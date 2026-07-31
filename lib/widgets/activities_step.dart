import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ActivityCategory {
  final String id;
  final String title;
  final String emoji;
  final IconData icon;
  final Color accentColor;

  const ActivityCategory({
    required this.id,
    required this.title,
    required this.emoji,
    required this.icon,
    required this.accentColor,
  });
}

/// Activities Step Widget (Step 6 of 9) in storybook UI style with multi-select tiles,
/// marker circle scribbles, and live Kai selection count commentary.
class ActivitiesStep extends StatefulWidget {
  final Set<String> selectedActivities;
  final ValueChanged<Set<String>> onActivitiesChanged;
  final ValueChanged<String> onKaiReactionChanged;

  const ActivitiesStep({
    super.key,
    required this.selectedActivities,
    required this.onActivitiesChanged,
    required this.onKaiReactionChanged,
  });

  static const List<ActivityCategory> categories = [
    ActivityCategory(
      id: 'creative',
      title: 'Creative',
      emoji: '🎨',
      icon: Icons.palette_rounded,
      accentColor: Color(0xFF6C63FF),
    ),
    ActivityCategory(
      id: 'adventure',
      title: 'Adventure',
      emoji: '🏔️',
      icon: Icons.filter_hdr_rounded,
      accentColor: Color(0xFFFF7A59),
    ),
    ActivityCategory(
      id: 'food',
      title: 'Foodie',
      emoji: '🍜',
      icon: Icons.restaurant_rounded,
      accentColor: Color(0xFFFFB703),
    ),
    ActivityCategory(
      id: 'music',
      title: 'Live Music',
      emoji: '🎸',
      icon: Icons.music_note_rounded,
      accentColor: Color(0xFF8B5CF6),
    ),
    ActivityCategory(
      id: 'chill',
      title: 'Chill',
      emoji: '🌿',
      icon: Icons.park_rounded,
      accentColor: Color(0xFF2DD4BF),
    ),
    ActivityCategory(
      id: 'games',
      title: 'Games',
      emoji: '🎮',
      icon: Icons.sports_esports_rounded,
      accentColor: Color(0xFFFF5252),
    ),
  ];

  @override
  State<ActivitiesStep> createState() => _ActivitiesStepState();
}

class _ActivitiesStepState extends State<ActivitiesStep> {
  late Set<String> _selected;

  @override
  void initState() {
    super.initState();
    _selected = Set.from(widget.selectedActivities);
  }

  void _toggleCategory(String id) {
    HapticFeedback.lightImpact();
    setState(() {
      if (_selected.contains(id)) {
        if (_selected.length > 1) {
          _selected.remove(id);
        }
      } else {
        _selected.add(id);
      }
    });

    widget.onActivitiesChanged(_selected);

    // Live Kai reaction copy bank based on selection count
    String reaction;
    final count = _selected.length;
    if (count <= 1) {
      reaction = "Pick your flavors. I already know you're gonna pick more than three, you always do 🎨";
    } else if (count <= 3) {
      reaction = "Nice picks! But I bet you'll add more... 👀";
    } else {
      reaction = "Called it! $count already. You're a lot, and I love it 🥳";
    }
    widget.onKaiReactionChanged(reaction);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Select Activities (Multi-Pick):',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white.withValues(alpha: 0.12),
                ),
                child: Text(
                  '${_selected.length} Selected',
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2DD4BF),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // 2-Column Storybook Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.25,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
            ),
            itemCount: ActivitiesStep.categories.length,
            itemBuilder: (context, index) {
              final item = ActivitiesStep.categories[index];
              final isSelected = _selected.contains(item.id);

              return GestureDetector(
                onTap: () => _toggleCategory(item.id),
                child: _ActivityTileCard(
                  category: item,
                  isSelected: isSelected,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ActivityTileCard extends StatelessWidget {
  final ActivityCategory category;
  final bool isSelected;

  const _ActivityTileCard({
    required this.category,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: isSelected
            ? category.accentColor.withValues(alpha: 0.3)
            : Colors.white.withValues(alpha: 0.08),
        border: Border.all(
          color: isSelected ? const Color(0xFFFF7A59) : Colors.white.withValues(alpha: 0.2),
          width: isSelected ? 2.5 : 1.2,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: const Color(0xFFFF7A59).withValues(alpha: 0.4),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(category.emoji, style: const TextStyle(fontSize: 30)),
                const SizedBox(height: 6),
                Text(
                  category.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          if (isSelected)
            Positioned(
              top: 4,
              right: 4,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFFF7A59),
                ),
                child: const Icon(Icons.check_rounded, size: 14, color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}
