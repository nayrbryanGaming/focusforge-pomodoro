import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/timer_provider.dart';
import '../../core/constants/app_colors.dart';

class TimerScreen extends ConsumerWidget {
  const TimerScreen({super.key});

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '\${minutes.toString().padLeft(2, '0')}:\${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerState = ref.watch(timerProvider);
    final timerNotifier = ref.read(timerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('FocusForge'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Mode Selectors
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ModeButton(
                  title: 'Focus',
                  isSelected: timerState.mode == TimerMode.focus,
                  onTap: () => timerNotifier.switchMode(TimerMode.focus),
                ),
                _ModeButton(
                  title: 'Short Break',
                  isSelected: timerState.mode == TimerMode.shortBreak,
                  onTap: () => timerNotifier.switchMode(TimerMode.shortBreak),
                ),
                _ModeButton(
                  title: 'Long Break',
                  isSelected: timerState.mode == TimerMode.longBreak,
                  onTap: () => timerNotifier.switchMode(TimerMode.longBreak),
                ),
              ],
            ),
            
            const Spacer(),
            
            // Timer Display
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 300,
                  height: 300,
                  child: CircularProgressIndicator(
                    value: timerState.mode == TimerMode.focus 
                        ? (timerState.remainingSeconds / (25 * 60))
                        : timerState.mode == TimerMode.shortBreak 
                            ? (timerState.remainingSeconds / (5 * 60))
                            : (timerState.remainingSeconds / (15 * 60)),
                    strokeWidth: 12,
                    backgroundColor: AppColors.surfaceHighlight,
                    color: timerState.mode == TimerMode.focus ? AppColors.primary : AppColors.accent,
                  ),
                ),
                Text(
                  _formatTime(timerState.remainingSeconds),
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontSize: 80,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 40),

            // Pomodoro Count
            Text(
              'Pomodoros Completed: \${timerState.pomodoroCount}',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppColors.textSecondary),
            ),

            const Spacer(),

            // Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton.large(
                  onPressed: timerNotifier.toggleTimer,
                  backgroundColor: timerState.isRunning ? AppColors.surfaceHighlight : AppColors.primary,
                  child: Icon(
                    timerState.isRunning ? Icons.pause : Icons.play_arrow,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 20),
                FloatingActionButton(
                  onPressed: timerNotifier.resetTimer,
                  backgroundColor: AppColors.surface,
                  child: const Icon(Icons.refresh, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _ModeButton({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.surfaceHighlight : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
