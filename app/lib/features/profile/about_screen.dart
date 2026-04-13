import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('About Forge'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          children: [
            Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.accent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    )
                  ],
                ),
                child: const Center(
                  child: Text(
                    'FF',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.black,
                      color: Colors.white,
                    ),
                  ),
                ),
              ).animate().scale(duration: 600.ms, curve: Curves.backOut),
            ),
            const SizedBox(height: 24),
            const Text(
              'FocusForge',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.5,
              ),
            ),
            const Text(
              'v4.0.0 "Elite Edition"',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 48),
            
            _buildAboutCard(
              title: 'The Mission',
              content: 'To empower the next generation of knowledge workers with scientific tools for unstoppable deep focus and habit building.',
            ).animate().fadeIn(delay: 200.ms).moveX(begin: -20, end: 0),
            
            const SizedBox(height: 16),
            
            _buildAboutCard(
              title: 'Built with Modernity',
              content: 'Architected with Flutter 3.x, Firebase, and Clean Architecture principles to ensure reliability and performance.',
            ).animate().fadeIn(delay: 400.ms).moveX(begin: -20, end: 0),
            
            const SizedBox(height: 16),
            
            _buildAboutCard(
              title: 'Privacy & Security',
              content: 'Your data belongs to you. We implement UID-scoped Firestore security and full data portability (JSON export).',
            ).animate().fadeIn(delay: 600.ms).moveX(begin: -20, end: 0),
            
            const SizedBox(height: 48),
            
            const Divider(color: Colors.white12),
            const SizedBox(height: 24),
            
            const Text(
              'DESIGNED & DEVELOPED BY',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'nayrbryanGaming / Forge Team',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 48),
            
            const Text(
              '© 2026 FocusForge. All rights reserved.',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutCard({required String title, required String content}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
