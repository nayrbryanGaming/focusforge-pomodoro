import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AmbianceTrack {
  none,
  rain,
  forest,
  whiteNoise,
  lofi,
}

class AmbianceService extends StateNotifier<AmbianceTrack> {
  final AudioPlayer _player = AudioPlayer();

  AmbianceService() : super(AmbianceTrack.none) {
    _player.setReleaseMode(ReleaseMode.loop);
  }

  Future<void> setTrack(AmbianceTrack track) async {
    if (state == track) return;

    state = track;
    await _player.stop();

    if (track == AmbianceTrack.none) return;

    String assetPath;
    switch (track) {
      case AmbianceTrack.rain:
        assetPath = 'sounds/rain_loop.mp3';
        break;
      case AmbianceTrack.forest:
        assetPath = 'sounds/forest_loop.mp3';
        break;
      case AmbianceTrack.whiteNoise:
        assetPath = 'sounds/white_noise_loop.mp3';
        break;
      case AmbianceTrack.lofi:
        assetPath = 'sounds/lofi_loop.mp3';
        break;
      default:
        return;
    }

    try {
      await _player.play(AssetSource(assetPath));
    } catch (e) {
      // Logic for fallback or error handling
    }
  }

  Future<void> pause() async => await _player.pause();
  Future<void> resume() async {
    if (state != AmbianceTrack.none) {
      await _player.resume();
    }
  }
  
  Future<void> stop() async => await _player.stop();

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}

final ambianceServiceProvider = StateNotifierProvider<AmbianceService, AmbianceTrack>((ref) {
  return AmbianceService();
});
