import 'dart:math';
import '../entities/game_state.dart';

class GenerateOptionsUseCase {
  GameState execute(GameState state) {
    final random = Random();
    final options = <int>[];
    
    // Doğru cevabı seçeneklere ekle
    options.add(state.currentAnswer);
    
    // Yanlış seçenekleri oluştur
    while (options.length < 4) {
      int incorrectOption = state.currentAnswer + random.nextInt(10) - 5;
      // Aynı seçeneğin tekrarlanmasını önle
      if (!options.contains(incorrectOption) && incorrectOption > 0) {
        options.add(incorrectOption);
      }
    }
    
    // Seçenekleri karıştır
    options.shuffle();
    
    return state.copyWith(options: options);
  }
}