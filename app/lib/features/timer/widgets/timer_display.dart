import 'package:flutter/material.dart';
import 'dart:ui';
import '../timer_painter.dart' as painter;
import '../../../providers/timer_provider.dart';

class TimerDisplay extends StatelessWidget {
  final int remainingSeconds;
  final TimerMode mode;
  final bool isRunning;
  final bool isConcentrationMode;
  final double pulseValue;
  final Color baseColor;

  const TimerDisplay({
    super.key,
    required this.remainingSeconds,
    required this.mode,
    required this.isRunning,
    required this.isConcentrationMode,
    required this.pulseValue,
    required this.baseColor,
  });

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final timerState = ref.watch(timerProvider);
    
    // Calculate progress based on dynamic durations from settings
    final int totalSeconds;
    final settings = ref.read(settingsServiceProvider);
    switch (timerState.mode) {
      case TimerMode.focus: totalSeconds = settings.focusDuration * 60; break;
      case TimerMode.shortBreak: totalSeconds = settings.shortBreakDuration * 60; break;
      case TimerMode.longBreak: totalSeconds = settings.longBreakDuration * 60; break;
    }
    
    final progress = remainingSeconds / totalSeconds;

    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (isRunning && !isConcentrationMode)
            _buildOuterPulse(),
            
          SizedBox(
            width: isConcentrationMode ? 340 : 300,
            height: isConcentrationMode ? 340 : 300,
            child: CustomPaint(
              painter: painter.TimerPainter(
                progress: progress,
                mode: timerState.mode == TimerMode.focus
                    ? painter.TimerMode.focus
                    : painter.TimerMode.shortBreak,
                pulse: isRunning ? pulseValue : 0,
                color: baseColor,
              ),
            ),
          ),
          
          _buildCenterGlassPill(theme),
        ],
      ),
    );
  }

  Widget _buildOuterPulse() {
    return Container(
      width: 280,
      height: 280,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: baseColor.withValues(alpha: 0.12 * pulseValue),
            blurRadius: 70,
            spreadRadius: 25,
          ),
        ],
      ),
    );
  }

  Widget _buildCenterGlassPill(ThemeData theme) {
    return Container(
      width: isConcentrationMode ? 280 : 250,
      height: isConcentrationMode ? 280 : 250,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: 0.02),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            spreadRadius: -5,
          ),
        ],
      ),
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _formatTime(remainingSeconds),
                style: theme.textTheme.displayLarge?.copyWith(
                  fontSize: isConcentrationMode ? 92 : 80,
                  fontWeight: FontWeight.w100, // Ultra-thin premium look
                  letterSpacing: -4,
                  color: Colors.white,
                  fontFeatures: [const FontFeature.tabularFigures()],
                ),
              ),
              if (!isConcentrationMode) ...[
                const SizedBox(height: 8),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 400),
                  style: TextStyle(
                    letterSpacing: 4,
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    color: isRunning ? baseColor : Colors.white38,
                  ),
                  child: Text(
                    isRunning 
                      ? (mode == TimerMode.focus ? '● FOCUSING' : '● RESTING')
                      : 'READY TO FORGE',
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
