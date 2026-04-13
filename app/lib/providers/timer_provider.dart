import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/services/notification_service.dart';
import '../core/services/alarm_service.dart';
import '../core/services/stats_service.dart';
import '../core/services/task_service.dart';
import '../core/services/settings_service.dart';
import '../models/task_model.dart';
import '../core/theme/app_theme.dart';

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
    if (state.isRunning) {
      _timer?.cancel();
      state = state.copyWith(isRunning: false);
    } else {
      state = state.copyWith(isRunning: true);
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (state.remainingSeconds > 0) {
          state = state.copyWith(remainingSeconds: state.remainingSeconds - 1);
        } else {
          _handleTimerComplete();
        }
      });
    }
  }

  void resetTimer() {
    _timer?.cancel();
    state = state.copyWith(isRunning: false, remainingSeconds: _durationForMode(state.mode));
  }

  void switchMode(TimerMode newMode) {
    _timer?.cancel();
    state = state.copyWith(
      isRunning: false,
      mode: newMode,
      remainingSeconds: _durationForMode(newMode),
    );
    // Sync theme to the new mode
    _syncTheme(newMode);
  }

  void setActiveTask(String? taskId) {
    state = state.copyWith(activeTaskId: taskId, clearActiveTask: taskId == null);
  }

  /// Skip the current session and advance to the next mode
  void skipSession() {
    _timer?.cancel();
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
    _timer?.cancel();

    final bool isFocus = state.mode == TimerMode.focus;
    final String title = isFocus ? '🔥 Focus Complete!' : '⚡ Break Over!';
    final String body = isFocus
        ? 'Outstanding work! Time for a well-deserved break.'
        : 'Recharged! Back to the forge, champion.';

    // 1. Haptic + Audio feedback
    HapticFeedback.heavyImpact();
    await notificationServiceProvider.showSessionCompleteNotification(title, body);
    await alarmServiceProvider.playBell();

    if (isFocus) {
      // 2. Update stats
      try {
        await ref.read(statsServiceProvider).updateFocusTime(_focusDuration);
        
        // Update task progress if a task is active
        final activeTaskId = state.activeTaskId;
        if (activeTaskId != null) {
          final tasks = await ref.read(tasksStreamProvider.future);
          final task = tasks.firstWhere((t) => t.id == activeTaskId);
          await ref.read(taskServiceProvider).updateTask(
            task.copyWith(completedPomodoros: task.completedPomodoros + 1),
          );
        }
      } catch (e) {
        debugPrint('Error updating stats/task: $e');
      }

      // 3. Cycle to next mode and sync theme
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
