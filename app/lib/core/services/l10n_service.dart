import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppLanguage { en, id }

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
      return _indonesian[key] ?? _english[key] ?? key;
    }
    return _english[key] ?? key;
  }

  static const Map<String, String> _english = {
    // General
    'app_name': 'FocusForge',
    'timer': 'Timer',
    'tasks': 'Tasks',
    'stats': 'Stats',
    'profile': 'Profile',
    'settings': 'Settings',
    'achievements': 'Achievements',
    
    // Timer Screen
    'focus': 'Focus',
    'short_break': 'Short Break',
    'long_break': 'Long Break',
    'start_focus': 'Forge Focus',
    'pause': 'Pause',
    'resume': 'Resume',
    'reset': 'Reset',
    'skip': 'Skip',
    'concentration_mode': 'Concentration Mode',
    'exit_focus': 'Exit Focus',
    'what_are_we_forging': 'What are we forging?',
    'forge_active': 'Forge Active ✓',
    'stay_focused_dialog_title': 'Stay Focused?',
    'stay_focused_dialog_body': 'Allow notifications so we can alert you when your session or break is complete.',
    'allow': 'Allow',
    'not_now': 'Not now',
    
    // Tasks Screen
    'add_task': 'New Task',
    'task_title': 'Task Title',
    'estimated_pomos': 'Estimated Pomodoros',
    'category': 'Category',
    'priority': 'Priority',
    'create': 'Create',
    'cancel': 'Cancel',
    'no_tasks': 'No tasks forged yet.',
    'achievements_active': 'Achievements Forge is active!',
    'cat_all': 'All',
    'cat_work': 'Work',
    'cat_study': 'Study',
    'cat_personal': 'Personal',
    'cat_other': 'Other',
       // Profile/Settings
    'language': 'Language',
    'english': 'English',
    'indonesian': 'Indonesia',
    'power_saving': 'Power Saving',
    'dark_mode': 'Dark Mode',
    'about': 'About',
    'version': 'Version',
    'timer_configuration': 'TIMER CONFIGURATION',
    'preferences': 'PREFERENCES',
    'system': 'SYSTEM',
    'audio_alerts': 'Audio Alerts',
    'audio_alerts_sub': 'Play focus completion sounds',
    'haptic_feedback': 'Haptic Feedback',
    'haptic_feedback_sub': 'Vibrate on session end',
    'power_saving_sub': 'Reduce visual effects',
    'forge_duration': 'Forge Duration (Min)',
    'rest_duration': 'Rest Duration (Min)',
    'deep_rest': 'Deep Rest (Min)',
    'privacy_policy': 'Privacy Policy',
    'terms_of_service': 'Terms of Service',
    'data_usage_policy': 'Data Usage Policy',
    'legal_compliance': 'LEGAL & COMPLIANCE',
    
    // Hardening additions
    'focusing_status': '● FOCUSING',
    'resting_status': '● RESTING',
    'ready_status': 'READY TO FORGE',
    'restart_tooltip': 'Restart',
    'skip_tooltip': 'Skip',
    'short_mode': 'Short',
    'long_mode': 'Long',
    'assign_task': 'Assign Focus Task',
    'clear': 'Clear',
    'task_session_hint': 'Your session will track progress for this task.',
    'no_tasks_picker': 'No tasks yet. Create one in the Tasks tab!',
    'load_error': 'Could not load data. Please restart the app.',
    'wipe_data': 'Wipe Local Data',
    'purge_confirm_title': 'PURGE DATA?',
    'purge_confirm_body': 'This action is IRREVERSIBLE. All focus history, points, and tasks will be permanently wiped from this device.',
    'purge_confirm_input': 'Type "DELETE" to confirm:',
    'keep_working': 'Keep Working',
    'purge_button': 'PURGE EVERYTHING',
    'data_purged': 'All data has been purged.',
    'welcome_pro': 'Forge your ultimate productivity potential',
    'master_forger': 'Master Forger',
    'offline_storage': 'Offline Mode • Local Storage',
    'daily_forge_progress': 'DAILY FORGE PROGRESS',
    'account_actions': 'ACCOUNT ACTIONS',
    
    // About Screen
    'about_specs': 'TECHNICAL SPECIFICATIONS',
    'the_protocol': 'THE ARCHITECTURE',
    'the_protocol_desc': 'FocusForge is a high-performance productivity environment designed to eliminate digital distraction and enable deep focus.',
    'core_architecture': 'SYSTEM ARCHITECTURE',
    'core_architecture_desc': 'Built on the Flutter stack with Riverpod state management and a robust Clean Architecture foundation. 100% offline.',
    'data_sovereignty_about': 'DATA PRIVACY',
    'data_sovereignty_about_desc': 'All productivity data is stored exclusively in a local SQLite database on your device. Zero external data transmission.',
    'forged_by': 'FORGED BY',
    
    // Task Details
    'task_details': 'Task Details',
    'total_focus_time': 'Total Focus Time',
    'sessions_completed': 'Sessions Completed',
    'created_on': 'Created On',
    'estimation': 'Estimation',
    'save_modifications': 'SAVE MODIFICATIONS',
    'delete_task_confirm': 'Delete Task?',
    'delete_task_body': 'This will remove the task and all its focus history from the Forge.',
    'session_history': 'Session History',
    'no_sessions_logged': 'No sessions logged yet.',
    
    // Stats Ranks
    'apprentice_forger': 'Apprentice Forger',
    'grandmaster_forger': 'Grandmaster Forge',
    'focus_aspirant': 'Focus Aspirant',
    'mythic_vanguard': 'Mythic Vanguard',
    'rank': 'Rank',

    // Achievements
    'achievement_focus_apprentice_title': 'Focus Apprentice',
    'achievement_focus_apprentice_desc': 'Complete your first focus session to ignite the productivity flame.',
    'achievement_focused_novice_title': 'Focused Novice',
    'achievement_focused_novice_desc': 'Successfully logged your first 100 minutes of deep focus.',
    'achievement_deep_work_master_title': 'Deep Work Master',
    'achievement_deep_work_master_desc': 'Legendary! You have logged over 1000 minutes of deep focus.',
    'achievement_consistency_king_title': 'Consistency King',
    'achievement_consistency_king_desc': 'Maintained a focus streak for 7 days. You are unstoppable.',
    'achievement_task_crusher_title': 'Task Crusher',
    'achievement_task_crusher_desc': 'Successfully crushed 50 productivity tasks in the Forge.',
    'achievement_night_owl_title': 'Night Owl Forger',
    'achievement_night_owl_desc': 'Completed a focus session in the dead of night.',
    'achievement_efficiency_elite_title': 'Efficiency Elite',
    'achievement_efficiency_elite_desc': 'Maximum output achieved in a single day.',
    // Stats screen
    'consistency_heatmap': 'CONSISTENCY HEATMAP',
    'weekly_focus_intensity': 'WEEKLY FOCUS INTENSITY',
    'productivity_metrics': 'PRODUCTIVITY METRICS',
    'forge_points': 'Forge Points',
    'current_streak': 'Current Streak',
    'forge_level': 'Forge Level',
    'days': 'Days',
    'level': 'Level',
    'tasks_done': 'Tasks Done',
  };

  static const Map<String, String> _indonesian = {
    // General
    'app_name': 'FocusForge',
    'timer': 'Waktu',
    'tasks': 'Tugas',
    'stats': 'Statistik',
    'profile': 'Profil',
    'settings': 'Pengaturan',
    'achievements': 'Pencapaian',
    
    // Timer Screen
    'focus': 'Fokus',
    'short_break': 'Istirahat Pendek',
    'long_break': 'Istirahat Panjang',
    'start_focus': 'Mulai Fokus',
    'pause': 'Jeda',
    'resume': 'Lanjut',
    'reset': 'Ulang',
    'skip': 'Lewati',
    'concentration_mode': 'Mode Konsentrasi',
    'exit_focus': 'Keluar Fokus',
    'what_are_we_forging': 'Apa yang akan dikerjakan?',
    'forge_active': 'Fokus Aktif ✓',
    'stay_focused_dialog_title': 'Tetap Fokus?',
    'stay_focused_dialog_body': 'Izinkan notifikasi agar kami dapat memberi tahu saat sesi atau istirahat selesai.',
    'allow': 'Izinkan',
    'not_now': 'Nanti Saja',
    
    // Tasks Screen
    'add_task': 'Tugas Baru',
    'task_title': 'Judul Tugas',
    'estimated_pomos': 'Estimasi Pomodoro',
    'category': 'Kategori',
    'priority': 'Prioritas',
    'create': 'Buat',
    'cancel': 'Batal',
    'no_tasks': 'Belum ada tugas yang dibuat.',
    'achievements_active': 'Penempaan Pencapaian sedang aktif!',
    'cat_all': 'Semua',
    'cat_work': 'Kerja',
    'cat_study': 'Belajar',
    'cat_personal': 'Pribadi',
    'cat_other': 'Lainnya',
    
    // Profile/Settings
    'language': 'Bahasa',
    'english': 'Inggris',
    'indonesian': 'Indonesia',
    'power_saving': 'Hemat Daya',
    'dark_mode': 'Mode Gelap',
    'about': 'Tentang',
    'version': 'Versi',
    'timer_configuration': 'KONFIGURASI WAKTU',
    'preferences': 'PREFERENSI',
    'system': 'SISTEM',
    'audio_alerts': 'Peringatan Suara',
    'audio_alerts_sub': 'Putar suara saat sesi selesai',
    'haptic_feedback': 'Umpan Balik Haptik',
    'haptic_feedback_sub': 'Getar saat sesi berakhir',
    'power_saving_sub': 'Kurangi efek visual',
    'forge_duration': 'Durasi Fokus (Menit)',
    'rest_duration': 'Durasi Istirahat (Menit)',
    'deep_rest': 'Istirahat Dalam (Menit)',
    'privacy_policy': 'Kebijakan Privasi',
    'terms_of_service': 'Ketentuan Layanan',
    'data_usage_policy': 'Kebijakan Penggunaan Data',
    'legal_compliance': 'LEGAL & KEPATUHAN',

    // Hardening additions
    'focusing_status': '● FOKUS',
    'resting_status': '● ISTIRAHAT',
    'ready_status': 'SIAP MEMULAI',
    'restart_tooltip': 'Ulangi',
    'skip_tooltip': 'Lewati',
    'short_mode': 'Pendek',
    'long_mode': 'Panjang',
    'assign_task': 'Pilih Tugas Fokus',
    'clear': 'Hapus',
    'task_session_hint': 'Sesi Anda akan melacak progres untuk tugas ini.',
    'no_tasks_picker': 'Belum ada tugas. Buat di tab Tugas!',
    'load_error': 'Gagal memuat data. Silakan muat ulang aplikasi.',
    'wipe_data': 'Hapus Data Lokal',
    'purge_confirm_title': 'HAPUS DATA?',
    'purge_confirm_body': 'Tindakan ini TIDAK DAPAT DIBATALKAN. Semua riwayat fokus, poin, dan tugas akan dihapus selamanya dari perangkat ini.',
    'purge_confirm_input': 'Ketik "DELETE" untuk konfirmasi:',
    'keep_working': 'Tetap Bekerja',
    'purge_button': 'HAPUS SEMUA',
    'data_purged': 'Semua data telah dihapus.',
    'welcome_pro': 'Tempa potensi produktivitas terbaik Anda',
    'master_forger': 'Master Penempa',
    'offline_storage': 'Mode Offline • Penyimpanan Lokal',
    'daily_forge_progress': 'PROGRES TEMPAAN HARIAN',
    'account_actions': 'AKSI AKUN',

    // About Screen
    'about_specs': 'SPESIFIKASI TEKNIS',
    'the_protocol': 'ARSITEKTUR',
    'the_protocol_desc': 'FocusForge adalah lingkungan produktivitas berperforma tinggi yang dirancang untuk menghilangkan gangguan digital dan memungkinkan fokus mendalam.',
    'core_architecture': 'ARSITEKTUR SISTEM',
    'core_architecture_desc': 'Dibangun di atas stack Flutter dengan manajemen state Riverpod dan fondasi Arsitektur Bersih yang kuat. 100% offline.',
    'data_sovereignty_about': 'PRIVASI DATA',
    'data_sovereignty_about_desc': 'Semua data produktivitas disimpan secara eksklusif dalam database SQLite lokal di perangkat Anda. Tanpa transmisi data eksternal.',
    'forged_by': 'DITEMPA OLEH',

    // Task Details
    'task_details': 'Detail Tugas',
    'total_focus_time': 'Total Waktu Fokus',
    'sessions_completed': 'Sesi Selesai',
    'created_on': 'Dibuat Pada',
    'estimation': 'Estimasi',
    'save_modifications': 'SIMPAN PERUBAHAN',
    'delete_task_confirm': 'Hapus Tugas?',
    'delete_task_body': 'Ini akan menghapus tugas dan semua riwayat fokusnya dari Penempaan.',
    'session_history': 'Riwayat Sesi',
    'no_sessions_logged': 'Riwayat sesi masih kosong.',

    // Stats Ranks
    'apprentice_forger': 'Penempa Pemula',
    'grandmaster_forger': 'Grandmaster Penempa',
    'focus_aspirant': 'Aspiran Fokus',
    'mythic_vanguard': 'Vanguard Mistik',
    'rank': 'Peringkat',

    // Achievements
    'achievement_focus_apprentice_title': 'Magang Fokus',
    'achievement_focus_apprentice_desc': 'Selesaikan sesi fokus pertama Anda untuk menyalakan api produktivitas.',
    'achievement_focused_novice_title': 'Novis Terfokus',
    'achievement_focused_novice_desc': 'Berhasil mencatat 100 menit pertama fokus mendalam.',
    'achievement_deep_work_master_title': 'Master Kerja Mendalam',
    'achievement_deep_work_master_desc': 'Legendaris! Anda telah mencatat lebih dari 1000 menit fokus mendalam.',
    'achievement_consistency_king_title': 'Raja Konsistensi',
    'achievement_consistency_king_desc': 'Mempertahankan rentetan fokus selama 7 hari. Anda tak terhentikan.',
    'achievement_task_crusher_title': 'Penghancur Tugas',
    'achievement_task_crusher_desc': 'Berhasil menyelesaikan 50 tugas produktivitas di Penempaan.',
    'achievement_night_owl_title': 'Penempa Burung Hantu',
    'achievement_night_owl_desc': 'Menyelesaikan sesi fokus di tengah malam.',
    'achievement_efficiency_elite_title': 'Elite Efisiensi',
    'achievement_efficiency_elite_desc': 'Output maksimal dicapai dalam satu hari.',
    // Stats screen
    'consistency_heatmap': 'PETA KONSISTENSI',
    'weekly_focus_intensity': 'INTENSITAS FOKUS MINGGUAN',
    'productivity_metrics': 'METRIK PRODUKTIVITAS',
    'forge_points': 'Poin Tempa',
    'current_streak': 'Rentetan Saat Ini',
    'forge_level': 'Level Tempa',
    'days': 'Hari',
    'level': 'Level',
    'tasks_done': 'Tugas Selesai',
  };
}

final l10nServiceProvider = StateNotifierProvider<L10nService, AppLanguage>((ref) {
  // Should be overridden in main.dart
  throw UnimplementedError();
});
