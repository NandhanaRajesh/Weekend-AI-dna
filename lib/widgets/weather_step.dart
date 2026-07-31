import 'dart:async';
import 'package:flutter/material.dart';

/// Weather Step Widget (Step 8 of 9) in storybook UI style featuring Kai's weather postcard narration
/// and auto-advancing after 1.8 seconds.
class WeatherStep extends StatefulWidget {
  final VoidCallback onAutoAdvance;

  const WeatherStep({
    super.key,
    required this.onAutoAdvance,
  });

  @override
  State<WeatherStep> createState() => _WeatherStepState();
}

class _WeatherStepState extends State<WeatherStep> {
  Timer? _autoTimer;

  @override
  void initState() {
    super.initState();
    // Auto-advance after 1.8 seconds so user doesn't need to manually tap
    _autoTimer = Timer(const Duration(milliseconds: 1800), () {
      if (mounted) {
        widget.onAutoAdvance();
      }
    });
  }

  @override
  void dispose() {
    _autoTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Storybook Weather Postcard Card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(26),
              color: Colors.white.withValues(alpha: 0.1),
              border: Border.all(
                color: const Color(0xFF2DD4BF),
                width: 1.8,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2DD4BF).withValues(alpha: 0.3),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                // Weather Sun & Cloud Icon Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.wb_sunny_rounded, size: 48, color: Color(0xFFFFB703)),
                    SizedBox(width: 8),
                    Icon(Icons.cloud_rounded, size: 36, color: Colors.white70),
                  ],
                ),

                const SizedBox(height: 16),

                const Text(
                  '29°C  |  Sunny & Clear',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  '20% rain chance  •  Perfect outdoor weekend weather',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withValues(alpha: 0.75),
                  ),
                ),

                const SizedBox(height: 16),

                // Auto-checking status badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color(0xFF2DD4BF).withValues(alpha: 0.2),
                    border: Border.all(color: const Color(0xFF2DD4BF)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(0xFF2DD4BF),
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Auto-checked by Kai ⚡',
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
      ),
    );
  }
}
