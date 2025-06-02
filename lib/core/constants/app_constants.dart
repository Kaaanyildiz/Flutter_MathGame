class AppConstants {
  // Game configuration
  static const int maxLevel = 10;
  static const int questionsPerLevel = 5;
  static const int optionsCount = 4;
  static const int maxNumberRange = 100;
  static const int minNumberRange = 1;
  
  // Timing configuration
  static const Duration questionDisplayDuration = Duration(milliseconds: 800);
  static const Duration numberDisplayInterval = Duration(milliseconds: 1000);
  static const Duration answerFeedbackDuration = Duration(milliseconds: 1500);
  static const Duration levelTransitionDuration = Duration(milliseconds: 2000);
    // Scoring
  static const int baseScore = 10;
  static const int correctAnswerPoints = 10;
  static const int levelCompletionBonus = 50;
  static const int perfectLevelBonus = 100;
  
  // Audio
  static const String correctSoundPath = 'assets/sounds/correct.mp3';
  static const String wrongSoundPath = 'assets/sounds/wrong.mp3';
  static const String levelUpSoundPath = 'assets/sounds/level_up.mp3';
  static const String gameOverSoundPath = 'assets/sounds/game_over.mp3';
  
  // SharedPreferences keys
  static const String highScoreKey = 'high_score';
  static const String currentLevelKey = 'current_level';
  static const String soundEnabledKey = 'sound_enabled';
  static const String gamesPlayedKey = 'games_played';
  
  // UI Configuration
  static const double defaultPadding = 16.0;
  static const double largePadding = 24.0;
  static const double smallPadding = 8.0;
  static const double defaultBorderRadius = 16.0;
  static const double largeBorderRadius = 24.0;
  static const double buttonHeight = 56.0;
  static const double cardElevation = 8.0;
  
  // Responsive breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;
  
  // Animation constants
  static const double scaleAnimationValue = 1.2;
  static const Duration bounceAnimationDuration = Duration(milliseconds: 600);
  static const Duration slideAnimationDuration = Duration(milliseconds: 400);
  static const Duration fadeAnimationDuration = Duration(milliseconds: 300);
}

class AppStrings {
  // Game UI
  static const String appTitle = 'Math Game';
  static const String score = 'Skor';
  static const String level = 'Seviye';
  static const String question = 'Soru';
  static const String nextLevel = 'Sonraki Seviye';
  static const String gameOver = 'Oyun Bitti';
  static const String wellDone = 'Aferin!';
  static const String tryAgain = 'Tekrar Dene';
  static const String continue_ = 'Devam Et';
  static const String newGame = 'Yeni Oyun';
  static const String pause = 'Duraklat';
  static const String resume = 'Devam Et';
  
  // Instructions
  static const String gameInstruction = 'Gösterilen sayıları hatırlayın ve toplamları bulun!';
  static const String levelCompleted = 'Seviye Tamamlandı!';
  static const String perfectLevel = 'Mükemmel Performans!';
  static const String goodJob = 'İyi İş Çıkardın!';
  
  // Settings
  static const String settings = 'Ayarlar';
  static const String soundEnabled = 'Ses Açık';
  static const String highScore = 'En Yüksek Skor';
  static const String statistics = 'İstatistikler';
  static const String gamesPlayed = 'Oynanan Oyun';
  
  // Errors
  static const String audioError = 'Ses çalma hatası';
  static const String saveError = 'Kaydetme hatası';
  static const String loadError = 'Yükleme hatası';
}
