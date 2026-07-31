import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/animated_background.dart';
import '../widgets/kai_mascot.dart';
import '../widgets/kai_bubble.dart';
import 'home_screen.dart';

class DnaPersona {
  final String id;
  final String label;
  final String emoji;
  final Color accentColor;

  const DnaPersona({
    required this.id,
    required this.label,
    required this.emoji,
    required this.accentColor,
  });
}

/// Weekend DNA Quiz Screen with multi-select persona tiles grid.
class WeekendDnaScreen extends StatefulWidget {
  const WeekendDnaScreen({super.key});

  static const List<DnaPersona> personas = [
    DnaPersona(id: 'foodie', label: 'Foodie', emoji: '🍜', accentColor: Color(0xFFFF7A59)),
    DnaPersona(id: 'adventure', label: 'Adventure Seeker', emoji: '🏔️', accentColor: Color(0xFF2DD4BF)),
    DnaPersona(id: 'creative', label: 'Creative Explorer', emoji: '🎨', accentColor: Color(0xFF6C63FF)),
    DnaPersona(id: 'night_owl', label: 'Night Owl', emoji: '🌙', accentColor: Color(0xFF8B5CF6)),
    DnaPersona(id: 'nature', label: 'Nature Lover', emoji: '🌿', accentColor: Color(0xFFFFB703)),
    DnaPersona(id: 'luxury', label: 'Luxury Traveler', emoji: '✨', accentColor: Color(0xFFFF5252)),
  ];

  @override
  State<WeekendDnaScreen> createState() => _WeekendDnaScreenState();
}

class _WeekendDnaScreenState extends State<WeekendDnaScreen> {
  final Set<String> _selectedIds = {'foodie', 'adventure'};

  void _togglePersona(String id) {
    HapticFeedback.lightImpact();
    setState(() {
      if (_selectedIds.contains(id)) {
        if (_selectedIds.length > 1) {
          _selectedIds.remove(id);
        }
      } else {
        _selectedIds.add(id);
      }
    });
  }

  void _buildDna() {
    HapticFeedback.mediumImpact();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Mesh
          const AnimatedBackground(),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Column(
                children: [
                  // Top Kai Header
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      KaiMascot(size: 58, expression: KaiExpression.happy),
                      SizedBox(width: 8),
                      Expanded(
                        child: KaiBubble(
                          text: "Quick quiz — no wrong answers, I already like you 🥳",
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // 2-Column Persona Grid
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 1.3,
                              crossAxisSpacing: 14,
                              mainAxisSpacing: 14,
                            ),
                            itemCount: WeekendDnaScreen.personas.length,
                            itemBuilder: (context, index) {
                              final item = WeekendDnaScreen.personas[index];
                              final isSelected = _selectedIds.contains(item.id);

                              return GestureDetector(
                                onTap: () => _togglePersona(item.id),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 250),
                                  curve: Curves.easeOutCubic,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(22),
                                    color: isSelected
                                        ? item.accentColor.withValues(alpha: 0.3)
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
                                            Text(item.emoji, style: const TextStyle(fontSize: 32)),
                                            const SizedBox(height: 6),
                                            Text(
                                              item.label,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 13.5,
                                                fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (isSelected)
                                        Positioned(
                                          top: 8,
                                          right: 8,
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
                                ),
                              );
                            },
                          ),

                          const SizedBox(height: 16),

                          // Helper Text
                          Text(
                            'Pick as many as feel true (you can change these later)',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: Colors.white.withValues(alpha: 0.65),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Coral Pill Button
                  ElevatedButton(
                    onPressed: _buildDna,
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
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF7A59), Color(0xFF8B5CF6)],
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x60FF7A59),
                            blurRadius: 18,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          'Build my DNA ➔',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
