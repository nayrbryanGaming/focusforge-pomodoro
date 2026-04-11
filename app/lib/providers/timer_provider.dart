import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum TimerMode { focus, shortBreak, longBreak }

class TimerState {
  final int remainingSeconds;
  final bool isRunning;
  final TimerMode mode;
  final int pomodoroCount;

  TimerState({
    required this.remainingSeconds,
    required this.isRunning,
    required this.mode,
    required this.pomodoroCount,
  });

  TimerState copyWith({
    int? remainingSeconds,
    bool? isRunning,
    TimerMode? mode,
    int? pomodoroCount,
  }) {
    return TimerState(
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      isRunning: isRunning ?? this.isRunning,
      mode: mode ?? this.mode,
      pomodoroCount: pomodoroCount ?? this.pomodoroCount,
    );
  }
}

class TimerNotifier extends Notifier<TimerState> {
  static const int _focusDuration = 25 * 60;
  static const int _shortBreakDuration = 5 * 60;
  static const int _longBreakDuration = 15 * 60;
  
  Timer? _timer;

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
    int resetDuration = _focusDuration;
    if (state.mode == TimerMode.shortBreak) resetDuration = _shortBreakDuration;
    if (state.mode == TimerMode.longBreak) resetDuration = _longBreakDuration;
    
    state = state.copyWith(
      isRunning: false,
      remainingSeconds: resetDuration,
    );
  }

  void switchMode(TimerMode newMode) {
    _timer?.cancel();
    int newDuration = _focusDuration;
    if (newMode == TimerMode.shortBreak) newDuration = _shortBreakDuration;
    if (newMode == TimerMode.longBreak) newDuration = _longBreakDuration;

    state = state.copyWith(
      isRunning: false,
      mode: newMode,
      remainingSeconds: newDuration,
    );
  }

  void _handleTimerComplete() {
    _timer?.cancel();
    if (state.mode == TimerMode.focus) {
      int newCount = state.pomodoroCount + 1;
      TimerMode nextMode = (newCount % 4 == 0) ? TimerMode.longBreak : TimerMode.shortBreak;
      
      state = state.copyWith(
        isRunning: false,
        pomodoroCount: newCount,
        mode: nextMode,
        remainingSeconds: nextMode == TimerMode.longBreak ? _longBreakDuration : _shortBreakDuration,
      );
      // Here we would also call StatsService to save to Firebase
    } else {
      state = state.copyWith(
        isRunning: false,
        mode: TimerMode.focus,
        remainingSeconds: _focusDuration,
      );
    }
  }
}

final timerProvider = NotifierProvider<TimerNotifier, TimerState>(() {
  return TimerNotifier();
});
