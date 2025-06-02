import '../entities/game_state.dart';
import '../../../core/constants/app_constants.dart';

class CheckAnswerUseCase {
  GameState execute(GameState state, int selectedAnswer) {
    if (state.correctAnswer == null) {
      return state;
    }
    
    final isCorrect = selectedAnswer == state.correctAnswer!;
    final now = DateTime.now();
    
    // Reaksiyon süresini hesapla
    Duration? reactionTime;
    if (state.lastAnswerTime != null) {
      reactionTime = now.difference(state.lastAnswerTime!);
    }
    
    // Streak hesaplama
    int newStreak = isCorrect ? state.streak + 1 : 0;
    int newMaxStreak = newStreak > state.maxStreak ? newStreak : state.maxStreak;
    
    // Skor hesaplama
    int scoreIncrease = 0;
    if (isCorrect) {
      scoreIncrease = AppConstants.baseScore * state.level;
      
      // Streak bonusu
      if (newStreak >= 3) {
        scoreIncrease = (scoreIncrease * (1 + (newStreak * 0.1))).round();
      }
      
      // Hız bonusu
      if (reactionTime != null && reactionTime.inSeconds < 3) {
        scoreIncrease = (scoreIncrease * 1.2).round();
      }
    }
    
    // İstatistikleri güncelle
    final newStatistics = state.statistics.copyWith(
      totalQuestions: state.statistics.totalQuestions + 1,
      correctAnswers: isCorrect 
          ? state.statistics.correctAnswers + 1 
          : state.statistics.correctAnswers,
      wrongAnswers: isCorrect 
          ? state.statistics.wrongAnswers 
          : state.statistics.wrongAnswers + 1,
    );
    
    // Seviye içi ilerleme
    final newQuestionsInLevel = state.questionsInCurrentLevel + 1;
    final newCorrectAnswersInLevel = isCorrect 
        ? state.correctAnswersInLevel + 1 
        : state.correctAnswersInLevel;
    
    // Seviye tamamlandı mı?
    bool levelCompleted = newQuestionsInLevel >= AppConstants.questionsPerLevel;
    GamePhase newPhase = levelCompleted 
        ? GamePhase.levelCompleted 
        : GamePhase.showingResult;
    
    return state.copyWith(
      selectedAnswer: selectedAnswer,
      isAnswerCorrect: isCorrect,
      score: state.score + scoreIncrease,
      questionsInCurrentLevel: newQuestionsInLevel,
      correctAnswersInLevel: newCorrectAnswersInLevel,
      statistics: newStatistics,
      lastAnswerTime: now,
      reactionTime: reactionTime,
      streak: newStreak,
      maxStreak: newMaxStreak,
      phase: newPhase,
    );
  }
}