import 'package:audioplayers/audioplayers.dart';

class AlarmService {
  final AudioPlayer _audioPlayer = AudioPlayer();

  static const String _bellPath = 'assets/sounds/digital_bell.mp3';
  static const String _gongPath = 'assets/sounds/calm_gong.mp3';

  Future<void> playBell() async {
    await _play(_bellPath);
  }

  Future<void> playGong() async {
    await _play(_gongPath);
  }

  Future<void> _play(String assetPath) async {
    try {
      await _audioPlayer.play(AssetSource(assetPath));
    } catch (e) {
      print('Error playing sound: \$e');
    }
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}

final alarmServiceProvider = AlarmService();
