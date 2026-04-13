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
      appBar: AppBar(
        title: Text(l10n.translate('settings')),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          _buildSectionHeader('TIMER DURATIONS (MIN)'),
          _buildDurationTile(
            'Focus Session', 
            settings.focusDuration, 
            (val) => ref.read(settingsServiceProvider.notifier).setFocusDuration(val)
          ),
          _buildDurationTile(
            'Short Break', 
            settings.shortBreakDuration, 
            (val) => ref.read(settingsServiceProvider.notifier).setShortBreakDuration(val)
          ),
          _buildDurationTile(
            'Long Break', 
            settings.longBreakDuration, 
            (val) => ref.read(settingsServiceProvider.notifier).setLongBreakDuration(val)
          ),
          
          const Divider(height: 48, indent: 24, endIndent: 24, color: Colors.white12),
          
          _buildSectionHeader('LANGUAGE & LOCALE'),
          ListTile(
            title: const Text('App Language', style: TextStyle(color: Colors.white)),
            subtitle: Text(currentLang == AppLanguage.en ? 'English (US)' : 'Bahasa Indonesia', 
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            trailing: const Icon(Icons.language, color: AppColors.primary),
            onTap: () => _showLanguagePicker(context, ref),
          ),

          const Divider(height: 48, indent: 24, endIndent: 24, color: Colors.white12),
          
          _buildSectionHeader('NOTIFICATIONS & HAPTICS'),
          SwitchListTile(
            title: const Text('Audio Alerts', style: TextStyle(color: Colors.white)),
            subtitle: const Text('Play sounds when session ends', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            value: settings.isSoundEnabled,
            onChanged: (val) => ref.read(settingsServiceProvider.notifier).setSoundEnabled(val),
            activeColor: AppColors.primary,
          ),
          SwitchListTile(
            title: const Text('Haptic Engine', style: TextStyle(color: Colors.white)),
            subtitle: const Text('Vibration pulses for deep focus', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            value: settings.isHapticEnabled,
            onChanged: (val) => ref.read(settingsServiceProvider.notifier).setHapticEnabled(val),
            activeColor: AppColors.primary,
          ),
          
          const Divider(height: 48, indent: 24, endIndent: 24, color: Colors.white12),
          
          _buildSectionHeader('PERFORMANCE & UX'),
          SwitchListTile(
            title: Text(l10n.translate('power_saving'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            subtitle: const Text('Disables animations & confetti to save battery', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            value: settings.isPowerSavingMode,
            onChanged: (val) => ref.read(settingsServiceProvider.notifier).setPowerSavingMode(val),
            activeColor: AppColors.accent,
          ),
          
          const Divider(height: 48, indent: 24, endIndent: 24, color: Colors.white12),
          
          _buildSectionHeader('APP INFO'),
          ListTile(
            leading: const Icon(Icons.info_outline, color: AppColors.primary),
            title: Text(l10n.translate('about'), style: const TextStyle(color: Colors.white)),
            subtitle: const Text('Version 5.0.0 (Zen Edition)', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AboutScreen()),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ).animate().fadeIn(duration: 400.ms),
    );
  }

  void _showLanguagePicker(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Select Language', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 24),
            _buildLangOption(context, ref, 'English', AppLanguage.en),
            _buildLangOption(context, ref, 'Bahasa Indonesia', AppLanguage.id),
          ],
        ),
      ),
    );
  }

  Widget _buildLangOption(BuildContext context, WidgetRef ref, String label, AppLanguage lang) {
    final currentLang = ref.watch(l10nServiceProvider);
    final isSelected = currentLang == lang;
    return ListTile(
      title: Text(label, style: TextStyle(color: isSelected ? AppColors.primary : Colors.white)),
      trailing: isSelected ? const Icon(Icons.check, color: AppColors.primary) : null,
      onTap: () {
        ref.read(l10nServiceProvider.notifier).setLanguage(lang);
        Navigator.pop(context);
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: AppColors.primary,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
        ),
      ),
    );
  }

  Widget _buildDurationTile(String title, int value, Function(int) onChanged) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.remove_circle_outline, color: AppColors.textSecondary, size: 20),
            onPressed: () => value > 1 ? onChanged(value - 1) : null,
          ),
          Container(
            width: 40,
            alignment: Alignment.center,
            child: Text(
              '$value',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: AppColors.primary, size: 20),
            onPressed: () => value < 60 ? onChanged(value + 1) : null,
          ),
        ],
      ),
    );
  }
}
