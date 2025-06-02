import '../../../core/constants/app_constants.dart';

enum GamePhase {
  initial,
  showingNumbers,
  waitingForAnswer,
  showingResult,
  levelCompleted,
  gameOver,
  paused,
}

enum DifficultyLevel {
  easy,
  medium,
  hard,
  expert,
}

class GameStatistics {
  final int correctAnswers;
  final int wrongAnswers;
  final int totalQuestions;
  final int perfectLevels;
  final Duration totalPlayTime;
  final Map<int, int> levelScores;

  const GameStatistics({
    required this.correctAnswers,
    required this.wrongAnswers,
    required this.totalQuestions,
    required this.perfectLevels,
    required this.totalPlayTime,
    required this.levelScores,
  });

  double get accuracy => totalQuestions > 0 ? correctAnswers / totalQuestions : 0.0;
  
  GameStatistics copyWith({
    int? correctAnswers,
    int? wrongAnswers,
    int? totalQuestions,
    int? perfectLevels,
    Duration? totalPlayTime,
    Map<int, int>? levelScores,
  }) {
    return GameStatistics(
      correctAnswers: correctAnswers ?? this.correctAnswers,
      wrongAnswers: wrongAnswers ?? this.wrongAnswers,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      perfectLevels: perfectLevels ?? this.perfectLevels,
      totalPlayTime: totalPlayTime ?? this.totalPlayTime,
      levelScores: levelScores ?? this.levelScores,
    );
  }
}

class GameState {
  final int score;
  final int level;
  final List<int> numbersToShow;
  final List<int> options;
  final int? correctAnswer;
  final int? selectedAnswer;
  final int currentNumberIndex;
  final GamePhase phase;
  final DifficultyLevel difficulty;
  final int questionsInCurrentLevel;
  final int correctAnswersInLevel;
  final bool isAnswerCorrect;
  final GameStatistics statistics;
  final DateTime? lastAnswerTime;
  final Duration? reactionTime;
  final bool soundEnabled;
  final int streak;
  final int maxStreak;

  const GameState({
    required this.score,
    required this.level,
    required this.numbersToShow,
    required this.options,
    this.correctAnswer,
    this.selectedAnswer,
    required this.currentNumberIndex,
    required this.phase,
    this.difficulty = DifficultyLevel.easy,
    this.questionsInCurrentLevel = 0,
    this.correctAnswersInLevel = 0,
    this.isAnswerCorrect = false,
    required this.statistics,
    this.lastAnswerTime,
    this.reactionTime,
    this.soundEnabled = true,
    this.streak = 0,
    this.maxStreak = 0,
  });

  // Helper getters
  bool get isGameActive => phase != GamePhase.initial && phase != GamePhase.gameOver;
  bool get isShowingNumbers => phase == GamePhase.showingNumbers;
  bool get isWaitingForAnswer => phase == GamePhase.waitingForAnswer;
  bool get isShowingResult => phase == GamePhase.showingResult;
  bool get isLevelCompleted => phase == GamePhase.levelCompleted;
  bool get isGameOver => phase == GamePhase.gameOver;
  bool get isPaused => phase == GamePhase.paused;
  
  int get numbersSum => numbersToShow.fold(0, (sum, number) => sum + number);
  int get remainingQuestions => AppConstants.questionsPerLevel - questionsInCurrentLevel;
  double get levelProgress => questionsInCurrentLevel / AppConstants.questionsPerLevel;
  bool get isPerfectLevel => correctAnswersInLevel == AppConstants.questionsPerLevel;
  
  // Difficulty calculations
  int get maxNumber {
    switch (difficulty) {
      case DifficultyLevel.easy:
        return 10 + (level * 2);
      case DifficultyLevel.medium:
        return 20 + (level * 3);
      case DifficultyLevel.hard:
        return 30 + (level * 4);
      case DifficultyLevel.expert:
        return 50 + (level * 5);
    }
  }
  
  int get numbersCount {
    switch (difficulty) {
      case DifficultyLevel.easy:
        return 2 + (level ~/ 3);
      case DifficultyLevel.medium:
        return 3 + (level ~/ 2);
      case DifficultyLevel.hard:
        return 4 + (level ~/ 2);
      case DifficultyLevel.expert:
        return 5 + (level ~/ 2);
    }
  }

  // Copy method
  GameState copyWith({
    int? score,
    int? level,
    List<int>? numbersToShow,
    List<int>? options,
    int? correctAnswer,
    int? selectedAnswer,
    int? currentNumberIndex,
    GamePhase? phase,
    DifficultyLevel? difficulty,
    int? questionsInCurrentLevel,
    int? correctAnswersInLevel,
    bool? isAnswerCorrect,
    GameStatistics? statistics,
    DateTime? lastAnswerTime,
    Duration? reactionTime,
    bool? soundEnabled,
    int? streak,
    int? maxStreak,
  }) {
    return GameState(
      score: score ?? this.score,
      level: level ?? this.level,
      numbersToShow: numbersToShow ?? this.numbersToShow,
      options: options ?? this.options,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      selectedAnswer: selectedAnswer ?? this.selectedAnswer,
      currentNumberIndex: currentNumberIndex ?? this.currentNumberIndex,
      phase: phase ?? this.phase,
      difficulty: difficulty ?? this.difficulty,
      questionsInCurrentLevel: questionsInCurrentLevel ?? this.questionsInCurrentLevel,
      correctAnswersInLevel: correctAnswersInLevel ?? this.correctAnswersInLevel,
      isAnswerCorrect: isAnswerCorrect ?? this.isAnswerCorrect,
      statistics: statistics ?? this.statistics,
      lastAnswerTime: lastAnswerTime ?? this.lastAnswerTime,
      reactionTime: reactionTime ?? this.reactionTime,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      streak: streak ?? this.streak,
      maxStreak: maxStreak ?? this.maxStreak,
    );
  }

  // Factory method for initial state
  factory GameState.initial() {
    return GameState(
      score: 0,
      level: 1,
      numbersToShow: [],
      options: [],
      currentNumberIndex: 0,
      phase: GamePhase.initial,
      statistics: const GameStatistics(
        correctAnswers: 0,
        wrongAnswers: 0,
        totalQuestions: 0,
        perfectLevels: 0,
        totalPlayTime: Duration.zero,
        levelScores: {},
      ),
    );
  }

  @override
  String toString() {
    return 'GameState(score: $score, level: $level, phase: $phase, '
           'questionsInLevel: $questionsInCurrentLevel, streak: $streak)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GameState &&
        other.score == score &&
        other.level == level &&
        other.phase == phase &&
        other.currentNumberIndex == currentNumberIndex;
  }
  @override
  int get hashCode {
    return score.hashCode ^ 
           level.hashCode ^ 
           phase.hashCode ^ 
           currentNumberIndex.hashCode;
  }
}