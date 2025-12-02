import 'package:audioplayers/audioplayers.dart';

class AudioController {
  static final AudioPlayer player = AudioPlayer();
  static String? _currentAsset;
  static bool _muted = false;

  static bool get isMuted => _muted;

  static Future<void> playMenu() async {
    await _playIfNeeded('music/jazz.mp3');
  }

  static Future<void> playGameplay() async {
    await _playIfNeeded('music/gameplay_music.mp3');
  }

  static Future<void> _playIfNeeded(String asset) async {
    if (_currentAsset == asset) return;
    _currentAsset = asset;
    await player.stop();
    await player.setReleaseMode(ReleaseMode.loop);
    await player.setVolume(_muted ? 0 : 1);
    await player.play(AssetSource(asset));
  }

  static Future<void> stop() async {
    _currentAsset = null;
    await player.stop();
  }

  static Future<void> setMuted(bool mute) async {
    _muted = mute;
    await player.setVolume(mute ? 0 : 1);
  }
}
