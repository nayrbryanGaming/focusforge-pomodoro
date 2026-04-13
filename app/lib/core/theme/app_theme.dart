import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

enum TimerTheme { focus, shortBreak, longBreak }

class TimerThemeState {
  final TimerTheme timerTheme;
  const TimerThemeState(this.timerTheme);
}

class TimerThemeNotifier extends Notifier<TimerThemeState> {
  @override
  TimerThemeState build() => const TimerThemeState(TimerTheme.focus);

  void switchTo(TimerTheme theme) {
    state = TimerThemeState(theme);
  }
}

final timerThemeProvider = NotifierProvider<TimerThemeNotifier, TimerThemeState>(
  TimerThemeNotifier.new,
);

class AppTheme {
  static ThemeData get darkTheme => _buildTheme(AppColors.primary, AppColors.accent);

  static ThemeData focusTheme => _buildTheme(AppColors.primary, AppColors.accent);
  static ThemeData shortBreakTheme => _buildTheme(AppColors.success, const Color(0xFF20D9BF));
  static ThemeData longBreakTheme => _buildTheme(const Color(0xFF8B5CF6), const Color(0xFFC4B5FD));

  static ThemeData getForMode(TimerTheme mode) {
    switch (mode) {
      case TimerTheme.focus:
        return focusTheme;
      case TimerTheme.shortBreak:
        return shortBreakTheme;
      case TimerTheme.longBreak:
        return longBreakTheme;
    }
  }

  static ThemeData _buildTheme(Color primary, Color secondary) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: primary,
      colorScheme: ColorScheme.dark(
        primary: primary,
        secondary: secondary,
        surface: AppColors.surface,
        error: AppColors.error,
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).copyWith(
        displayLarge: GoogleFonts.outfit(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
        titleLarge: GoogleFonts.outfit(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
      ),
      cardTheme: CardTheme(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceHighlight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primary, width: 2),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: primary,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return primary;
          return Colors.grey;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return primary.withOpacity(0.3);
          return Colors.grey.withOpacity(0.3);
        }),
      ),
    );
  }
}
