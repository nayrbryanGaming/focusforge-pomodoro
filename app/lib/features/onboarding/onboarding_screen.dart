import 'package:flutter/material.dart';
import 'dart:ui';
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
      gradientColors: [Color(0xFFFF6B35), Color(0xFFFFD166)],
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
      gradientColors: [AppColors.accent, Color(0xFFFFA000)],
      bgAccent: AppColors.accent,
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
        duration: const Duration(milliseconds: 600),
        curve: Curves.fastOutSlowIn,
      );
    } else {
      widget.onComplete?.call();
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 800),
          pageBuilder: (_, __, ___) => const PermissionPrimingScreen(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final page = _pages[_currentPage];

    return Scaffold(
      body: Stack(
        children: [
          // Background Mesh
          AnimatedContainer(
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeInOutBack,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: _currentPage == 0 
                    ? const Alignment(-0.8, -0.6) 
                    : (_currentPage == 1 ? const Alignment(0.8, 0.2) : const Alignment(0, 0.8)),
                colors: [
                  page.bgAccent.withValues(alpha: 0.25),
                  const Color(0xFF0F172A),
                ],
                radius: 1.8,
              ),
            ),
          ),
          
          SafeArea(
            child: Column(
              children: [
                // Top Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 60),
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

                // Content
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
                            Container(
                              width: 160,
                              height: 160,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.white.withValues(alpha: 0.1),
                                    Colors.white.withValues(alpha: 0.05),
                                  ],
                                ),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.1),
                                  width: 1.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: p.bgAccent.withValues(alpha: 0.3),
                                    blurRadius: 40,
                                    spreadRadius: -10,
                                  )
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(80),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                  child: Center(
                                    child: Text(
                                      p.emoji,
                                      style: const TextStyle(fontSize: 72),
                                    ),
                                  ),
                                ),
                              ),
                            )
                                .animate()
                                .scale(duration: 800.ms, curve: Curves.backOut)
                                .fadeIn(),

                            const SizedBox(height: 56),

                            ShaderMask(
                              shaderCallback: (bounds) => LinearGradient(
                                colors: p.gradientColors,
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ).createShader(bounds),
                              child: Text(
                                p.title,
                                style: const TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.black,
                                  color: Colors.white,
                                  height: 1.0,
                                  letterSpacing: -1.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            )
                                .animate()
                                .fadeIn(delay: 200.ms)
                                .moveY(begin: 30, end: 0, duration: 600.ms, curve: Curves.easeOutCubic),

                            const SizedBox(height: 24),

                            Text(
                              p.description,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 17,
                                height: 1.6,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            )
                                .animate()
                                .fadeIn(delay: 400.ms)
                                .moveY(begin: 20, end: 0, duration: 500.ms),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // Page Indicator & Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: List.generate(
                          _pages.length,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.elasticOut,
                            margin: const EdgeInsets.only(right: 12),
                            height: 8,
                            width: _currentPage == index ? 32 : 8,
                            decoration: BoxDecoration(
                              gradient: _currentPage == index 
                                  ? LinearGradient(colors: _pages[_currentPage].gradientColors)
                                  : null,
                              color: _currentPage == index ? null : Colors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),

                      GestureDetector(
                        onTap: _advance,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 400),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 18,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: _pages[_currentPage].gradientColors,
                            ),
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: [
                              BoxShadow(
                                color: _pages[_currentPage].bgAccent.withValues(alpha: 0.4),
                                blurRadius: 25,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _currentPage == _pages.length - 1
                                    ? "LET'S FORGE"
                                    : 'NEXT',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 14,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Icon(
                                _currentPage == _pages.length - 1
                                    ? Icons.bolt
                                    : Icons.arrow_forward_ios_rounded,
                                color: Colors.white,
                                size: 16,
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
        ],
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
