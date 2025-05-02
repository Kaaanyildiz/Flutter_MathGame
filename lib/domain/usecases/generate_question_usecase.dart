import 'dart:math';
import '../entities/game_state.dart';

class GenerateQuestionUseCase {
  // Son oluşturulan sayıyı takip etmek için
  int? _lastGeneratedNumber;

  GameState execute(GameState state) {
    final random = Random();
    final numbersToShow = <int>[];
    
    switch (state.level) {
      case 1:
        for (int i = 0; i < 5; i++) {
          numbersToShow.add(_generateUniqueNumber(random, 1, 10));
        }
        break;
      case 2:
        for (int i = 0; i < 6; i++) {
          numbersToShow.add(_generateUniqueNumber(random, 5, 20));
        }
        break;
      default:
        for (int i = 0; i < 8; i++) {
          numbersToShow.add(_generateUniqueNumber(random, 10, 50));
        }
    }

    final currentAnswer = numbersToShow.reduce((a, b) => a + b);
    
    return state.copyWith(
      numbersToShow: numbersToShow,
      currentAnswer: currentAnswer,
      currentNumberIndex: 0,
      options: [],
    );
  }
  
  // Bir önceki sayıdan farklı benzersiz bir sayı üretir
  int _generateUniqueNumber(Random random, int min, int max) {
    int range = max - min + 1;
    int newNumber;
    
    // Eğer aralık 1'den büyükse, farklı bir sayı üret
    if (range > 1) {
      do {
        newNumber = random.nextInt(range) + min;
      } while (newNumber == _lastGeneratedNumber);
    } else {
      // Aralık çok küçükse (1 ise) bir sayı üret
      newNumber = min;
    }
    
    // Son üretilen sayıyı sakla
    _lastGeneratedNumber = newNumber;
    return newNumber;
  }
}