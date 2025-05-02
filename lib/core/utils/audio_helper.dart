import 'package:just_audio/just_audio.dart';
import 'package:flutter/foundation.dart';

enum SoundType {
  correct,
  incorrect,
}

class AudioHelper {
  static final AudioHelper _instance = AudioHelper._internal();
  
  factory AudioHelper() => _instance;
  
  AudioHelper._internal();
  
  late AudioPlayer correctPlayer;
  late AudioPlayer incorrectPlayer;
  
  Future<void> init() async {
    correctPlayer = AudioPlayer();
    incorrectPlayer = AudioPlayer();
    
    try {
      await correctPlayer.setAsset('assets/sounds/correct.mp3');
      await incorrectPlayer.setAsset('assets/sounds/incorrect.mp3');
      if (kDebugMode) {
        debugPrint('Sesler başarıyla yüklendi');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Ses yüklenirken hata oluştu: $e');
      }
    }
  }
  
  Future<void> playSound(SoundType type) async {
    switch (type) {
      case SoundType.correct:
        await correctPlayer.seek(Duration.zero);
        await correctPlayer.play();
        break;
      case SoundType.incorrect:
        await incorrectPlayer.seek(Duration.zero);
        await incorrectPlayer.play();
        break;
    }
  }
  
  void dispose() {
    correctPlayer.dispose();
    incorrectPlayer.dispose();
  }
}