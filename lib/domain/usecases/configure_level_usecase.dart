import '../entities/game_state.dart';

class ConfigureLevelUseCase {
  GameState execute(GameState state) {
    int timeLimit;
    int displayDuration;
    
    switch (state.level) {
      case 1:
        timeLimit = 5;
        displayDuration = 4000;
        break;
      case 2:
        timeLimit = 4;
        displayDuration = 6500;
        break;
      case 3:
        timeLimit = 3;
        displayDuration = 8000;
        break;
      default:
        timeLimit = 3;
        displayDuration = 2000;
    }
    
    return state.copyWith(
      timeLimit: timeLimit,
      displayDuration: displayDuration,
    );
  }
}