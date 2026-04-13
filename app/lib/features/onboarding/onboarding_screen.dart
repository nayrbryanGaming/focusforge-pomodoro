import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import 'permission_priming_screen.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback? onComplete;

  const OnboardingScreen({super.key, this.onComplete});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingData> _pages = [
    _OnboardingData(
      title: 'Forge Deep Focus',
      description:
          'Master your time with scientific Pomodoro intervals designed for sustained concentration and peak output.',
      emoji: '🔥',
      gradientColors: [Color(0xFFFF6B35), Color(0xFFFF8C42)],
      bgAccent: Color(0xFFFF6B35),
    ),
    _OnboardingData(
      title: 'Track Every Task',
      description:
          'Break ambitious goals into focused sessions. Watch your productivity scores rise as you crush task after task.',
      emoji: '✅',
      gradientColors: [Color(0xFF10B981), Color(0xFF34D399)],
      bgAccent: Color(0xFF10B981),
    ),
    _OnboardingData(
      title: 'Level Up Daily',
      description:
          'Earn XP, unlock achievement badges, and visualize your streaks. Productivity has never felt this rewarding.',
      emoji: '🏆',
      gradientColors: [Color(0xFFFFD166), Color(0xFFFFE08A)],
      bgAccent: Color(0xFFFFD166),
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _advance() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      widget.onComplete?.call();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const PermissionPrimingScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final page = _pages[_currentPage];

    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              page.bgAccent.withOpacity(0.15),
              const Color(0xFF0F172A),
              const Color(0xFF0F172A),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Skip button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 60),
                    // Brand mark
                    Row(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [AppColors.primary, Color(0xFFFF8C42)],
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.bolt, size: 16, color: Colors.white),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'FocusForge',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 60,
                      child: TextButton(
                        onPressed: _advance,
                        child: const Text(
                          'Skip',
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // PageView
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (i) => setState(() => _currentPage = i),
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    final p = _pages[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Emoji in decorative circle
                          Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  p.bgAccent.withOpacity(0.2),
                                  p.bgAccent.withOpacity(0.05),
                                ],
                              ),
                              border: Border.all(
                                color: p.bgAccent.withOpacity(0.3),
                                width: 1.5,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                p.emoji,
                                style: const TextStyle(fontSize: 60),
                              ),
                            ),
                          )
                              .animate()
                              .scale(duration: 600.ms, curve: Curves.backOut)
                              .fadeIn(),

                          const SizedBox(height: 48),

                          ShaderMask(
                            shaderCallback: (bounds) => LinearGradient(
                              colors: p.gradientColors,
                            ).createShader(bounds),
                            child: Text(
                              p.title,
                              style: const TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.black,
                                color: Colors.white,
                                height: 1.1,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                              .animate()
                              .fadeIn(delay: 200.ms)
                              .moveY(begin: 20, end: 0, duration: 400.ms),

                          const SizedBox(height: 20),

                          Text(
                            p.description,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 16,
                              height: 1.6,
                            ),
                            textAlign: TextAlign.center,
                          )
                              .animate()
                              .fadeIn(delay: 350.ms)
                              .moveY(begin: 20, end: 0, duration: 400.ms),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Controls
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Page indicators
                    Row(
                      children: List.generate(
                        _pages.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          margin: const EdgeInsets.only(right: 8),
                          height: 6,
                          width: _currentPage == index ? 28 : 6,
                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? _pages[_currentPage].bgAccent
                                : Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ),

                    // Next / Get Started button
                    GestureDetector(
                      onTap: _advance,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: _pages[_currentPage].gradientColors,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: _pages[_currentPage].bgAccent.withOpacity(0.4),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _currentPage == _pages.length - 1
                                  ? 'Start Forging!'
                                  : 'Next',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              _currentPage == _pages.length - 1
                                  ? Icons.bolt
                                  : Icons.arrow_forward_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingData {
  final String title;
  final String description;
  final String emoji;
  final List<Color> gradientColors;
  final Color bgAccent;

  _OnboardingData({
    required this.title,
    required this.description,
    required this.emoji,
    required this.gradientColors,
    required this.bgAccent,
  });
}
