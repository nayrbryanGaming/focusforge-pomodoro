import 'package:flutter/material.dart';

class ToastService {
  static final GlobalKey<ScaffoldMessengerState> messengerKey = GlobalKey<ScaffoldMessengerState>();

  static void showSuccess(String message) {
    _showSnackBar(message, Colors.greenAccent, Icons.check_circle_outline);
  }

  static void showError(String message) {
    _showSnackBar(message, Colors.redAccent, Icons.error_outline);
  }

  static void showInfo(String message) {
    _showSnackBar(message, Colors.blueAccent, Icons.info_outline);
  }

  static void _showSnackBar(String message, Color backgroundColor, IconData icon) {
    messengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message, style: const TextStyle(color: Colors.white))),
          ],
        ),
        backgroundColor: backgroundColor.withOpacity(0.9),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
