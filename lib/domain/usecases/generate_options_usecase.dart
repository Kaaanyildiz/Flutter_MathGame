import 'dart:math';
import '../entities/game_state.dart';

class GenerateOptionsUseCase {
  GameState execute(GameState state) {
    if (state.correctAnswer == null) {
      return state;
    }
    
    final random = Random();
    final options = <int>[];
    
    // Doğru cevabı seçeneklere ekle
    options.add(state.correctAnswer!);
    
    // Yanlış seçenekleri oluştur
    while (options.length < 4) {
      int incorrectOption = state.correctAnswer! + random.nextInt(20) - 10;      // Negatif sayıları ve çok büyük sayıları engelle
      if (incorrectOption <= 0 || incorrectOption > 999) {
        continue;
      }
      
      // Aynı seçeneğin tekrarlanmasını önle
      if (options.contains(incorrectOption)) {
        continue;
      }
      
      options.add(incorrectOption);
    }
    
    // Seçenekleri karıştır
    options.shuffle();
    
    return state.copyWith(
      options: options,
      phase: GamePhase.waitingForAnswer,
    );
  }
}