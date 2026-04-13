import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animate_do/animate_do.dart';
import 'dart:ui';
import '../../providers/timer_provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/community_service.dart';
import '../../core/services/ambiance_service.dart';
import '../../core/services/task_service.dart';
import '../../core/services/stats_service.dart';
import '../../models/task_model.dart';
import 'timer_painter.dart' as painter;

class TimerScreen extends ConsumerStatefulWidget {
  const TimerScreen({super.key});

  @override
  ConsumerState<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends ConsumerState<TimerScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  bool _isConcentrationMode = false;
  bool _showAmbiancePicker = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
        vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _showTaskPicker(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Consumer(
        builder: (ctx, innerRef, _) {
          final tasksAsync = innerRef.watch(tasksStreamProvider);
          final activeTaskId = innerRef.watch(timerProvider).activeTaskId;

          return Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1A2035),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
              border: Border.all(color: Colors.white.withOpacity(0.08)),
            ),
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 24),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.assignment_outlined, color: AppColors.primary, size: 22),
                    const SizedBox(width: 12),
                    const Text(
                      'Assign Focus Task',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    if (activeTaskId != null)
                      TextButton.icon(
                        onPressed: () {
                          innerRef.read(timerProvider.notifier).setActiveTask(null);
                          Navigator.pop(ctx);
                        },
                        icon: const Icon(Icons.clear, size: 16),
                        label: const Text('Clear'),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.orange,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  'Your session will track progress for this task.',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                ),
                const SizedBox(height: 20),
                tasksAsync.when(
                  data: (tasks) {
                    if (tasks.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 32),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(Icons.task_outlined, color: AppColors.textSecondary, size: 40),
                              SizedBox(height: 12),
                              Text(
                                'No tasks yet. Create one in the Tasks tab!',
                                style: TextStyle(color: AppColors.textSecondary),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    final activeTasks = tasks.where((t) => !t.isCompleted).toList();

                    return SizedBox(
                      height: activeTasks.length > 5 ? 300 : null,
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: activeTasks.length,
                        separatorBuilder: (_, __) =>
                            Divider(color: Colors.white.withOpacity(0.05), height: 1),
                        itemBuilder: (context, index) {
                          final task = activeTasks[index];
                          final isSelected = activeTaskId == task.id;

                          return InkWell(
                            borderRadius: BorderRadius.circular(14),
                            onTap: () {
                              HapticFeedback.selectionClick();
                              innerRef
                                  .read(timerProvider.notifier)
                                  .setActiveTask(task.id);
                              Navigator.pop(ctx);
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 14),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primary.withOpacity(0.12)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(14),
                                border: isSelected
                                    ? Border.all(
                                        color: AppColors.primary.withOpacity(0.4))
                                    : null,
                              ),
                              child: Row(
                                children: [
                                  AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 200),
                                    child: isSelected
                                        ? const Icon(Icons.radio_button_checked,
                                            color: AppColors.primary, size: 20, key: ValueKey('checked'))
                                        : Icon(Icons.radio_button_unchecked,
                                            color: Colors.white.withOpacity(0.3),
                                            size: 20,
                                            key: const ValueKey('unchecked')),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          task.title,
                                          style: TextStyle(
                                            color: isSelected
                                                ? Colors.white
                                                : Colors.white.withOpacity(0.85),
                                            fontWeight: isSelected
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                            fontSize: 15,
                                          ),
                                        ),
                                        if (task.category != null)
                                          Text(
                                            task.category!,
                                            style: const TextStyle(
                                              color: AppColors.textSecondary,
                                              fontSize: 11,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? AppColors.primary.withOpacity(0.2)
                                          : Colors.white.withOpacity(0.05),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      '${task.completedPomodoros}/${task.estimatedPomodoros} 🍅',
                                      style: TextStyle(
                                        color: isSelected
                                            ? AppColors.primary
                                            : AppColors.textSecondary,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                  loading: () => const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  error: (_, __) => const Padding(
                    padding: EdgeInsets.all(24),
                    child: Text(
                      'Could not load tasks. Sign in to access your task list.',
                      style: TextStyle(color: AppColors.textSecondary),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final timerState = ref.watch(timerProvider);
    final timerNotifier = ref.read(timerProvider.notifier);
    final theme = Theme.of(context);
    final activeUsersAsync = ref.watch(activeUsersCountProvider);
    final currentAmbiance = ref.watch(ambianceServiceProvider);

    // Get active task title from stream
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

    return Scaffold(
      backgroundColor: _isConcentrationMode
          ? Colors.black
          : theme.scaffoldBackgroundColor,
      appBar: _isConcentrationMode
          ? null
          : AppBar(
              title: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primary, Color(0xFFFF8C42)],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.bolt, size: 18, color: Colors.white),
                  ),
                  const SizedBox(width: 8),
                  const Text('FocusForge',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: Icon(
                    currentAmbiance == AmbianceTrack.none
                        ? Icons.music_off_outlined
                        : Icons.music_note,
                    color: currentAmbiance == AmbianceTrack.none
                        ? null
                        : AppColors.primary,
                  ),
                  tooltip: 'Focus Ambiance',
                  onPressed: () =>
                      setState(() => _showAmbiancePicker = !_showAmbiancePicker),
                ),
                IconButton(
                  icon: const Icon(Icons.fullscreen_outlined),
                  tooltip: 'Concentration Mode',
                  onPressed: () =>
                      setState(() => _isConcentrationMode = true),
                ),
              ],
            ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Live Social Proof Banner
                if (!_isConcentrationMode) ...[
                  FadeInDown(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.success,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.success,
                                  blurRadius: 4,
                                  spreadRadius: 1,
                                )
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          activeUsersAsync.when(
                            data: (count) => Text(
                              '$count Forgers active now',
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.5,
                              ),
                            ).animate(),
                            loading: () => const Text(
                              'Connecting to Forge...',
                              style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12),
                            ),
                            error: (_, __) => const SizedBox(),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Live Stats Widget
                  FadeInDown(
                    delay: const Duration(milliseconds: 100),
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 24.0),
                      child: _buildLiveStatsWidget(context),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Mode tabs
                  FadeInDown(
                    delay: const Duration(milliseconds: 150),
                    child: Container(
                      margin:
                          const EdgeInsets.symmetric(horizontal: 24),
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _ModeButton(
                            title: '🍅  Focus',
                            isSelected: timerState.mode == TimerMode.focus,
                            onTap: () =>
                                timerNotifier.switchMode(TimerMode.focus),
                            activeColor: theme.colorScheme.primary,
                          ),
                          _ModeButton(
                            title: '☕  Short Break',
                            isSelected:
                                timerState.mode == TimerMode.shortBreak,
                            onTap: () => timerNotifier
                                .switchMode(TimerMode.shortBreak),
                            activeColor: AppColors.success,
                          ),
                          _ModeButton(
                            title: '🌙  Long Break',
                            isSelected:
                                timerState.mode == TimerMode.longBreak,
                            onTap: () => timerNotifier
                                .switchMode(TimerMode.longBreak),
                            activeColor: Colors.lightBlueAccent,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                const Spacer(),

                // Timer Display
                GestureDetector(
                  onLongPress: () => setState(
                      () => _isConcentrationMode = !_isConcentrationMode),
                  child: AnimatedBuilder(
                    animation: _pulseController,
                    builder: (context, child) {
                      // Haptic on last 10 seconds
                      if (timerState.remainingSeconds <= 10 &&
                          timerState.isRunning &&
                          timerState.remainingSeconds > 0) {
                        if (_pulseController.value > 0.85) {
                          HapticFeedback.lightImpact();
                        }
                      }

                      final totalSeconds = timerState.mode == TimerMode.focus
                          ? 25 * 60
                          : timerState.mode == TimerMode.shortBreak
                              ? 5 * 60
                              : 15 * 60;

                      final progress =
                          timerState.remainingSeconds / totalSeconds;

                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          // Outer glow ring
                          if (timerState.isRunning && !_isConcentrationMode)
                            SizedBox(
                              width: 320,
                              height: 320,
                              child: AnimatedBuilder(
                                animation: _pulseController,
                                builder: (_, __) => CustomPaint(
                                  painter: painter.TimerPainter(
                                    progress: progress,
                                    mode: timerState.mode == TimerMode.focus
                                        ? painter.TimerMode.focus
                                        : painter.TimerMode.shortBreak,
                                    pulse: _pulseController.value * 0.5,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ),
                            ),

                          SizedBox(
                            width: _isConcentrationMode ? 340 : 290,
                            height: _isConcentrationMode ? 340 : 290,
                            child: CustomPaint(
                              painter: painter.TimerPainter(
                                progress: progress,
                                mode: timerState.mode == TimerMode.focus
                                    ? painter.TimerMode.focus
                                    : painter.TimerMode.shortBreak,
                                pulse: timerState.isRunning
                                    ? _pulseController.value
                                    : 0,
                                color: timerState.mode == TimerMode.focus
                                    ? theme.colorScheme.primary
                                    : timerState.mode == TimerMode.shortBreak
                                        ? AppColors.success
                                        : Colors.lightBlueAccent,
                              ),
                            ),
                          ),

                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _formatTime(timerState.remainingSeconds),
                                style: Theme.of(context)
                                    .textTheme
                                    .displayLarge
                                    ?.copyWith(
                                      fontSize: _isConcentrationMode
                                          ? 88
                                          : 72,
                                      fontWeight: FontWeight.w200,
                                      letterSpacing: -2,
                                      color: AppColors.textPrimary,
                                    ),
                              ),
                              if (!_isConcentrationMode) ...[
                                const SizedBox(height: 4),
                                AnimatedSwitcher(
                                  duration:
                                      const Duration(milliseconds: 300),
                                  child: Text(
                                    timerState.isRunning
                                        ? timerState.mode == TimerMode.focus
                                            ? '● FOCUSING'
                                            : '● RESTING'
                                        : 'TAP TO START',
                                    key: ValueKey(timerState.isRunning),
                                    style: TextStyle(
                                      letterSpacing: 3,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: timerState.isRunning
                                          ? theme.colorScheme.primary
                                          : AppColors.textSecondary
                                              .withOpacity(0.5),
                                    ),
                                  ),
                                ),
                              ],
                              if (_isConcentrationMode) ...[
                                const SizedBox(height: 8),
                                Text(
                                  timerState.mode == TimerMode.focus
                                      ? 'DEEP FOCUS'
                                      : 'BREAK TIME',
                                  style: TextStyle(
                                    letterSpacing: 4,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: theme.colorScheme.primary
                                        .withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),

                const SizedBox(height: 32),

                // Active Task chip
                if (!_isConcentrationMode)
                  GestureDetector(
                    onTap: () => _showTaskPicker(context, ref),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: timerState.activeTaskId != null
                            ? theme.colorScheme.primary.withOpacity(0.12)
                            : Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: timerState.activeTaskId != null
                              ? theme.colorScheme.primary.withOpacity(0.3)
                              : Colors.white.withOpacity(0.08),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            timerState.activeTaskId != null
                                ? Icons.assignment_turned_in_outlined
                                : Icons.assignment_outlined,
                            size: 16,
                            color: timerState.activeTaskId != null
                                ? theme.colorScheme.primary
                                : AppColors.textSecondary,
                          ),
                          const SizedBox(width: 8),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 200),
                            child: Text(
                              timerState.activeTaskId != null
                                  ? (activeTaskTitle ?? 'Task Selected ✓')
                                  : 'Tap to select a task',
                              style: TextStyle(
                                color: timerState.activeTaskId != null
                                    ? theme.colorScheme.primary
                                    : AppColors.textSecondary,
                                fontWeight: timerState.activeTaskId != null
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                fontSize: 13,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.keyboard_arrow_down,
                            size: 16,
                            color: timerState.activeTaskId != null
                                ? theme.colorScheme.primary
                                : AppColors.textSecondary,
                          ),
                        ],
                      ),
                    ),
                  ),

                const Spacer(),

                // Controls
                if (!_isConcentrationMode)
                  FadeInUp(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Reset button
                        _CircleButton(
                          icon: Icons.refresh_rounded,
                          onTap: () {
                            HapticFeedback.mediumImpact();
                            timerNotifier.resetTimer();
                            ref
                                .read(ambianceServiceProvider.notifier)
                                .stop();
                          },
                          size: 56,
                          tooltip: 'Reset',
                        ),

                        const SizedBox(width: 20),

                        // Play/Pause button (main CTA)
                        GestureDetector(
                          onTap: () {
                            HapticFeedback.mediumImpact();
                            timerNotifier.toggleTimer();
                            if (timerState.isRunning) {
                              ref
                                  .read(ambianceServiceProvider.notifier)
                                  .pause();
                            } else {
                              ref
                                  .read(ambianceServiceProvider.notifier)
                                  .resume();
                            }
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: timerState.isRunning
                                  ? LinearGradient(
                                      colors: [
                                        Colors.white.withOpacity(0.15),
                                        Colors.white.withOpacity(0.05),
                                      ],
                                    )
                                  : LinearGradient(
                                      colors: [
                                        theme.colorScheme.primary,
                                        theme.colorScheme.primary
                                            .withOpacity(0.7),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                              boxShadow: timerState.isRunning
                                  ? []
                                  : [
                                      BoxShadow(
                                        color: theme.colorScheme.primary
                                            .withOpacity(0.4),
                                        blurRadius: 24,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                            ),
                            child: Icon(
                              timerState.isRunning
                                  ? Icons.pause_rounded
                                  : Icons.play_arrow_rounded,
                              size: 44,
                              color: Colors.white,
                            ),
                          ),
                        ),

                        const SizedBox(width: 20),

                        // Skip button
                        _CircleButton(
                          icon: Icons.skip_next_rounded,
                          onTap: () {
                            HapticFeedback.lightImpact();
                            timerNotifier.skipSession();
                          },
                          size: 56,
                          tooltip: 'Skip',
                        ),
                      ],
                    ),
                  ),

                if (_isConcentrationMode)
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        // Play/Pause in concentration mode
                        GestureDetector(
                          onTap: () {
                            HapticFeedback.mediumImpact();
                            timerNotifier.toggleTimer();
                          },
                          child: Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.08),
                            ),
                            child: Icon(
                              timerState.isRunning
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              size: 40,
                              color: Colors.white54,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextButton.icon(
                          onPressed: () =>
                              setState(() => _isConcentrationMode = false),
                          icon: const Icon(Icons.close,
                              color: Colors.white38, size: 18),
                          label: const Text(
                            'Exit Focus Mode',
                            style: TextStyle(color: Colors.white38, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 24),
              ],
            ),

            // Ambiance Picker Overlay
            if (_showAmbiancePicker && !_isConcentrationMode)
              Positioned.fill(
                child: GestureDetector(
                  onTap: () =>
                      setState(() => _showAmbiancePicker = false),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                      child: Center(
                        child: FadeInUp(
                          duration: const Duration(milliseconds: 250),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 32),
                            padding: const EdgeInsets.all(28),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A2035),
                              borderRadius: BorderRadius.circular(28),
                              border: Border.all(
                                  color: Colors.white.withOpacity(0.08)),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  '🎵  Focus Ambiance',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                const Text(
                                  'Select ambient sound to block distractions',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 12,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 24),
                                Wrap(
                                  spacing: 12,
                                  runSpacing: 12,
                                  alignment: WrapAlignment.center,
                                  children: [
                                    _AmbianceButton(
                                      label: 'None',
                                      emoji: '🔇',
                                      track: AmbianceTrack.none,
                                      isSelected:
                                          currentAmbiance == AmbianceTrack.none,
                                    ),
                                    _AmbianceButton(
                                      label: 'Rain',
                                      emoji: '🌧️',
                                      track: AmbianceTrack.rain,
                                      isSelected:
                                          currentAmbiance == AmbianceTrack.rain,
                                    ),
                                    _AmbianceButton(
                                      label: 'Forest',
                                      emoji: '🌲',
                                      track: AmbianceTrack.forest,
                                      isSelected:
                                          currentAmbiance ==
                                              AmbianceTrack.forest,
                                    ),
                                    _AmbianceButton(
                                      label: 'White Noise',
                                      emoji: '〰️',
                                      track: AmbianceTrack.whiteNoise,
                                      isSelected:
                                          currentAmbiance ==
                                              AmbianceTrack.whiteNoise,
                                    ),
                                    _AmbianceButton(
                                      label: 'Lofi',
                                      emoji: '🎧',
                                      track: AmbianceTrack.lofi,
                                      isSelected:
                                          currentAmbiance == AmbianceTrack.lofi,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                TextButton(
                                  onPressed: () => setState(
                                      () => _showAmbiancePicker = false),
                                  child: const Text('Close',
                                      style:
                                          TextStyle(color: AppColors.primary)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLiveStatsWidget(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final statsAsync = ref.watch(statsStreamProvider);

    return statsAsync.when(
      data: (stats) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surface.withOpacity(0.5),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: primary.withOpacity(0.1)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildStatItem(
              'Today',
              '${(stats['todayFocusMinutes'] ?? 0) ~/ 60}h ${(stats['todayFocusMinutes'] ?? 0) % 60}m',
              Icons.auto_graph,
              primary,
            ),
            Container(width: 1, height: 24, color: Colors.white10),
            _buildStatItem(
              'Sessions',
              '${stats['todaySessions'] ?? 0}',
              Icons.check_circle_outline,
              AppColors.success,
            ),
            Container(width: 1, height: 24, color: Colors.white10),
            _buildStatItem(
              'Streak',
              '${stats['dailyStreak'] ?? 0}d 🔥',
              Icons.local_fire_department,
              Colors.orange,
            ),
          ],
        ),
      ),
      loading: () => Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surface.withOpacity(0.5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      ),
      error: (_, __) => _buildStaticStatsWidget(context, primary),
    );
  }

  Widget _buildStaticStatsWidget(BuildContext context, Color primary) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: primary.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem('Today', '—', Icons.auto_graph, primary),
          Container(width: 1, height: 24, color: Colors.white10),
          _buildStatItem('Sessions', '—', Icons.check_circle_outline, AppColors.success),
          Container(width: 1, height: 24, color: Colors.white10),
          _buildStatItem('Streak', '—', Icons.local_fire_department, Colors.orange),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 5),
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Colors.white,
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// ─── Supporting Widgets ──────────────────────────────────────────

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final double size;
  final String tooltip;

  const _CircleButton({
    required this.icon,
    required this.onTap,
    required this.size,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(size / 2),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.06),
          ),
          child: Icon(icon, size: size * 0.45, color: Colors.white60),
        ),
      ),
    );
  }
}

class _AmbianceButton extends ConsumerWidget {
  final String label;
  final String emoji;
  final AmbianceTrack track;
  final bool isSelected;

  const _AmbianceButton({
    required this.label,
    required this.emoji,
    required this.track,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        ref.read(ambianceServiceProvider.notifier).setTrack(track);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 90,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.2)
              : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppColors.primary.withOpacity(0.6)
                : Colors.white.withOpacity(0.08),
          ),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white60,
                fontSize: 11,
                fontWeight:
                    isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              textAlign: TextAlign.center,
            ),
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
  final Color activeColor;

  const _ModeButton({
    required this.title,
    required this.isSelected,
    required this.onTap,
    required this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color:
              isSelected ? activeColor.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? activeColor : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
