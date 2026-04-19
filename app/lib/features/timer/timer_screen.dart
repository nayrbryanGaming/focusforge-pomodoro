import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';
import 'dart:math';

import '../../providers/timer_provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/community_service.dart';
import '../../core/services/ambiance_service.dart';
import '../../core/services/task_service.dart';
import '../../core/services/settings_service.dart';
import '../../core/services/notification_service.dart';
import '../../core/services/alarm_service.dart';

import 'widgets/mode_selector.dart';
import 'widgets/timer_display.dart';
import 'widgets/timer_controls.dart';
import 'widgets/task_picker_sheet.dart';
import 'widgets/ambiance_picker_overlay.dart';

class TimerScreen extends ConsumerStatefulWidget {
  const TimerScreen({super.key});

  @override
  ConsumerState<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends ConsumerState<TimerScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController _pulseController;
  bool _isConcentrationMode = false;
  bool _showAmbiancePicker = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _pulseController = AnimationController(
        vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pulseController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(timerProvider.notifier).syncOnResume();
    }
  }

  void _showTaskPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const TaskPickerSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final timerState = ref.watch(timerProvider);
    final timerNotifier = ref.read(timerProvider.notifier);
    final theme = Theme.of(context);
    final isPowerSaving = ref.watch(settingsServiceProvider).isPowerSavingMode;
    final activeUsersAsync = ref.watch(activeUsersCountProvider);
    final currentAmbiance = ref.watch(ambianceServiceProvider);
    final tasksAsync = ref.watch(tasksStreamProvider);
    
    String? activeTaskTitle;
    if (timerState.activeTaskId != null) {
      tasksAsync.whenData((tasks) {
        try {
          activeTaskTitle = tasks
              .firstWhere((t) => t.id == timerState.activeTaskId)
              .title;
        } catch (_) {}
      });
    }

    final baseColor = timerState.mode == TimerMode.focus
        ? theme.colorScheme.primary
        : timerState.mode == TimerMode.shortBreak ? AppColors.success : Colors.lightBlueAccent;

    return Scaffold(
      backgroundColor: _isConcentrationMode ? Colors.black : theme.scaffoldBackgroundColor,
      appBar: _isConcentrationMode
          ? null
          : AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: _buildForgeLogo(),
              centerTitle: true,
              actions: [
                _buildActionButton(
                  icon: currentAmbiance == AmbianceTrack.none ? Icons.music_off_outlined : Icons.music_note,
                  color: currentAmbiance == AmbianceTrack.none ? null : AppColors.primary,
                  tooltip: 'Focus Ambiance',
                  onTap: () => setState(() => _showAmbiancePicker = !_showAmbiancePicker),
                ),
                _buildActionButton(
                  icon: Icons.fullscreen_outlined,
                  tooltip: 'Concentration Mode',
                  onTap: () => setState(() => _isConcentrationMode = true),
                ),
              ],
            ),
      body: Container(
        decoration: !_isConcentrationMode ? BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topRight,
            radius: 1.5,
            colors: [
              theme.colorScheme.primary.withValues(alpha: 0.05),
              theme.scaffoldBackgroundColor,
            ],
          ),
        ) : const BoxDecoration(color: Colors.black),
        child: SafeArea(
          child: Stack(
            children: [
              // Background Glow Pulse
              if (timerState.isRunning && !isPowerSaving)
                _buildBackgroundGlow(theme, timerState.mode),

              Column(
                children: [
                  if (!_isConcentrationMode) ...[
                    const SizedBox(height: 12),
                    _buildActiveUsersIndicator(activeUsersAsync),
                    const SizedBox(height: 12),
                    ModeSelector(
                      currentMode: timerState.mode,
                      onModeChanged: (mode) => timerNotifier.switchMode(mode),
                    ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2, end: 0),
                  ],
                  const Spacer(),
                  
                  // Main Timer Display
                  TimerDisplay(
                    remainingSeconds: timerState.remainingSeconds,
                    mode: timerState.mode,
                    isRunning: timerState.isRunning,
                    isConcentrationMode: _isConcentrationMode,
                    pulseValue: _pulseController.value,
                    baseColor: baseColor,
                  ).animate().scale(
                    duration: 800.ms,
                    curve: Curves.elasticOut,
                  ),

                  const SizedBox(height: 40),
                  
                  // Active Task Pill
                  if (!_isConcentrationMode)
                    _buildActiveTaskPill(timerState.activeTaskId, activeTaskTitle, baseColor),
                  
                  const Spacer(),
                  
                  // Main Controls
                  if (!_isConcentrationMode)
                    TimerControls(
                      isRunning: timerState.isRunning,
                      baseColor: baseColor,
                      onToggle: () => _handleToggle(timerState.isRunning, timerNotifier),
                      onReset: () {
                        HapticFeedback.mediumImpact();
                        timerNotifier.resetTimer();
                        ref.read(ambianceServiceProvider.notifier).stop();
                      },
                      onSkip: () {
                        HapticFeedback.lightImpact();
                        timerNotifier.skipSession();
                      },
                    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0),

                  if (_isConcentrationMode)
                    _buildConcentrationControls(timerState.isRunning, timerNotifier),
                  
                  const SizedBox(height: 12),
                ],
              ),
              
              if (_showAmbiancePicker && !_isConcentrationMode)
                AmbiancePickerOverlay(onClose: () => setState(() => _showAmbiancePicker = false)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildForgeLogo() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, Color(0xFFFF8C42)],
            ),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(Icons.bolt, size: 20, color: Colors.white),
        ),
        const SizedBox(width: 10),
        const Text('FocusForge',
            style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: -0.5)),
      ],
    );
  }

  Widget _buildActionButton({required IconData icon, Color? color, required String tooltip, required VoidCallback onTap}) {
    return IconButton(
      icon: Icon(icon, color: color),
      tooltip: tooltip,
      onPressed: onTap,
    );
  }

  Widget _buildBackgroundGlow(ThemeData theme, TimerMode mode) {
    return Center(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(seconds: 4),
        curve: Curves.easeInOut,
        builder: (context, value, child) {
          final scale = _isConcentrationMode ? 1.5 + (0.5 * sin(value * 2 * pi)) : 1.0 + (0.3 * sin(value * 2 * pi));
          final opacity = _isConcentrationMode ? 0.08 + (0.04 * sin(value * 2 * pi)) : 0.05 + (0.05 * sin(value * 2 * pi));
          return Container(
            width: 400 * scale,
            height: 400 * scale,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.colorScheme.primary.withValues(alpha: opacity),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withValues(alpha: (opacity * 2).clamp(0.0, 1.0)),
                  blurRadius: _isConcentrationMode ? 150 : 100,
                  spreadRadius: _isConcentrationMode ? 80 : 50,
                ),
              ],
            ),
          );
        },
      ).animate(onPlay: (c) => c.repeat()).fadeIn(),
    );
  }

  Widget _buildActiveUsersIndicator(AsyncValue<int> countAsync) {
    return FadeInDown(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.success,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: AppColors.success, blurRadius: 6, spreadRadius: 2)
                  ],
                ),
              ),
              const SizedBox(width: 10),
              countAsync.when(
                data: (count) => Text(
                  '$count Forgers active now',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                loading: () => const Text('Connecting...', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                error: (_, __) => const SizedBox(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActiveTaskPill(String? activeTaskId, String? activeTaskTitle, Color baseColor) {
    return FadeInUp(
      delay: const Duration(milliseconds: 400),
      child: GestureDetector(
        onTap: _showTaskPicker,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          decoration: BoxDecoration(
            color: activeTaskId != null ? baseColor.withValues(alpha: 0.1) : Colors.white.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: activeTaskId != null ? baseColor.withValues(alpha: 0.3) : Colors.white.withValues(alpha: 0.1),
              width: 1.5,
            ),
            boxShadow: activeTaskId != null ? [
              BoxShadow(color: baseColor.withValues(alpha: 0.1), blurRadius: 12, offset: const Offset(0, 4))
            ] : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                activeTaskId != null ? Icons.bolt : Icons.add_circle_outline,
                size: 18,
                color: activeTaskId != null ? baseColor : Colors.white38,
              ),
              const SizedBox(width: 12),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 180),
                child: Text(
                  activeTaskId != null ? (activeTaskTitle ?? 'Forge Active ✓') : 'What are we forging?',
                  style: TextStyle(
                    color: activeTaskId != null ? Colors.white : Colors.white38,
                    fontWeight: activeTaskId != null ? FontWeight.bold : FontWeight.w500,
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.unfold_more, size: 14, color: Colors.white24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConcentrationControls(bool isRunning, TimerNotifier notifier) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        children: [
          _ConcentrationModeButton(
            icon: isRunning ? Icons.pause : Icons.play_arrow,
            onTap: () {
              HapticFeedback.mediumImpact();
              notifier.toggleTimer();
            },
            size: 72,
          ),
          const SizedBox(height: 24),
          TextButton.icon(
            onPressed: () => setState(() => _isConcentrationMode = false),
            icon: const Icon(Icons.close, color: Colors.white24, size: 18),
            label: const Text('Exit Focus', style: TextStyle(color: Colors.white24)),
          ),
        ],
      ),
    );
  }

  Future<void> _handleToggle(bool isRunning, TimerNotifier notifier) async {
    HapticFeedback.heavyImpact();
    
    if (!isRunning) {
      final ns = ref.read(notificationServiceProvider);
      if (!(await ns.checkPermission())) {
        final result = await _showNotificationPrimingDialog();
        if (result == true) {
          await ns.requestPermissions();
        }
      }
    }

    notifier.toggleTimer();
    
    // Resume ambiance if starting focus
    if (!isRunning) {
      ref.read(ambianceServiceProvider.notifier).resume();
    } else {
      ref.read(ambianceServiceProvider.notifier).pause();
    }
  }

  Future<bool?> _showNotificationPrimingDialog() {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E2640),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Stay Focused?', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        content: const Text(
          'Allow notifications so we can alert you when your session or break is complete.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Not now')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Allow'),
          ),
        ],
      ),
    );
  }
}

class _ConcentrationModeButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final double size;

  const _ConcentrationModeButton({required this.icon, required this.onTap, required this.size});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: 0.1),
          border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
        ),
        child: Icon(icon, color: Colors.white, size: size * 0.4),
      ),
    );
  }
}
