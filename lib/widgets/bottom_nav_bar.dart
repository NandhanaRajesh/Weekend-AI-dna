import 'dart:ui' as ui;
import 'package:flutter/material.dart';

/// 5-Tab Glassmorphic Bottom Navigation Bar (Discover, Plan, Groups, Memories, Profile).
class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  static const List<NavItemData> navItems = [
    NavItemData(icon: Icons.explore_rounded, label: 'Discover'),
    NavItemData(icon: Icons.map_rounded, label: 'Plan'),
    NavItemData(icon: Icons.groups_rounded, label: 'Groups'),
    NavItemData(icon: Icons.photo_library_rounded, label: 'Memories'),
    NavItemData(icon: Icons.person_rounded, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      height: 70,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(35),
        color: const Color(0xFF161426).withValues(alpha: 0.75),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: const Color(0xFF6C63FF).withValues(alpha: 0.15),
            blurRadius: 20,
            spreadRadius: -2,
          ),
        ],
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1.2,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(35),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(navItems.length, (index) {
              final isSelected = selectedIndex == index;
              final item = navItems[index];

              return InkWell(
                onTap: () => onTabSelected(index),
                borderRadius: BorderRadius.circular(25),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOutCubic,
                  padding: EdgeInsets.symmetric(
                    horizontal: isSelected ? 16 : 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    gradient: isSelected
                        ? const LinearGradient(
                            colors: [
                              Color(0xFFFF7A59),
                              Color(0xFF6C63FF),
                            ],
                          )
                        : null,
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: const Color(0xFFFF7A59).withValues(alpha: 0.4),
                              blurRadius: 12,
                              offset: const Offset(0, 3),
                            ),
                          ]
                        : null,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        item.icon,
                        size: 22,
                        color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.5),
                      ),
                      if (isSelected) ...[
                        const SizedBox(width: 8),
                        Text(
                          item.label,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class NavItemData {
  final IconData icon;
  final String label;

  const NavItemData({required this.icon, required this.label});
}
