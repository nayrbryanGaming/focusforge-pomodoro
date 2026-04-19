import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background Aesthetic
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.1),
              ),
            ),
          ),
          
          CustomScrollView(
            slivers: [
              const SliverAppBar(
                expandedHeight: 0,
                pinned: true,
                backgroundColor: Colors.transparent,
                title: Text('MASTERPIECE SPECS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2)),
                centerTitle: true,
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                  child: Column(
                    children: [
                      Center(
                        child: Hero(
                          tag: 'logo',
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [AppColors.primary, AppColors.accent],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(32),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(alpha: 0.4),
                                  blurRadius: 40,
                                  offset: const Offset(0, 20),
                                )
                              ],
                            ),
                            child: const Center(
                              child: Icon(Icons.bolt_rounded, size: 64, color: Colors.white),
                            ),
                          ),
                        ).animate().scale(duration: 800.ms, curve: Curves.backOut),
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        'FocusForge',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: -1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
                        ),
                        child: const Text(
                          'VERSION 1.3.1+18',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                      const SizedBox(height: 60),
                      
                      _buildMasterpieceCard(
                        title: 'THE PROTOCOL',
                        content: 'FocusForge is a clinical-grade productivity environment designed to transmute digital distraction into unstoppable deep focus.',
                        icon: Icons.auto_awesome_mosaic_rounded,
                      ).animate().fadeIn(delay: 200.ms).moveY(begin: 20, end: 0),
                      
                      const SizedBox(height: 20),
                      
                      _buildMasterpieceCard(
                        title: 'CORE ARCHITECTURE',
                        content: 'Built on the Flutter 3.x stack with Riverpod state management and a clinical Clean Architecture foundation.',
                        icon: Icons.Layers_rounded,
                      ).animate().fadeIn(delay: 400.ms).moveY(begin: 20, end: 0),
                      
                      const SizedBox(height: 20),
                      
                      _buildMasterpieceCard(
                        title: 'DATA SOVEREIGNTY',
                        content: 'Your focus data is yours. We implement high-encryption Firestore security and strict data minimization principles.',
                        icon: Icons.security_rounded,
                      ).animate().fadeIn(delay: 600.ms).moveY(begin: 20, end: 0),
                      
                      const SizedBox(height: 60),
                      
                      const Text(
                        'FORGED BY',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'nayrbryanGaming / Forge Team',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 60),
                      
                      const Opacity(
                        opacity: 0.3,
                        child: Text(
                          '© 2026 FOCUSFORGE PROTOCOL.\nALL RIGHTS RESERVED.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppColors.textSecondary, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMasterpieceCard({required String title, required String content, required IconData icon}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: AppColors.primary),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w900,
                  fontSize: 11,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            content,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
              height: 1.6,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
