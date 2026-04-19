import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AlarmService {
  Future<void> playBell() async {
    // Uses native system alert sound to ensure zero-dependency, crash-free playback
    await SystemSound.play(SystemSoundType.alert);
  }

  Future<void> playGong() async {
    await SystemSound.play(SystemSoundType.alert);
  }

  Future<void> stop() async {
    // Native system sounds are short; no manual stop required.
  }

  void dispose() {}
}

final alarmServiceProvider = Provider<AlarmService>((ref) => AlarmService());
