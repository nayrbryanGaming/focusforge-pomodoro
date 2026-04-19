import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/settings_service.dart';
import '../../core/services/l10n_service.dart';
import 'about_screen.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsServiceProvider);
    final l10n = ref.watch(l10nServiceProvider.notifier);
    final currentLang = ref.watch(l10nServiceProvider);
    
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.background,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                l10n.translate('settings').toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                  letterSpacing: 2,
                  color: Colors.white,
                ),
              ),
              centerTitle: true,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  _buildSectionCard(
                    context,
                    title: 'TIMER CONFIGURATION',
                    icon: Icons.timer_outlined,
                    children: [
                      _buildDurationItem(
                        'Focus Session', 
                        settings.focusDuration, 
                        'Optimal forge time',
                        (val) => ref.read(settingsServiceProvider.notifier).setFocusDuration(val)
                      ),
                      _buildDurationItem(
                        'Short Break', 
                        settings.shortBreakDuration, 
                        'Quick recharge',
                        (val) => ref.read(settingsServiceProvider.notifier).setShortBreakDuration(val)
                      ),
                      _buildDurationItem(
                        'Long Break', 
                        settings.longBreakDuration, 
                        'Deep restoration',
                        (val) => ref.read(settingsServiceProvider.notifier).setLongBreakDuration(val)
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildSectionCard(
                    context,
                    title: 'PREFERENCES',
                    icon: Icons.tune_rounded,
                    children: [
                      _buildSwitchItem(
                        'Audio Alerts',
                        'Play forge mastery sounds',
                        settings.isSoundEnabled,
                        (val) => ref.read(settingsServiceProvider.notifier).setSoundEnabled(val),
                        AppColors.primary,
                      ),
                      _buildSwitchItem(
                        'Haptic Feedback',
                        'Tactile focus pulses',
                        settings.isHapticEnabled,
                        (val) => ref.read(settingsServiceProvider.notifier).setHapticEnabled(val),
                        AppColors.primary,
                      ),
                      _buildSwitchItem(
                        l10n.translate('power_saving'),
                        'Disable intensive animations',
                        settings.isPowerSavingMode,
                        (val) => ref.read(settingsServiceProvider.notifier).setPowerSavingMode(val),
                        AppColors.accent,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildSectionCard(
                    context,
                    title: 'GLOBALIZATION',
                    icon: Icons.language_rounded,
                    children: [
                      _buildActionItem(
                        'App Language',
                        currentLang == AppLanguage.en ? 'English (US)' : 'Bahasa Indonesia',
                        () => _showLanguagePicker(context, ref),
                        Icons.translate_rounded,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildSectionCard(
                    context,
                    title: 'SYSTEM',
                    icon: Icons.info_outline_rounded,
                    children: [
                      _buildActionItem(
                        l10n.translate('about'),
                        'Version 1.3.1+18 (Masterpiece Build)',
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AboutScreen()),
                        ),
                        Icons.verified_user_outlined,
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms);
  }

  Widget _buildSectionCard(BuildContext context, {required String title, required IconData icon, required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.02),
                border: Border(bottom: BorderSide(color: Colors.white.withValues(alpha: 0.05))),
              ),
              child: Row(
                children: [
                  Icon(icon, size: 18, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Text(
                    title,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildDurationItem(String title, int value, String sub, Function(int) onChanged) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                Text(sub, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                _buildSmallAction(Icons.remove, () => value > 1 ? onChanged(value - 1) : null),
                const SizedBox(width: 12),
                Text('$value', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
                const SizedBox(width: 12),
                _buildSmallAction(Icons.add, () => value < 60 ? onChanged(value + 1) : null),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallAction(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 14, color: Colors.white),
      ),
    );
  }

  Widget _buildSwitchItem(String title, String sub, bool value, Function(bool) onChanged, Color activeColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                Text(sub, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: activeColor,
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem(String title, String sub, VoidCallback onTap, IconData icon) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
      subtitle: Text(sub, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
      trailing: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, size: 18, color: AppColors.primary),
      ),
    );
  }

  void _showLanguagePicker(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(32),
        decoration: const BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('SELECT DIALECT', style: TextStyle(color: AppColors.textSecondary, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 2)),
            const SizedBox(height: 32),
            _buildLangOption(context, ref, 'English (US)', AppLanguage.en),
            const SizedBox(height: 12),
            _buildLangOption(context, ref, 'Bahasa Indonesia', AppLanguage.id),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildLangOption(BuildContext context, WidgetRef ref, String label, AppLanguage lang) {
    final currentLang = ref.watch(l10nServiceProvider);
    final isSelected = currentLang == lang;
    return GestureDetector(
      onTap: () {
        ref.read(l10nServiceProvider.notifier).setLanguage(lang);
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : Colors.white.withValues(alpha: 0.02),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? AppColors.primary.withValues(alpha: 0.3) : Colors.white.withValues(alpha: 0.05)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: TextStyle(color: isSelected ? Colors.white : AppColors.textSecondary, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
            if (isSelected) const Icon(Icons.check_circle_rounded, color: AppColors.primary, size: 20),
          ],
        ),
      ),
    );
  }
}
