import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FriendAvatar {
  final String id;
  final String name;
  final String avatarEmoji;
  final Color ringColor;

  const FriendAvatar({
    required this.id,
    required this.name,
    required this.avatarEmoji,
    required this.ringColor,
  });
}

/// Friends Step Widget (Step 2 of 9) with Just Me vs With Friends toggles & friend avatar bubbles.
class FriendsStep extends StatefulWidget {
  final String selectedMode; // 'solo' or 'friends'
  final ValueChanged<String> onModeChanged;

  const FriendsStep({
    super.key,
    required this.selectedMode,
    required this.onModeChanged,
  });

  static const List<FriendAvatar> friendsList = [
    FriendAvatar(id: 'f1', name: 'Alex', avatarEmoji: '👦', ringColor: Color(0xFFFF7A59)),
    FriendAvatar(id: 'f2', name: 'Maya', avatarEmoji: '👧', ringColor: Color(0xFF2DD4BF)),
    FriendAvatar(id: 'f3', name: 'Jordan', avatarEmoji: '🧒', ringColor: Color(0xFF8B5CF6)),
    FriendAvatar(id: 'f4', name: 'Sam', avatarEmoji: '🧑', ringColor: Color(0xFFFFB703)),
  ];

  @override
  State<FriendsStep> createState() => _FriendsStepState();
}

class _FriendsStepState extends State<FriendsStep> {
  final Set<String> _selectedFriendIds = {'f1', 'f2'};

  void _toggleFriend(String id) {
    HapticFeedback.lightImpact();
    setState(() {
      if (_selectedFriendIds.contains(id)) {
        _selectedFriendIds.remove(id);
      } else {
        _selectedFriendIds.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isFriendsMode = widget.selectedMode == 'friends';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 2 Large Toggle Tiles Side by Side
          Row(
            children: [
              Expanded(
                child: _ToggleTile(
                  title: 'Just Me 🧍',
                  isSelected: widget.selectedMode == 'solo',
                  onTap: () {
                    HapticFeedback.lightImpact();
                    widget.onModeChanged('solo');
                  },
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _ToggleTile(
                  title: 'With Friends 👯',
                  isSelected: isFriendsMode,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    widget.onModeChanged('friends');
                  },
                ),
              ),
            ],
          ),

          if (isFriendsMode) ...[
            const SizedBox(height: 24),

            const Text(
              'Select Friends to Tag:',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 12),

            // Horizontal Friend Avatars Scroll View
            SizedBox(
              height: 95,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  ...FriendsStep.friendsList.map((friend) {
                    final isSel = _selectedFriendIds.contains(friend.id);

                    return GestureDetector(
                      onTap: () => _toggleFriend(friend.id),
                      child: Container(
                        margin: const EdgeInsets.only(right: 16),
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                Container(
                                  width: 56,
                                  height: 56,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white.withValues(alpha: 0.1),
                                    border: Border.all(
                                      color: isSel ? friend.ringColor : Colors.white.withValues(alpha: 0.2),
                                      width: isSel ? 3 : 1.5,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(friend.avatarEmoji, style: const TextStyle(fontSize: 26)),
                                  ),
                                ),
                                if (isSel)
                                  Positioned(
                                    right: 0,
                                    bottom: 0,
                                    child: Container(
                                      padding: const EdgeInsets.all(3),
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xFFFF7A59),
                                      ),
                                      child: const Icon(Icons.check_rounded, size: 12, color: Colors.white),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              friend.name,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: isSel ? FontWeight.w800 : FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),

                  // "+ Invite" Bubble
                  GestureDetector(
                    onTap: () => HapticFeedback.mediumImpact(),
                    child: Column(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.08),
                            border: Border.all(
                              color: const Color(0xFF2DD4BF),
                              width: 1.8,
                            ),
                          ),
                          child: const Center(
                            child: Icon(Icons.add_rounded, color: Color(0xFF2DD4BF), size: 28),
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Invite',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF2DD4BF),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ToggleTile extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _ToggleTile({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        height: 80,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          color: isSelected
              ? const Color(0xFFFF7A59).withValues(alpha: 0.3)
              : Colors.white.withValues(alpha: 0.08),
          border: Border.all(
            color: isSelected ? const Color(0xFFFF7A59) : Colors.white.withValues(alpha: 0.18),
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
        child: Center(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
