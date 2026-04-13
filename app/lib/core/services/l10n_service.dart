import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppLanguage {
  en,
  id,
}

class L10nService extends StateNotifier<AppLanguage> {
  final SharedPreferences _prefs;

  L10nService(this._prefs) : super(_loadInitialLanguage(_prefs));

  static AppLanguage _loadInitialLanguage(SharedPreferences prefs) {
    final lang = prefs.getString('app_language') ?? 'en';
    return lang == 'id' ? AppLanguage.id : AppLanguage.en;
  }

  Future<void> setLanguage(AppLanguage language) async {
    state = language;
    await _prefs.setString('app_language', language.name);
  }

  String translate(String key) {
    if (state == AppLanguage.id) {
      return _indonesian[key] ?? key;
    }
    return _english[key] ?? key;
  }

  static const Map<String, String> _english = {
    'app_name': 'FocusForge',
    'start_focus': 'Forge Focus',
    'timer': 'Timer',
    'tasks': 'Tasks',
    'stats': 'Stats',
    'profile': 'Profile',
    'settings': 'Settings',
    'ambiance': 'Ambiance',
    'power_saving': 'Power Saving',
    'achievements': 'Achievements',
    'about': 'About',
    'delete_account': 'Delete Account',
  };

  static const Map<String, String> _indonesian = {
    'app_name': 'FocusForge',
    'start_focus': 'Mulai Fokus',
    'timer': 'Waktu',
    'tasks': 'Tugas',
    'stats': 'Statistik',
    'profile': 'Profil',
    'settings': 'Pengaturan',
    'ambiance': 'Suasana',
    'power_saving': 'Hemat Daya',
    'achievements': 'Pencapaian',
    'about': 'Tentang',
    'delete_account': 'Hapus Akun',
  };
}

final l10nServiceProvider = StateNotifierProvider<L10nService, AppLanguage>((ref) {
  // SharedPreferences should be initialized in main.dart and overridden
  throw UnimplementedError();
});
