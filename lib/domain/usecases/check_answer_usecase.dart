import '../entities/game_state.dart';

class CheckAnswerUseCase {
  GameState execute(GameState state, int selectedAnswer) {
    if (selectedAnswer == state.currentAnswer) {
      final newScore = state.score + 1;
      int newLevel = state.level;
      
      // Seviye yükseltme mantığı
      if (newLevel < 3) {
        newLevel++;
      }
      
      return state.copyWith(
        score: newScore,
        level: newLevel,
      );
    } else {
      // Yanlış cevap durumunda oyunu sıfırla
      return state.copyWith(
        gameStarted: false,
      );
    }
  }
}