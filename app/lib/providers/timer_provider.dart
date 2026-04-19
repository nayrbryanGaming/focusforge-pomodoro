import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/services/notification_service.dart';
import '../core/services/alarm_service.dart';
import '../core/services/stats_service.dart';
import '../core/services/task_service.dart';
import '../core/services/settings_service.dart';
// Removed unused task_model import
import '../core/theme/app_theme.dart';
import '../core/services/review_service.dart';

enum TimerMode { focus, shortBreak, longBreak }

class TimerState {
  final int remainingSeconds;
  final bool isRunning;
  final TimerMode mode;
  final int pomodoroCount;
  final String? activeTaskId;

  TimerState({
    required this.remainingSeconds,
    required this.isRunning,
    required this.mode,
    required this.pomodoroCount,
    this.activeTaskId,
  });

  TimerState copyWith({
    int? remainingSeconds,
    bool? isRunning,
    TimerMode? mode,
    int? pomodoroCount,
    String? activeTaskId,
    bool clearActiveTask = false,
  }) {
    return TimerState(
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      isRunning: isRunning ?? this.isRunning,
      mode: mode ?? this.mode,
      pomodoroCount: pomodoroCount ?? this.pomodoroCount,
      activeTaskId: clearActiveTask ? null : (activeTaskId ?? this.activeTaskId),
    );
  }
}

class TimerNotifier extends Notifier<TimerState> {
  Timer? _timer;
  DateTime? _endTime;

  int get _focusDuration {
    try {
      return ref.read(settingsServiceProvider).focusDuration * 60;
    } catch (_) {
      return 25 * 60;
    }
  }

  int get _shortBreakDuration {
    try {
      return ref.read(settingsServiceProvider).shortBreakDuration * 60;
    } catch (_) {
      return 5 * 60;
    }
  }

  int get _longBreakDuration {
    try {
      return ref.read(settingsServiceProvider).longBreakDuration * 60;
    } catch (_) {
      return 15 * 60;
    }
  }

  int get _sessionsUntilLong {
    try {
      return ref.read(settingsServiceProvider).sessionsBeforeLongBreak;
    } catch (_) {
      return 4;
    }
  }

  @override
  TimerState build() {
    return TimerState(
      remainingSeconds: _focusDuration,
      isRunning: false,
      mode: TimerMode.focus,
      pomodoroCount: 0,
    );
  }

  void toggleTimer() {
    final ns = ref.read(notificationServiceProvider);

    if (state.isRunning) {
      _stopTimer();
      ns.cancelAll();
    } else {
      _startTimer();
      
      // Schedule background notification
      final isFocus = state.mode == TimerMode.focus;
      final title = isFocus ? '🔥 Focus Complete!' : '⚡ Break Over!';
      final body = isFocus
          ? 'Outstanding work! Time for a well-deserved break.'
          : 'Recharged! Back to the forge, champion.';
      
      ns.scheduleNotification(
        100, 
        title, 
        body, 
        _endTime!,
      );
    }
  }

  void _startTimer() {
    _endTime = DateTime.now().add(Duration(seconds: state.remainingSeconds));
    state = state.copyWith(isRunning: true);
    
    _timer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      _tick();
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _endTime = null;
    state = state.copyWith(isRunning: false);
  }

  void syncOnResume() {
    if (!state.isRunning || _endTime == null) return;

    final now = DateTime.now();
    final diff = _endTime!.difference(now).inSeconds;

    if (diff <= 0) {
      state = state.copyWith(remainingSeconds: 0);
      _handleTimerComplete();
    } else {
      state = state.copyWith(remainingSeconds: diff);
    }
  }

  void _tick() {
    if (_endTime == null) return;
    
    final now = DateTime.now();
    final diff = _endTime!.difference(now).inSeconds;
    
    if (diff <= 0) {
      state = state.copyWith(remainingSeconds: 0);
      _handleTimerComplete();
    } else {
      if (state.remainingSeconds != diff) {
        state = state.copyWith(remainingSeconds: diff);
      }
    }
  }

  void resetTimer() {
    _stopTimer();
    ref.read(notificationServiceProvider).cancelAll();
    state = state.copyWith(isRunning: false, remainingSeconds: _durationForMode(state.mode));
  }

  void switchMode(TimerMode newMode) {
    _stopTimer();
    ref.read(notificationServiceProvider).cancelAll();
    state = state.copyWith(
      isRunning: false,
      mode: newMode,
      remainingSeconds: _durationForMode(newMode),
    );
    _syncTheme(newMode);
  }

  void setActiveTask(String? taskId) {
    state = state.copyWith(activeTaskId: taskId, clearActiveTask: taskId == null);
  }

  void skipSession() {
    _stopTimer();
    ref.read(notificationServiceProvider).cancelAll();
    if (state.mode == TimerMode.focus) {
      final newCount = state.pomodoroCount + 1;
      final nextMode = (newCount % _sessionsUntilLong == 0)
          ? TimerMode.longBreak
          : TimerMode.shortBreak;
      state = state.copyWith(
        isRunning: false,
        pomodoroCount: newCount,
        mode: nextMode,
        remainingSeconds: _durationForMode(nextMode),
      );
      _syncTheme(nextMode);
    } else {
      state = state.copyWith(
        isRunning: false,
        mode: TimerMode.focus,
        remainingSeconds: _focusDuration,
      );
      _syncTheme(TimerMode.focus);
    }
  }

  int _durationForMode(TimerMode mode) {
    switch (mode) {
      case TimerMode.focus: return _focusDuration;
      case TimerMode.shortBreak: return _shortBreakDuration;
      case TimerMode.longBreak: return _longBreakDuration;
    }
  }

  void _syncTheme(TimerMode mode) {
    TimerTheme theme;
    switch (mode) {
      case TimerMode.focus: theme = TimerTheme.focus; break;
      case TimerMode.shortBreak: theme = TimerTheme.shortBreak; break;
      case TimerMode.longBreak: theme = TimerTheme.longBreak; break;
    }
    ref.read(timerThemeProvider.notifier).switchTo(theme);
  }

  Future<void> _handleTimerComplete() async {
    _stopTimer();

    final bool isFocus = state.mode == TimerMode.focus;
    final String title = isFocus ? '🔥 Focus Complete!' : '⚡ Break Over!';
    final String body = isFocus
        ? 'Outstanding work! Time for a well-deserved break.'
        : 'Recharged! Back to the forge, champion.';

    HapticFeedback.heavyImpact();
    // Immediate notification as well in case app is foreground
    await ref.read(notificationServiceProvider).showSessionCompleteNotification(title, body);
    await ref.read(alarmServiceProvider).playBell();

    if (isFocus) {
      try {
        await ref.read(statsServiceProvider).updateFocusTime(_focusDuration);
        
        final activeTaskId = state.activeTaskId;
        if (activeTaskId != null) {
          final tasks = await ref.read(tasksStreamProvider.future);
          final task = tasks.firstWhere((t) => t.id == activeTaskId);
          await ref.read(taskServiceProvider).updateTask(
            task.copyWith(completedPomodoros: task.completedPomodoros + 1),
          );
        }
        await ref.read(reviewServiceProvider).incrementSessionAndCheck();
      } catch (e) {
        if (kDebugMode) debugPrint('Error updating stats/task: $e');
      }

      int newCount = state.pomodoroCount + 1;
      TimerMode nextMode = (newCount % _sessionsUntilLong == 0)
          ? TimerMode.longBreak
          : TimerMode.shortBreak;

      state = state.copyWith(
        isRunning: false,
        pomodoroCount: newCount,
        mode: nextMode,
        remainingSeconds: _durationForMode(nextMode),
      );
      _syncTheme(nextMode);
    } else {
      state = state.copyWith(
        isRunning: false,
        mode: TimerMode.focus,
        remainingSeconds: _focusDuration,
      );
      _syncTheme(TimerMode.focus);
    }
  }
}

final timerProvider = NotifierProvider<TimerNotifier, TimerState>(TimerNotifier.new);
