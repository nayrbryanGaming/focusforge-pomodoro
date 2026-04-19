import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/toast_service.dart';

class PremiumScreen extends ConsumerWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background Gradient Logic
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          
          // Animated Glow Blobs
          Positioned(
            top: -100,
            right: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.1),
              ),
            ).animate(onPlay: (c) => c.repeat()).blur(begin: 100, end: 120),
          ),

          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 280,
                pinned: true,
                backgroundColor: AppColors.background,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    alignment: Alignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 40),
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primary.withValues(alpha: 0.12),
                              border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(alpha: 0.2),
                                  blurRadius: 40,
                                  spreadRadius: 10,
                                ),
                              ],
                            ),
                            child: const Icon(Icons.auto_awesome, color: AppColors.primary, size: 48),
                          ).animate().scale(delay: 200.ms, duration: 600.ms, curve: Curves.elasticOut),
                          const SizedBox(height: 24),
                          const Text(
                            'FocusForge Pro',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: -1,
                            ),
                          ).animate().fadeIn(delay: 400.ms).moveY(begin: 20, end: 0),
                          const SizedBox(height: 8),
                          Text(
                            'Forge your ultimate productivity potential',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.6),
                              fontSize: 14,
                            ),
                          ).animate().fadeIn(delay: 600.ms),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 40),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildFeatureItem(
                      icon: Icons.cloud_sync,
                      title: 'Unlimited Cloud Sync',
                      subtitle: 'Access your tasks and stats across all your devices instantly.',
                    ),
                    _buildFeatureItem(
                      icon: Icons.analytics,
                      title: 'Advanced Analytics',
                      subtitle: 'Deep dive into your productivity patterns with weekly & monthly reports.',
                    ),
                    _buildFeatureItem(
                      icon: Icons.music_note,
                      title: 'Exclusive Ambiance Tracks',
                      subtitle: 'Unlock Lo-Fi, Cyberpunk City, and Deep Space focus sounds.',
                    ),
                    _buildFeatureItem(
                      icon: Icons.palette,
                      title: 'Custom Forge Themes',
                      subtitle: 'Personalize your forge with exclusive glassmorphism color palettes.',
                    ),
                    _buildFeatureItem(
                      icon: Icons.notification_important,
                      title: 'Smart Break Reminders',
                      subtitle: 'AI-powered suggestions on when to take breaks based on your energy.',
                    ),
                    
                    const SizedBox(height: 48),
                    
                    // Pricing Cards
                    Column(
                      children: [
                        _buildPricingCard(
                          title: 'ANNUAL PASS',
                          price: r'$29.99 / year',
                          savings: 'SAVE 50%',
                          isPopular: true,
                          onTap: () => _handlePurchase(context, 'Annual'),
                        ),
                        const SizedBox(height: 16),
                        _buildPricingCard(
                          title: 'MONTHLY ACCESS',
                          price: r'$4.99 / month',
                          onTap: () => _handlePurchase(context, 'Monthly'),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 40),
                    
                    Center(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Restore Purchases',
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.4), fontSize: 13),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Recurring billing. Cancel anytime in Store settings.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.2), fontSize: 11),
                    ),
                    const SizedBox(height: 40),
                  ]),
                ),
              ),
            ],
          ),
          
          // Back Button
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 20,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withValues(alpha: 0.3),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem({required IconData icon, required String title, required String subtitle}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 13, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideX(begin: 0.1, end: 0);
  }

  Widget _buildPricingCard({
    required String title,
    required String price,
    String? savings,
    bool isPopular = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isPopular ? AppColors.primary.withValues(alpha: 0.1) : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isPopular ? AppColors.primary.withValues(alpha: 0.5) : Colors.white.withValues(alpha: 0.1),
            width: isPopular ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: isPopular ? AppColors.primary : Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 12,
                          letterSpacing: 1.5,
                        ),
                      ),
                      if (savings != null) ...[
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.success.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            savings,
                            style: const TextStyle(color: AppColors.success, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    price,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.white.withValues(alpha: 0.2), size: 16),
          ],
        ),
      ),
    ).animate().scale(delay: 800.ms, begin: const Offset(0.95, 0.95), end: const Offset(1, 1));
  }

  void _handlePurchase(BuildContext context, String tier) {
    HapticFeedback.heavyImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Processing your $tier subscription...'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
    
    // In production, this would trigger In-App Purchase logic
    Future.delayed(const Duration(seconds: 2), () {
      if (context.mounted) {
        ToastService.showSuccess('Welcome to FocusForge Pro!');
        Navigator.pop(context);
      }
    });
  }
}
