import 'package:audioplayers/audioplayers.dart';

class SoundManager {
  static final AudioPlayer _player = AudioPlayer();
  
  static Future<void> playPenClick() async {
    await _player.play(AssetSource('sounds/pen_click.mp3'), volume: 0.5);
  }
  
  static Future<void> playPageFlip() async {
    await _player.play(AssetSource('sounds/page_flip.mp3'), volume: 0.5);
  }
}