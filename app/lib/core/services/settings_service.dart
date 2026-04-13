import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsService extends StateNotifier<SettingsState> {
  final SharedPreferences _prefs;

  SettingsService(this._prefs) : super(SettingsState.fromPrefs(_prefs));

  // SharedPreferences Keys
  static const String _focusDurationKey = 'focus_duration';
  static const String _shortBreakDurationKey = 'short_break_duration';
  static const String _longBreakDurationKey = 'long_break_duration';
  static const String _sessionsBeforeLongBreakKey = 'sessions_before_long_break';
  static const String _isSoundEnabledKey = 'is_sound_enabled';
  static const String _isHapticEnabledKey = 'is_haptic_enabled';
  static const String _isDarkModeKey = 'is_dark_mode';
  static const String _isPowerSavingModeKey = 'is_power_saving_mode';

  // State Updates
  Future<void> setFocusDuration(int minutes) async {
    await _prefs.setInt(_focusDurationKey, minutes);
    state = state.copyWith(focusDuration: minutes);
  }

  Future<void> setShortBreakDuration(int minutes) async {
    await _prefs.setInt(_shortBreakDurationKey, minutes);
    state = state.copyWith(shortBreakDuration: minutes);
  }

  Future<void> setLongBreakDuration(int minutes) async {
    await _prefs.setInt(_longBreakDurationKey, minutes);
    state = state.copyWith(longBreakDuration: minutes);
  }

  Future<void> setSoundEnabled(bool enabled) async {
    await _prefs.setBool(_isSoundEnabledKey, enabled);
    state = state.copyWith(isSoundEnabled: enabled);
  }

  Future<void> setHapticEnabled(bool enabled) async {
    await _prefs.setBool(_isHapticEnabledKey, enabled);
    state = state.copyWith(isHapticEnabled: enabled);
  }

  Future<void> setPowerSavingMode(bool enabled) async {
    await _prefs.setBool(_isPowerSavingModeKey, enabled);
    state = state.copyWith(isPowerSavingMode: enabled);
  }
}

class SettingsState {
  final int focusDuration;
  final int shortBreakDuration;
  final int longBreakDuration;
  final bool isSoundEnabled;
  final bool isHapticEnabled;
  final bool isPowerSavingMode;

  SettingsState({
    required this.focusDuration,
    required this.shortBreakDuration,
    required this.longBreakDuration,
    required this.isSoundEnabled,
    required this.isHapticEnabled,
    required this.isPowerSavingMode,
  });

  factory SettingsState.fromPrefs(SharedPreferences prefs) {
    return SettingsState(
      focusDuration: prefs.getInt('focus_duration') ?? 25,
      shortBreakDuration: prefs.getInt('short_break_duration') ?? 5,
      longBreakDuration: prefs.getInt('long_break_duration') ?? 15,
      isSoundEnabled: prefs.getBool('is_sound_enabled') ?? true,
      isHapticEnabled: prefs.getBool('is_haptic_enabled') ?? true,
      isPowerSavingMode: prefs.getBool('is_power_saving_mode') ?? false,
    );
  }

  SettingsState copyWith({
    int? focusDuration,
    int? shortBreakDuration,
    int? longBreakDuration,
    bool? isSoundEnabled,
    bool? isHapticEnabled,
    bool? isPowerSavingMode,
  }) {
    return SettingsState(
      focusDuration: focusDuration ?? this.focusDuration,
      shortBreakDuration: shortBreakDuration ?? this.shortBreakDuration,
      longBreakDuration: longBreakDuration ?? this.longBreakDuration,
      isSoundEnabled: isSoundEnabled ?? this.isSoundEnabled,
      isHapticEnabled: isHapticEnabled ?? this.isHapticEnabled,
      isPowerSavingMode: isPowerSavingMode ?? this.isPowerSavingMode,
    );
  }
}

final settingsServiceProvider = StateNotifierProvider<SettingsService, SettingsState>((ref) {
  throw UnimplementedError('Initialize with SharedPreferences in main.dart');
});
