import '../entities/game_state.dart';

class ConfigureLevelUseCase {
  GameState execute(GameState state, int newLevel) {
    // Yeni seviyeye geçerken istatistikleri güncelle
    var newStatistics = state.statistics;
    
    // Eğer önceki seviye mükemmeldi, bunu kaydet
    if (state.isPerfectLevel && state.level > 0) {
      newStatistics = newStatistics.copyWith(
        perfectLevels: newStatistics.perfectLevels + 1,
        levelScores: {
          ...newStatistics.levelScores,
          state.level: state.score,
        },
      );
    }
    
    return state.copyWith(
      level: newLevel,
      questionsInCurrentLevel: 0,
      correctAnswersInLevel: 0,
      statistics: newStatistics,
      phase: GamePhase.initial,
      numbersToShow: [],
      options: [],
      correctAnswer: null,
      selectedAnswer: null,
      isAnswerCorrect: false,
    );
  }
  
  // Seviye ayarlarını al
  static int getTimeLimit(int level) {
    if (level <= 3) return 10 - level;
    if (level <= 6) return 7 - (level - 3);
    return 3;
  }
  
  static int getDisplayDuration(int level) {
    if (level <= 3) return 3000 + (level * 500);
    if (level <= 6) return 4500 + ((level - 3) * 1000);
    return 8000;
  }
}