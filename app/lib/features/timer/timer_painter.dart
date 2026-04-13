import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class TimerPainter extends CustomPainter {
  final double progress;
  final TimerMode mode;
  final double pulse; // Pulsing value from 0.0 to 1.0
  final Color? color;

  TimerPainter({
    required this.progress, 
    required this.mode,
    this.pulse = 0.0,
    this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2);
    final strokeWidth = 14.0;

    // Background track
    final backgroundPaint = Paint()
      ..color = AppColors.surfaceHighlight.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius - strokeWidth / 2, backgroundPaint);

    // Color based on mode or provided dynamic color
    final baseColor = color ?? (mode == TimerMode.focus ? AppColors.primary : AppColors.success);
    
    // Progress arc
    final progressPaint = Paint()
      ..color = baseColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final arcAngle = 2 * pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      -pi / 2,
      arcAngle,
      false,
      progressPaint,
    );

    // Dynamic Pulsing Glow
    if (pulse > 0) {
      final glowPaint = Paint()
        ..color = baseColor.withOpacity(0.15 * pulse)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth + (12 * pulse)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
        -pi / 2,
        arcAngle,
        false,
        glowPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant TimerPainter oldDelegate) {
    return oldDelegate.progress != progress || 
           oldDelegate.mode != mode || 
           oldDelegate.pulse != pulse ||
           oldDelegate.color != color;
  }
}

enum TimerMode { focus, shortBreak, longBreak }
