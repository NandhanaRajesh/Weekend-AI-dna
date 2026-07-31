import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TransportOption {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final String kaiReaction;
  final Color accentColor;

  const TransportOption({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.kaiReaction,
    required this.accentColor,
  });
}

/// Transport Step Widget (Step 5 of 9) in storybook UI style with hand-painted card vignettes,
/// marker circle scribbles, star progress indicators, and Kai pleading commentary.
class TransportStep extends StatefulWidget {
  final String selectedTransport;
  final ValueChanged<String> onTransportChanged;
  final ValueChanged<String> onKaiReactionChanged;

  const TransportStep({
    super.key,
    required this.selectedTransport,
    required this.onTransportChanged,
    required this.onKaiReactionChanged,
  });

  static const List<TransportOption> options = [
    TransportOption(
      id: 'car',
      title: 'Personal Car',
      subtitle: 'Fast, cozy & private AC',
      icon: Icons.directions_car_rounded,
      kaiReaction: 'YES! My little legs thank you profusely 🚗💨',
      accentColor: Color(0xFFFF7A59),
    ),
    TransportOption(
      id: 'bike',
      title: 'Bicycle / E-Bike',
      subtitle: 'Scenic breeze & trail rides',
      icon: Icons.pedal_bike_rounded,
      kaiReaction: 'A bike?! I\'ll hold onto your helmet for dear life 🚲',
      accentColor: Color(0xFF2DD4BF),
    ),
    TransportOption(
      id: 'transit',
      title: 'Public Transit',
      subtitle: 'Metro, bus & local trains',
      icon: Icons.directions_bus_rounded,
      kaiReaction: 'Bus ride! I call dibs on the window seat 🚌',
      accentColor: Color(0xFF6C63FF),
    ),
    TransportOption(
      id: 'walk',
      title: 'Walking Quest',
      subtitle: 'Footpath discovery',
      icon: Icons.directions_walk_rounded,
      kaiReaction: 'Walking?! Prepare to carry me after 500 meters 🚶‍♂️',
      accentColor: Color(0xFFFFB703),
    ),
  ];

  @override
  State<TransportStep> createState() => _TransportStepState();
}

class _TransportStepState extends State<TransportStep> {
  late String _selectedId;

  @override
  void initState() {
    super.initState();
    _selectedId = widget.selectedTransport;
  }

  void _selectTransport(TransportOption option) {
    HapticFeedback.lightImpact();
    setState(() {
      _selectedId = option.id;
    });
    widget.onTransportChanged(option.id);
    widget.onKaiReactionChanged(option.kaiReaction);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 4 Storybook Hand-Painted Option Cards Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.15,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
            ),
            itemCount: TransportStep.options.length,
            itemBuilder: (context, index) {
              final item = TransportStep.options[index];
              final isSelected = _selectedId == item.id;

              return GestureDetector(
                onTap: () => _selectTransport(item),
                child: _StorybookTransportCard(
                  option: item,
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

class _StorybookTransportCard extends StatelessWidget {
  final TransportOption option;
  final bool isSelected;

  const _StorybookTransportCard({
    required this.option,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: isSelected
            ? option.accentColor.withValues(alpha: 0.3)
            : Colors.white.withValues(alpha: 0.08),
        border: Border.all(
          color: isSelected ? const Color(0xFFFF7A59) : Colors.white.withValues(alpha: 0.2),
          width: isSelected ? 2.8 : 1.2,
        ),
        boxShadow: isSelected
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
          // Storybook Hand-Drawn Marker Circle Scribble Effect on Selected Card
          if (isSelected)
            Positioned.fill(
              child: CustomPaint(
                painter: _MarkerScribblePainter(color: const Color(0xFFFF7A59)),
              ),
            ),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: option.accentColor.withValues(alpha: 0.2),
                  ),
                  child: Icon(
                    option.icon,
                    size: 32,
                    color: isSelected ? Colors.white : option.accentColor,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  option.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  option.subtitle,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withValues(alpha: 0.65),
                  ),
                ),
              ],
            ),
          ),

          // Selected Checkmark Sticker
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

/// CustomPainter drawing hand-drawn marker circle scribbles around selected card.
class _MarkerScribblePainter extends CustomPainter {
  final Color color;

  _MarkerScribblePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(2, 2, size.width - 4, size.height - 4);
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(22));

    final paint = Paint()
      ..color = color.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;

    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant _MarkerScribblePainter oldDelegate) => false;
}
