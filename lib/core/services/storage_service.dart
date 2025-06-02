import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

class StorageService {
  static StorageService? _instance;
  static SharedPreferences? _preferences;

  StorageService._internal();

  static StorageService get instance {
    _instance ??= StorageService._internal();
    return _instance!;
  }

  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  // High Score Management
  Future<int> getHighScore() async {
    return _preferences?.getInt(AppConstants.highScoreKey) ?? 0;
  }

  Future<void> setHighScore(int score) async {
    await _preferences?.setInt(AppConstants.highScoreKey, score);
  }

  Future<bool> checkAndUpdateHighScore(int newScore) async {
    final currentHighScore = await getHighScore();
    if (newScore > currentHighScore) {
      await setHighScore(newScore);
      return true; // New high score achieved
    }
    return false;
  }

  // Current Level Management
  Future<int> getCurrentLevel() async {
    return _preferences?.getInt(AppConstants.currentLevelKey) ?? 1;
  }

  Future<void> setCurrentLevel(int level) async {
    await _preferences?.setInt(AppConstants.currentLevelKey, level);
  }

  // Sound Settings
  Future<bool> isSoundEnabled() async {
    return _preferences?.getBool(AppConstants.soundEnabledKey) ?? true;
  }

  Future<void> setSoundEnabled(bool enabled) async {
    await _preferences?.setBool(AppConstants.soundEnabledKey, enabled);
  }

  // Games Played Statistics
  Future<int> getGamesPlayed() async {
    return _preferences?.getInt(AppConstants.gamesPlayedKey) ?? 0;
  }

  Future<void> incrementGamesPlayed() async {
    final current = await getGamesPlayed();
    await _preferences?.setInt(AppConstants.gamesPlayedKey, current + 1);
  }

  // Game Statistics
  Future<Map<String, dynamic>> getGameStatistics() async {
    return {
      'highScore': await getHighScore(),
      'currentLevel': await getCurrentLevel(),
      'gamesPlayed': await getGamesPlayed(),
      'soundEnabled': await isSoundEnabled(),
    };
  }

  // Reset all data
  Future<void> resetAllData() async {
    await _preferences?.clear();
  }

  // Backup and restore
  Future<Map<String, dynamic>> exportData() async {
    return {
      AppConstants.highScoreKey: await getHighScore(),
      AppConstants.currentLevelKey: await getCurrentLevel(),
      AppConstants.soundEnabledKey: await isSoundEnabled(),
      AppConstants.gamesPlayedKey: await getGamesPlayed(),
    };
  }

  Future<void> importData(Map<String, dynamic> data) async {
    for (final entry in data.entries) {
      if (entry.value is int) {
        await _preferences?.setInt(entry.key, entry.value);
      } else if (entry.value is bool) {
        await _preferences?.setBool(entry.key, entry.value);
      } else if (entry.value is String) {
        await _preferences?.setString(entry.key, entry.value);
      }
    }
  }
}
