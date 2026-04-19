import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Primary - The Forge Flame
  static const Color primary = Color(0xFFFF6B35); 
  static const Color primaryElevated = Color(0xFFFF8E64);
  static const Color primaryMuted = Color(0xFFC34A1B);

  // Background - The Deep Forge
  static const Color background = Color(0xFF0B0F1A); 
  static const Color surface = Color(0xFF161C2C);
  static const Color surfaceHighlight = Color(0xFF1F293F);
  static const Color surfaceElevated = Color(0xFF252F48);

  // Accent - The Glowing Ember
  static const Color accent = Color(0xFFFFD166); 
  static const Color accentSoft = Color(0xFFFFF1CC);

  // Semantic
  static const Color success = Color(0xFF10B981);
  static const Color info = Color(0xFF3B82F6);
  static const Color error = Color(0xFFEF4444);
  
  // Text
  static const Color textPrimary = Color(0xFFF1F5F9);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);

  // Decorative
  static final Color glass = Colors.white.withValues(alpha: 0.05);
  static final Color glassBorder = Colors.white.withValues(alpha: 0.1);
}
