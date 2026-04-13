import 'package:confetti/confetti.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConfettiService {
  final ConfettiController _controller = ConfettiController(duration: const Duration(seconds: 3));

  ConfettiController get controller => _controller;

  void play() {
    _controller.play();
  }

  void stop() {
    _controller.stop();
  }

  void dispose() {
    _controller.dispose();
  }
}

final confettiServiceProvider = Provider<ConfettiService>((ref) {
  final service = ConfettiService();
  ref.onDispose(() => service.dispose());
  return service;
});
