import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Budget Step Widget (Step 3 of 9) with slider, sticker thumb value, presets,
/// and live updating Kai speech commentary.
class BudgetStep extends StatefulWidget {
  final double currentBudget;
  final ValueChanged<double> onBudgetChanged;
  final ValueChanged<String> onKaiReactionChanged;

  const BudgetStep({
    super.key,
    required this.currentBudget,
    required this.onBudgetChanged,
    required this.onKaiReactionChanged,
  });

  @override
  State<BudgetStep> createState() => _BudgetStepState();
}

class _BudgetStepState extends State<BudgetStep> {
  late double _budgetValue;

  @override
  void initState() {
    super.initState();
    _budgetValue = widget.currentBudget;
  }

  void _updateBudget(double val) {
    setState(() {
      _budgetValue = val;
    });
    widget.onBudgetChanged(val);

    // Live Kai reaction copy bank based on numeric slider position
    String reaction;
    if (val < 800) {
      reaction = "Respectably frugal! Free fun & budget hacks incoming 💸";
    } else if (val <= 2500) {
      reaction = "Balanced pick — sensible, but I respect it 😎";
    } else {
      reaction = "Ooh fancy! We yeeting paper this weekend 🥂";
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
          // Slider Container Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(26),
              color: Colors.white.withValues(alpha: 0.08),
              border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
            ),
            child: Column(
              children: [
                // Display Value Badge (Sticker Look)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD166),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF0F0E1A), width: 2),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x60000000),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    '₹${_budgetValue.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}${_budgetValue >= 5000 ? '+' : ''}',
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF0F0E1A),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Thick Custom Slider
                SliderTheme(
                  data: SliderThemeData(
                    trackHeight: 12,
                    activeTrackColor: const Color(0xFFFF7A59),
                    inactiveTrackColor: Colors.white.withValues(alpha: 0.15),
                    thumbColor: const Color(0xFF2DD4BF),
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 16),
                    overlayColor: const Color(0x302DD4BF),
                  ),
                  child: Slider(
                    value: _budgetValue,
                    min: 0,
                    max: 5000,
                    divisions: 100,
                    onChanged: (val) {
                      HapticFeedback.selectionClick();
                      _updateBudget(val);
                    },
                  ),
                ),

                // Tick Marks Row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      _TickText('₹0'),
                      _TickText('₹500'),
                      _TickText('₹1.5k'),
                      _TickText('₹3k'),
                      _TickText('₹5k+'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Quick Presets:',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 10),

          // 3 Preset Pill Buttons
          Row(
            children: [
              Expanded(
                child: _PresetPill(
                  label: 'Budget-Friendly',
                  valueLabel: '₹500',
                  isSelected: _budgetValue <= 800,
                  onTap: () => _updateBudget(500),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _PresetPill(
                  label: 'Balanced',
                  valueLabel: '₹1,500',
                  isSelected: _budgetValue > 800 && _budgetValue <= 2500,
                  onTap: () => _updateBudget(1500),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _PresetPill(
                  label: 'Treat Myself',
                  valueLabel: '₹3,500',
                  isSelected: _budgetValue > 2500,
                  onTap: () => _updateBudget(3500),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TickText extends StatelessWidget {
  final String text;
  const _TickText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: Colors.white.withValues(alpha: 0.6),
      ),
    );
  }
}

class _PresetPill extends StatelessWidget {
  final String label;
  final String valueLabel;
  final bool isSelected;
  final VoidCallback onTap;

  const _PresetPill({
    required this.label,
    required this.valueLabel,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: isSelected
              ? const Color(0xFFFF7A59).withValues(alpha: 0.3)
              : Colors.white.withValues(alpha: 0.08),
          border: Border.all(
            color: isSelected ? const Color(0xFFFF7A59) : Colors.white.withValues(alpha: 0.18),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFFFF7A59).withValues(alpha: 0.35),
                    blurRadius: 12,
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              valueLabel,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: isSelected ? const Color(0xFF2DD4BF) : Colors.white.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
