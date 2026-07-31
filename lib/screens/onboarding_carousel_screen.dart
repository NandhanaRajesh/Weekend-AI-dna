import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/animated_background.dart';
import '../widgets/kai_mascot.dart';
import 'auth_screen.dart';

class OnboardingSlide {
  final String title;
  final String description;
  final IconData heroIcon;
  final List<Color> accentColors;

  const OnboardingSlide({
    required this.title,
    required this.description,
    required this.heroIcon,
    required this.accentColors,
  });
}

/// 3-Screen Onboarding Carousel (Exhausting planning -> Kai decides -> Less deciding more living)
class OnboardingCarouselScreen extends StatefulWidget {
  const OnboardingCarouselScreen({super.key});

  static const List<OnboardingSlide> slides = [
    OnboardingSlide(
      title: 'Planning weekends is exhausting.',
      description: 'Between group chats, weather changes, and endless scrolling, half your weekend is gone before it starts.',
      heroIcon: Icons.calendar_month_rounded,
      accentColors: [Color(0xFFFF7A59), Color(0xFFFFB703)],
    ),
    OnboardingSlide(
      title: 'Kai does the deciding for you.',
      description: 'Your AI companion learns your vibe, checks real-time spots, and cooks up ready-to-go plans in seconds.',
      heroIcon: Icons.auto_awesome_rounded,
      accentColors: [Color(0xFF6C63FF), Color(0xFF2DD4BF)],
    ),
    OnboardingSlide(
      title: 'Less deciding. More living.',
      description: 'Spend your Saturday making memories with your favorite people instead of arguing over where to eat.',
      heroIcon: Icons.celebration_rounded,
      accentColors: [Color(0xFF8B5CF6), Color(0xFFFF7A59)],
    ),
  ];

  @override
  State<OnboardingCarouselScreen> createState() => _OnboardingCarouselScreenState();
}

class _OnboardingCarouselScreenState extends State<OnboardingCarouselScreen> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _finishOnboarding() {
    HapticFeedback.mediumImpact();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const AuthScreen()),
    );
  }

  void _nextSlide() {
    if (_currentIndex < OnboardingCarouselScreen.slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
    } else {
      _finishOnboarding();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Mesh
          const AnimatedBackground(),

          SafeArea(
            child: Column(
              children: [
                // Top Header Row (Skip Link)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.auto_awesome_rounded, color: Color(0xFF2DD4BF), size: 22),
                          SizedBox(width: 8),
                          Text(
                            'WeekendAI',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: _finishOnboarding,
                        child: Text(
                          'Skip',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.white.withValues(alpha: 0.7),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Main PageView Slides
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() => _currentIndex = index);
                    },
                    itemCount: OnboardingCarouselScreen.slides.length,
                    itemBuilder: (context, index) {
                      final slide = OnboardingCarouselScreen.slides[index];

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 28),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Hero Vector Scene Container
                            Container(
                              width: 180,
                              height: 180,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: slide.accentColors,
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: slide.accentColors[0].withValues(alpha: 0.4),
                                    blurRadius: 30,
                                    spreadRadius: 4,
                                  ),
                                ],
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Icon(
                                    slide.heroIcon,
                                    size: 76,
                                    color: Colors.white,
                                  ),
                                  if (index == 1)
                                    const Positioned(
                                      right: 14,
                                      top: 14,
                                      child: KaiMascot(size: 48, expression: KaiExpression.excited),
                                    ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 36),

                            // Headline
                            Text(
                              slide.title,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                height: 1.2,
                                letterSpacing: -0.6,
                              ),
                            ),

                            const SizedBox(height: 14),

                            // Supporting Description
                            Text(
                              slide.description,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15,
                                height: 1.45,
                                color: Colors.white.withValues(alpha: 0.78),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // Bottom Controls (3 Progress Dots + Coral Pill Next Button)
                Padding(
                  padding: const EdgeInsets.fromLTRB(28, 10, 28, 28),
                  child: Column(
                    children: [
                      // 3 Progress Dots Indicator
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(OnboardingCarouselScreen.slides.length, (index) {
                          final isSelected = _currentIndex == index;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: isSelected ? 24 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: isSelected
                                  ? const LinearGradient(
                                      colors: [Color(0xFFFF7A59), Color(0xFF2DD4BF)],
                                    )
                                  : null,
                              color: isSelected ? null : Colors.white.withValues(alpha: 0.2),
                            ),
                          );
                        }),
                      ),

                      const SizedBox(height: 20),

                      // Coral Pill Button
                      ElevatedButton(
                        onPressed: _nextSlide,
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
                              colors: [
                                Color(0xFFFF7A59),
                                Color(0xFF8B5CF6),
                              ],
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x60FF7A59),
                                blurRadius: 18,
                                offset: Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _currentIndex == OnboardingCarouselScreen.slides.length - 1 ? 'Get Started 🚀' : 'Next ➔',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
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
