import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/achievement_service.dart';
import '../../core/services/confetti_service.dart';
import 'package:animate_do/animate_do.dart';
import 'dart:ui';

class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final achievementsAsync = ref.watch(achievementsStreamProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Achievement Forge'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Background Glow
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 70, sigmaY: 70),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),
          
          achievementsAsync.when(
            data: (achievements) => GridView.builder(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.8,
              ),
              itemCount: achievements.length,
              itemBuilder: (context, index) {
                final achievement = achievements[index];
                return FadeInUp(
                  delay: Duration(milliseconds: index * 50),
                  child: _AchievementCard(achievement: achievement),
                );
              },
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => const Center(child: Text('Error loading achievements', style: TextStyle(color: Colors.white))),
          ),
        ],
      ),
    );
  }
}

class _AchievementCard extends ConsumerWidget {
  final AchievementModel achievement;

  const _AchievementCard({required this.achievement});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isUnlocked = achievement.isUnlocked;

    return GestureDetector(
      onTap: () {
        if (isUnlocked) {
          HapticFeedback.mediumImpact();
          ref.read(confettiServiceProvider).play();
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          boxShadow: isUnlocked ? [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.15),
              blurRadius: 20,
              spreadRadius: 2,
              offset: const Offset(0, 10),
            )
          ] : [],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              decoration: BoxDecoration(
                color: isUnlocked 
                    ? AppColors.surface.withValues(alpha: 0.9) 
                    : AppColors.surface.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: isUnlocked 
                      ? AppColors.primary.withValues(alpha: 0.4) 
                      : Colors.white.withValues(alpha: 0.05),
                  width: 1.5,
                ),
                gradient: isUnlocked ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary.withValues(alpha: 0.1),
                    Colors.transparent,
                  ],
                ) : null,
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon with premium pulse
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        if (isUnlocked)
                          Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                          ).animate(onPlay: (c) => c.repeat()).scale(
                            duration: const Duration(seconds: 3),
                            begin: const Offset(0.8, 0.8),
                            end: const Offset(1.6, 1.6),
                          ).fadeOut(),
                        
                        // Main Badge Icon
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isUnlocked 
                                ? AppColors.primary.withValues(alpha: 0.1)
                                : Colors.white.withValues(alpha: 0.03),
                          ),
                          child: Text(
                            achievement.icon,
                            style: TextStyle(
                              fontSize: 48,
                              color: isUnlocked ? null : Colors.white.withValues(alpha: 0.05),
                              shadows: isUnlocked ? [
                                Shadow(
                                  color: AppColors.primary.withValues(alpha: 0.5),
                                  blurRadius: 10,
                                )
                              ] : [],
                            ),
                          ),
                        ),
                        
                        if (!isUnlocked)
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Icon(Icons.lock_rounded, size: 18, color: Colors.white.withValues(alpha: 0.15)),
                          ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Text(
                      achievement.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.black,
                        fontSize: 15,
                        color: isUnlocked ? Colors.white : Colors.white.withValues(alpha: 0.2),
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      achievement.description,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        height: 1.4,
                        fontWeight: FontWeight.w500,
                        color: isUnlocked ? AppColors.textSecondary : Colors.white.withValues(alpha: 0.1),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Progress Bar
                    _buildProgressBar(achievement.progress, achievement.targetValue, isUnlocked),
                  ],
                ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar(double current, double target, bool isUnlocked) {
    double percent = (current / target).clamp(0.0, 1.0);
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percent,
            backgroundColor: Colors.white.withValues(alpha: 0.05),
            valueColor: AlwaysStoppedAnimation<Color>(
              AppColors.primary.withValues(alpha: isUnlocked ? 0.6 : 0.2),
            ),
            minHeight: 4,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${(percent * 100).toInt()}%',
          style: TextStyle(
            fontSize: 9, 
            color: Colors.white.withValues(alpha: 0.2),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
