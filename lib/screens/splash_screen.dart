import 'package:flutter/material.dart';
import '../widgets/animated_background.dart';
import '../widgets/floating_icons.dart';
import '../widgets/logo_widget.dart';
import '../widgets/kai_bubble.dart';
import '../widgets/progress_line.dart';
import 'onboarding_screen.dart';

/// Premium Animated Splash Screen orchestrating all timeline staggered animations
/// and smooth page transition to OnboardingScreen.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _timelineController;

  // Staggered Timeline Animations
  late Animation<double> _floatingIconsAnimation;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _titleFadeAnimation;
  late Animation<double> _subtitleFadeAnimation;
  late Animation<double> _kaiBubbleAnimation;
  late Animation<double> _progressLineAnimation;
  late Animation<double> _exitUpwardAnimation;

  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();

    // Total 3.0 seconds timeline duration
    _timelineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );

    // Timeline intervals (Normalized 0.0..1.0 for 3000ms):
    // 0.3s -> 0.100
    // 0.5s -> 0.166
    // 1.0s -> 0.333
    // 1.4s -> 0.466
    // 1.8s -> 0.600
    // 2.5s -> 0.833
    // 3.0s -> 1.000

    _floatingIconsAnimation = CurvedAnimation(
      parent: _timelineController,
      curve: const Interval(0.100, 1.000, curve: Curves.easeOut),
    );

    _logoScaleAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _timelineController,
        curve: const Interval(0.166, 0.400, curve: Curves.easeOutBack),
      ),
    );

    _logoFadeAnimation = CurvedAnimation(
      parent: _timelineController,
      curve: const Interval(0.166, 0.350, curve: Curves.easeIn),
    );

    _titleFadeAnimation = CurvedAnimation(
      parent: _timelineController,
      curve: const Interval(0.333, 0.520, curve: Curves.easeOut),
    );

    _subtitleFadeAnimation = CurvedAnimation(
      parent: _timelineController,
      curve: const Interval(0.466, 0.650, curve: Curves.easeOut),
    );

    _kaiBubbleAnimation = CurvedAnimation(
      parent: _timelineController,
      curve: const Interval(0.600, 0.820, curve: Curves.elasticOut),
    );

    _progressLineAnimation = CurvedAnimation(
      parent: _timelineController,
      curve: const Interval(0.600, 0.833, curve: Curves.easeInOutCubic),
    );

    _exitUpwardAnimation = CurvedAnimation(
      parent: _timelineController,
      curve: const Interval(0.900, 1.000, curve: Curves.easeInOut),
    );

    _timelineController.addStatusListener((status) {
      if (status == AnimationStatus.completed && !_isNavigating) {
        _navigateToOnboarding();
      }
    });

    // Kick off animation sequence
    _timelineController.forward();
  }

  void _navigateToOnboarding() {
    _isNavigating = true;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 900),
        reverseTransitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (context, animation, secondaryAnimation) {
          return const OnboardingScreen();
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Smooth upward floating transition combined with cross-fade
          final slideUp = Tween<Offset>(
            begin: const Offset(0.0, 0.06),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            ),
          );

          final fade = CurvedAnimation(
            parent: animation,
            curve: Curves.easeIn,
          );

          return SlideTransition(
            position: slideUp,
            child: FadeTransition(
              opacity: fade,
              child: child,
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _timelineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _timelineController,
        builder: (context, child) {
          final upwardTranslation = -30.0 * _exitUpwardAnimation.value;

          return Stack(
            fit: StackFit.expand,
            children: [
              // 0.0s: Full-Screen Animated Mesh Background
              const AnimatedBackground(),

              // 0.3s: Floating Travel/AI Depth Icons
              FloatingIcons(entranceAnimation: _floatingIconsAnimation),

              // Main Center Content Column (Logo, Title, Subtitle, Progress, Speech Bubble)
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Column(
                    children: [
                      const Spacer(flex: 2),

                      // Center Logo & Typography with slight upward movement on exit transition
                      Transform.translate(
                        offset: Offset(0, upwardTranslation),
                        child: LogoWidget(
                          logoScaleAnimation: _logoScaleAnimation,
                          logoFadeAnimation: _logoFadeAnimation,
                          titleFadeAnimation: _titleFadeAnimation,
                          subtitleFadeAnimation: _subtitleFadeAnimation,
                        ),
                      ),

                      const SizedBox(height: 36),

                      // 1.8s - 2.5s: Glowing Progress Line
                      ProgressLine(progressAnimation: _progressLineAnimation),

                      const Spacer(flex: 2),

                      // 1.8s: Kai AI Speech Bubble
                      KaiBubble(
                        text: "Let's make this weekend unforgettable.",
                        entranceAnimation: _kaiBubbleAnimation,
                      ),

                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
