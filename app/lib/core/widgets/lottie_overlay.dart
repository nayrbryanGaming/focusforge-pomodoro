import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// A native Flutter celebration overlay — replaces Lottie dependency.
/// Shows an animated icon, a message, and a dismiss button.
class LottieOverlay extends StatelessWidget {
  final String asset; // kept for API compatibility (unused)
  final String message;
  final VoidCallback onDismiss;

  const LottieOverlay({
    super.key,
    required this.asset,
    required this.message,
    required this.onDismiss,
  });

  static void show(
    BuildContext context, {
    required String asset,
    required String message,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black87,
      builder: (ctx) => LottieOverlay(
        asset: asset,
        message: message,
        onDismiss: () => Navigator.pop(ctx),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF6B35), Color(0xFFFFB347)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF6B35).withValues(alpha: 0.4),
                    blurRadius: 40,
                    offset: const Offset(0, 20),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(Icons.bolt_rounded, size: 80, color: Colors.white),
              ),
            )
                .animate()
                .scale(duration: 600.ms, curve: Curves.easeOutBack)
                .then()
                .shimmer(duration: 1200.ms),
            const SizedBox(height: 32),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                decoration: TextDecoration.none,
                letterSpacing: -0.5,
              ),
            )
                .animate()
                .fadeIn(delay: 400.ms)
                .moveY(begin: 20, end: 0, delay: 400.ms),
            const SizedBox(height: 48),
            ElevatedButton(
              onPressed: onDismiss,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text('Back to Forge',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ).animate().fadeIn(delay: 800.ms).moveY(begin: 20, end: 0, delay: 800.ms),
          ],
        ),
      ),
    );
  }
}
