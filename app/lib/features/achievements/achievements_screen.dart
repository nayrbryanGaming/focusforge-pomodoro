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
                color: AppColors.primary.withOpacity(0.1),
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
          ref.read(confettiServiceProvider).play();
        }
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: isUnlocked 
                  ? AppColors.surface.withOpacity(0.8) 
                  : AppColors.surface.withOpacity(0.2),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isUnlocked 
                    ? AppColors.primary.withOpacity(0.5) 
                    : AppColors.surfaceHighlight.withOpacity(0.1),
                width: 1.5,
              ),
              boxShadow: isUnlocked ? [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.1),
                  blurRadius: 20,
                  spreadRadius: 2,
                )
              ] : [],
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon with optional glow
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      if (isUnlocked)
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.25),
                            shape: BoxShape.circle,
                          ),
                        ).animate(onPlay: (c) => c.repeat()).scale(
                          duration: const Duration(seconds: 2),
                          begin: const Offset(1, 1),
                          end: const Offset(1.5, 1.5),
                        ).fadeOut(),
                      Text(
                        achievement.icon,
                        style: TextStyle(
                          fontSize: 44,
                          color: isUnlocked ? null : Colors.white.withOpacity(0.1),
                        ),
                      ),
                      if (!isUnlocked)
                        Icon(Icons.lock, size: 20, color: Colors.white.withOpacity(0.2)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    achievement.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: isUnlocked ? Colors.white : Colors.white.withOpacity(0.3),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    achievement.description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10,
                      color: isUnlocked ? AppColors.textSecondary : Colors.white.withOpacity(0.2),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Progress Bar for locked ones
                  if (!isUnlocked)
                    _buildProgressBar(achievement.progress, achievement.targetValue),
                ],
              ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar(double current, double target) {
    double percent = (current / target).clamp(0.0, 1.0);
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percent,
            backgroundColor: Colors.white.withOpacity(0.05),
            valueColor: AlwaysStoppedAnimation<Color>(
              AppColors.primary.withOpacity(0.35),
            ),
            minHeight: 4,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${(percent * 100).toInt()}%',
          style: TextStyle(
            fontSize: 9, 
            color: Colors.white.withOpacity(0.2),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
