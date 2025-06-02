import 'package:just_audio/just_audio.dart';
import 'package:flutter/foundation.dart';
import '../services/storage_service.dart';
import '../constants/app_constants.dart';

enum SoundType {
  correct,
  incorrect,
  levelUp,
  gameOver,
}

class AudioHelper {
  static final AudioHelper _instance = AudioHelper._internal();
  
  factory AudioHelper() => _instance;
  
  AudioHelper._internal();
  
  final Map<SoundType, AudioPlayer> _players = {};
  bool _isInitialized = false;
  
  Future<void> init() async {
    if (_isInitialized) return;
    
    try {
      // Initialize audio players for each sound type
      _players[SoundType.correct] = AudioPlayer();
      _players[SoundType.incorrect] = AudioPlayer();
      _players[SoundType.levelUp] = AudioPlayer();
      _players[SoundType.gameOver] = AudioPlayer();
      
      // Load audio assets
      await Future.wait([
        _players[SoundType.correct]!.setAsset(AppConstants.correctSoundPath),
        _players[SoundType.incorrect]!.setAsset(AppConstants.wrongSoundPath),
        _players[SoundType.levelUp]!.setAsset(AppConstants.levelUpSoundPath),
        _players[SoundType.gameOver]!.setAsset(AppConstants.gameOverSoundPath),
      ]);
      
      _isInitialized = true;
      if (kDebugMode) {
        debugPrint('AudioHelper: Tüm sesler başarıyla yüklendi');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('AudioHelper: Ses yüklenirken hata oluştu: $e');
      }
    }
  }
  
  Future<void> playSound(SoundType type) async {
    try {
      // Check if sound is enabled in settings
      final isSoundEnabled = await StorageService.instance.isSoundEnabled();
      if (!isSoundEnabled || !_isInitialized) return;
      
      final player = _players[type];
      if (player == null) {
        if (kDebugMode) {
          debugPrint('AudioHelper: Player bulunamadı: $type');
        }
        return;
      }
      
      // Reset position and play
      await player.seek(Duration.zero);
      await player.play();
      
      if (kDebugMode) {
        debugPrint('AudioHelper: Ses çalındı: $type');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('AudioHelper: Ses çalınırken hata oluştu: $e');
      }
    }
  }
  
  Future<void> stopAll() async {
    try {
      await Future.wait(
        _players.values.map((player) => player.stop()),
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('AudioHelper: Sesleri durdururken hata oluştu: $e');
      }
    }
  }
    Future<void> setVolume(double volume) async {
    try {
      volume = volume.clamp(0.0, 1.0);
      await Future.wait(
        _players.values.map((player) => player.setVolume(volume)),
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('AudioHelper: Ses seviyesi ayarlanırken hata oluştu: $e');
      }
    }
  }
  
  void dispose() {
    for (final player in _players.values) {
      player.dispose();
    }
    _players.clear();
    _isInitialized = false;
  }
}