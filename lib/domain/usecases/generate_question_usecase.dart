import 'dart:math';
import '../entities/game_state.dart';

class GenerateQuestionUseCase {
  int? _lastGeneratedNumber;

  GameState execute(GameState state) {
    final random = Random();
    final numbersToShow = <int>[];
    
    // Mevcut state'den seviye ve zorluk bilgisini al
    final numbersCount = state.numbersCount;
    final maxNumber = state.maxNumber;
    
    // Sayıları üret
    for (int i = 0; i < numbersCount; i++) {
      numbersToShow.add(_generateUniqueNumber(random, 1, maxNumber));
    }

    // Doğru cevabı hesapla
    final correctAnswer = numbersToShow.reduce((a, b) => a + b);
    
    return state.copyWith(
      numbersToShow: numbersToShow,
      correctAnswer: correctAnswer,
      currentNumberIndex: 0,
      options: [],
      phase: GamePhase.showingNumbers,
    );
  }
  
  int _generateUniqueNumber(Random random, int min, int max) {
    int range = max - min + 1;
    int newNumber;
    
    if (range > 1) {
      do {
        newNumber = random.nextInt(range) + min;
      } while (newNumber == _lastGeneratedNumber);
    } else {
      newNumber = min;
    }
    
    _lastGeneratedNumber = newNumber;
    return newNumber;
  }
}