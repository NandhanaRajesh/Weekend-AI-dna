import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FoodCategory {
  final String id;
  final String title;
  final String emoji;
  final String kaiReaction;
  final Color accentColor;

  const FoodCategory({
    required this.id,
    required this.title,
    required this.emoji,
    required this.kaiReaction,
    required this.accentColor,
  });
}

/// Food Step Widget (Step 7 of 9) in storybook UI style with food category vignette tiles,
/// dietary preference chips, marker circle scribbles, and Kai dramatic starving commentary.
class FoodStep extends StatefulWidget {
  final String selectedFoodId;
  final String selectedDietary;
  final ValueChanged<String> onFoodChanged;
  final ValueChanged<String> onDietaryChanged;
  final ValueChanged<String> onKaiReactionChanged;

  const FoodStep({
    super.key,
    required this.selectedFoodId,
    required this.selectedDietary,
    required this.onFoodChanged,
    required this.onDietaryChanged,
    required this.onKaiReactionChanged,
  });

  static const List<FoodCategory> categories = [
    FoodCategory(
      id: 'street',
      title: 'Street Food',
      emoji: '🌮',
      kaiReaction: 'Street food! Tacos & midnight cravings unlocked 🌮🔥',
      accentColor: Color(0xFFFF7A59),
    ),
    FoodCategory(
      id: 'fine',
      title: 'Fine Dining',
      emoji: '🍷',
      kaiReaction: 'Ooh fancy candles! I\'ll put on my virtual bowtie 🤵',
      accentColor: Color(0xFF8B5CF6),
    ),
    FoodCategory(
      id: 'cafe',
      title: 'Café Hopping',
      emoji: '☕',
      kaiReaction: 'Coffee & croissants! Prepare for caffeine vibes ☕🥐',
      accentColor: Color(0xFFFFB703),
    ),
    FoodCategory(
      id: 'picnic',
      title: 'Picnic',
      emoji: '🧺',
      kaiReaction: 'Picnic basket under the trees! I\'ll guard the sandwiches 🧺',
      accentColor: Color(0xFF2DD4BF),
    ),
    FoodCategory(
      id: 'local',
      title: 'Local Cuisine',
      emoji: '🥙',
      kaiReaction: 'Local hidden eats! The best flavor secrets 🥙',
      accentColor: Color(0xFF6C63FF),
    ),
    FoodCategory(
      id: 'surprise',
      title: 'Surprise Me',
      emoji: '🥟',
      kaiReaction: 'Surprise eats! Kai\'s food wheel of fortune 🥟🎲',
      accentColor: Color(0xFFFF5252),
    ),
  ];

  static const List<String> dietaryOptions = [
    'No Preference 😋',
    'Veg 🥦',
    'Non-Veg 🍗',
    'Vegan 🥑',
  ];

  @override
  State<FoodStep> createState() => _FoodStepState();
}

class _FoodStepState extends State<FoodStep> {
  late String _selectedId;
  late String _selectedDiet;

  @override
  void initState() {
    super.initState();
    _selectedId = widget.selectedFoodId;
    _selectedDiet = widget.selectedDietary;
  }

  void _selectFood(FoodCategory item) {
    HapticFeedback.lightImpact();
    setState(() {
      _selectedId = item.id;
    });
    widget.onFoodChanged(item.id);
    widget.onKaiReactionChanged(item.kaiReaction);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Food Category:',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 10),

          // 2-Column Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.25,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
            ),
            itemCount: FoodStep.categories.length,
            itemBuilder: (context, index) {
              final item = FoodStep.categories[index];
              final isSelected = _selectedId == item.id;

              return GestureDetector(
                onTap: () => _selectFood(item),
                child: _FoodTileCard(
                  category: item,
                  isSelected: isSelected,
                ),
              );
            },
          ),

          const SizedBox(height: 20),

          const Text(
            'Dietary Preferences:',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 10),

          // Dietary Chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: FoodStep.dietaryOptions.map((diet) {
              final isSel = _selectedDiet == diet;
              return GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  setState(() => _selectedDiet = diet);
                  widget.onDietaryChanged(diet);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: isSel
                        ? const Color(0xFFFF7A59).withValues(alpha: 0.3)
                        : Colors.white.withValues(alpha: 0.08),
                    border: Border.all(
                      color: isSel ? const Color(0xFFFF7A59) : Colors.white.withValues(alpha: 0.18),
                      width: isSel ? 2 : 1,
                    ),
                  ),
                  child: Text(
                    diet,
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: isSel ? FontWeight.w800 : FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _FoodTileCard extends StatelessWidget {
  final FoodCategory category;
  final bool isSelected;

  const _FoodTileCard({
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
