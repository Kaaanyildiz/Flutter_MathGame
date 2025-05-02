class GameState {
  final int score;
  final int level;
  final List<int> numbersToShow;
  final List<int> options;
  final int currentAnswer;
  final int currentNumberIndex;
  final bool gameStarted;
  final int displayDuration;
  final int timeLimit;

  const GameState({
    required this.score,
    required this.level,
    required this.numbersToShow,
    required this.options,
    required this.currentAnswer,
    required this.currentNumberIndex,
    required this.gameStarted,
    required this.displayDuration,
    required this.timeLimit,
  });

  // Nesneyi güncellemek için kopya oluşturma metodu
  GameState copyWith({
    int? score,
    int? level,
    List<int>? numbersToShow,
    List<int>? options,
    int? currentAnswer,
    int? currentNumberIndex,
    bool? gameStarted,
    int? displayDuration,
    int? timeLimit,
  }) {
    return GameState(
      score: score ?? this.score,
      level: level ?? this.level,
      numbersToShow: numbersToShow ?? this.numbersToShow,
      options: options ?? this.options,
      currentAnswer: currentAnswer ?? this.currentAnswer,
      currentNumberIndex: currentNumberIndex ?? this.currentNumberIndex,
      gameStarted: gameStarted ?? this.gameStarted,
      displayDuration: displayDuration ?? this.displayDuration,
      timeLimit: timeLimit ?? this.timeLimit,
    );
  }
}