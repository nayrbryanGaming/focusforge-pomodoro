import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';

class TimerControls extends StatelessWidget {
  final bool isRunning;
  final VoidCallback onToggle;
  final VoidCallback onReset;
  final VoidCallback onSkip;
  final Color baseColor;

  const TimerControls({
    super.key,
    required this.isRunning,
    required this.onToggle,
    required this.onReset,
    required this.onSkip,
    required this.baseColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _CircleButton(
            icon: Icons.refresh_rounded,
            onTap: onReset,
            size: 58,
            tooltip: 'Restart',
          ),
          const SizedBox(width: 24),
          GestureDetector(
            onTap: onToggle,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: isRunning 
                    ? [Colors.white.withValues(alpha: 0.1), Colors.white.withValues(alpha: 0.05)]
                    : [baseColor, baseColor.withValues(alpha: 0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: isRunning ? [] : [
                  BoxShadow(
                    color: baseColor.withValues(alpha: 0.4),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  )
                ],
                border: Border.all(
                  color: isRunning ? Colors.white.withValues(alpha: 0.1) : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Icon(
                isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded,
                size: 48,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 24),
          _CircleButton(
            icon: Icons.skip_next_rounded,
            onTap: onSkip,
            size: 58,
            tooltip: 'Skip',
          ),
        ],
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final double size;
  final String tooltip;

  const _CircleButton({
    required this.icon,
    required this.onTap,
    this.size = 56,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: 0.04),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          ),
          child: Icon(icon, color: Colors.white70, size: size * 0.5),
        ),
      ),
    );
  }
}
