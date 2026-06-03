import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../providers/timer_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/l10n_service.dart';

class ModeSelector extends ConsumerWidget {
  final TimerMode currentMode;
  final Function(TimerMode) onModeChanged;

  const ModeSelector({
    super.key,
    required this.currentMode,
    required this.onModeChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = ref.read(l10nServiceProvider.notifier);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _ModeButton(
            title: '🍅  ${l10n.translate('focus')}',
            isSelected: currentMode == TimerMode.focus,
            onTap: () => onModeChanged(TimerMode.focus),
            activeColor: theme.colorScheme.primary,
          ),
          _ModeButton(
            title: '☕  ${l10n.translate('short_mode')}',
            isSelected: currentMode == TimerMode.shortBreak,
            onTap: () => onModeChanged(TimerMode.shortBreak),
            activeColor: AppColors.success,
          ),
          _ModeButton(
            title: '🌙  ${l10n.translate('long_mode')}',
            isSelected: currentMode == TimerMode.longBreak,
            onTap: () => onModeChanged(TimerMode.longBreak),
            activeColor: Colors.lightBlueAccent,
          ),
        ],
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
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? activeColor.withValues(alpha: 0.12) : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? activeColor.withValues(alpha: 0.3) : Colors.transparent,
              width: 1,
            ),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? activeColor : AppColors.textSecondary,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}
