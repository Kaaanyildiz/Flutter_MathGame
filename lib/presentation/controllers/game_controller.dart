import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../../core/services/storage_service.dart';
import '../../core/utils/audio_helper.dart';
import '../../core/constants/app_constants.dart';
import '../../domain/entities/game_state.dart';
import '../../domain/usecases/check_answer_usecase.dart';
import '../../domain/usecases/configure_level_usecase.dart';
import '../../domain/usecases/generate_options_usecase.dart';
import '../../domain/usecases/generate_question_usecase.dart';

class GameController extends ChangeNotifier {
  // Dependencies
  final GenerateQuestionUseCase _generateQuestionUseCase;
  final GenerateOptionsUseCase _generateOptionsUseCase;
  final CheckAnswerUseCase _checkAnswerUseCase;
  final ConfigureLevelUseCase _configureLevelUseCase;
  final AudioHelper _audioHelper;
  final StorageService _storageService;

  // Game state
  GameState _gameState = GameState.initial();
  Timer? _numberDisplayTimer;
  Timer? _answerFeedbackTimer;
  DateTime? _questionStartTime;

  GameController({
    required GenerateQuestionUseCase generateQuestionUseCase,
    required GenerateOptionsUseCase generateOptionsUseCase,
    required CheckAnswerUseCase checkAnswerUseCase,
    required ConfigureLevelUseCase configureLevelUseCase,
    required AudioHelper audioHelper,
    required StorageService storageService,
  })  : _generateQuestionUseCase = generateQuestionUseCase,
        _generateOptionsUseCase = generateOptionsUseCase,
        _checkAnswerUseCase = checkAnswerUseCase,
        _configureLevelUseCase = configureLevelUseCase,
        _audioHelper = audioHelper,
        _storageService = storageService {
    _initializeGame();
  }

  // Getters
  GameState get state => _gameState;
  bool get isGameActive => _gameState.isGameActive;
  bool get isShowingNumbers => _gameState.isShowingNumbers;
  bool get isWaitingForAnswer => _gameState.isWaitingForAnswer;
  bool get isShowingResult => _gameState.isShowingResult;
  bool get isLevelCompleted => _gameState.isLevelCompleted;
  bool get isGameOver => _gameState.isGameOver;
  bool get isPaused => _gameState.isPaused;

  Future<void> _initializeGame() async {
    try {
      final savedLevel = await _storageService.getCurrentLevel();
      final soundEnabled = await _storageService.isSoundEnabled();
      final statistics = await _loadStatistics();
      
      _gameState = _gameState.copyWith(
        level: savedLevel,
        soundEnabled: soundEnabled,
        statistics: statistics,
      );
      
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('GameController: Oyun başlatılırken hata: $e');
      }
    }
  }

  Future<GameStatistics> _loadStatistics() async {
    try {
      final stats = await _storageService.getGameStatistics();
      return GameStatistics(
        correctAnswers: stats['correctAnswers'] ?? 0,
        wrongAnswers: stats['wrongAnswers'] ?? 0,
        totalQuestions: stats['totalQuestions'] ?? 0,
        perfectLevels: stats['perfectLevels'] ?? 0,
        totalPlayTime: Duration(seconds: stats['totalPlayTime'] ?? 0),
        levelScores: Map<int, int>.from(stats['levelScores'] ?? {}),
      );
    } catch (e) {
      return const GameStatistics(
        correctAnswers: 0,
        wrongAnswers: 0,
        totalQuestions: 0,
        perfectLevels: 0,
        totalPlayTime: Duration.zero,
        levelScores: {},
      );
    }
  }

  void startGame() async {
    try {
      await _storageService.incrementGamesPlayed();
      _gameState = _gameState.copyWith(
        phase: GamePhase.showingNumbers,
        questionsInCurrentLevel: 0,
        correctAnswersInLevel: 0,
        streak: 0,
      );
      notifyListeners();
      
      await _generateNewQuestion();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('GameController: Oyun başlatılırken hata: $e');
      }
    }
  }
  Future<void> _generateNewQuestion() async {
    try {
      // Use case ile yeni soru oluştur
      _gameState = _generateQuestionUseCase.execute(_gameState);
      
      // Seçenekleri oluştur
      _gameState = _generateOptionsUseCase.execute(_gameState);
      
      notifyListeners();
      
      await _startNumberDisplay();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('GameController: Soru oluşturulurken hata: $e');
      }
    }
  }

  Future<void> _startNumberDisplay() async {
    _questionStartTime = DateTime.now();
    
    _numberDisplayTimer?.cancel();
    _numberDisplayTimer = Timer.periodic(
      AppConstants.numberDisplayInterval,
      (timer) async {
        if (_gameState.currentNumberIndex < _gameState.numbersToShow.length - 1) {
          _gameState = _gameState.copyWith(
            currentNumberIndex: _gameState.currentNumberIndex + 1,
          );
          notifyListeners();
        } else {
          timer.cancel();
          await _finishNumberDisplay();
        }
      },
    );
  }

  Future<void> _finishNumberDisplay() async {
    _gameState = _gameState.copyWith(
      phase: GamePhase.waitingForAnswer,
      currentNumberIndex: 0,
    );
    notifyListeners();
  }
  Future<void> selectAnswer(int selectedAnswer) async {
    if (!_gameState.isWaitingForAnswer) return;

    // Use case ile cevabı kontrol et ve state'i güncelle
    _gameState = _checkAnswerUseCase.execute(_gameState, selectedAnswer);

    // Calculate reaction time
    if (_questionStartTime != null) {
      final reactionTime = DateTime.now().difference(_questionStartTime!);
      _gameState = _gameState.copyWith(reactionTime: reactionTime);
    }

    // Play sound feedback
    await _playAudioFeedback(_gameState.isAnswerCorrect);

    notifyListeners();

    // Show feedback for a moment then proceed
    _answerFeedbackTimer = Timer(AppConstants.answerFeedbackDuration, () {
      _proceedAfterAnswer();    });
  }

  Future<void> _playAudioFeedback(bool isCorrect) async {
    try {
      if (isCorrect) {
        await _audioHelper.playSound(SoundType.correct);
      } else {
        await _audioHelper.playSound(SoundType.incorrect);
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('GameController: Ses çalınırken hata: $e');
      }
    }
  }

  void _proceedAfterAnswer() {
    if (_gameState.questionsInCurrentLevel >= AppConstants.questionsPerLevel) {
      _completeLevel();
    } else {
      _generateNewQuestion();
    }
  }

  void _completeLevel() async {
    // Calculate level bonus
    int levelBonus = AppConstants.levelCompletionBonus;
    if (_gameState.isPerfectLevel) {
      levelBonus += AppConstants.perfectLevelBonus;
    }

    final newScore = _gameState.score + levelBonus;
    
    // Update statistics
    final updatedStatistics = _gameState.statistics.copyWith(
      perfectLevels: _gameState.isPerfectLevel 
          ? _gameState.statistics.perfectLevels + 1 
          : _gameState.statistics.perfectLevels,
      levelScores: {
        ..._gameState.statistics.levelScores,
        _gameState.level: newScore,
      },
    );

    _gameState = _gameState.copyWith(
      score: newScore,
      phase: GamePhase.levelCompleted,
      statistics: updatedStatistics,
    );

    // Save progress
    await _storageService.setCurrentLevel(_gameState.level + 1);
    await _audioHelper.playSound(SoundType.levelUp);

    notifyListeners();
  }
  void nextLevel() {
    if (_gameState.level >= AppConstants.maxLevel) {
      _endGame();
    } else {
      // Configure next level using use case
      final nextLevelNumber = _gameState.level + 1;
      _gameState = _configureLevelUseCase.execute(_gameState, nextLevelNumber);
      
      notifyListeners();
      _generateNewQuestion();
    }
  }

  void _endGame() async {
    _gameState = _gameState.copyWith(
      phase: GamePhase.gameOver,
    );

    await _audioHelper.playSound(SoundType.gameOver);
    notifyListeners();
  }

  void restartGame() {
    _clearTimers();
    _gameState = GameState.initial().copyWith(
      soundEnabled: _gameState.soundEnabled,
      statistics: _gameState.statistics,
    );
    notifyListeners();
  }

  void pauseGame() {
    if (_gameState.isGameActive) {
      _numberDisplayTimer?.cancel();
      _answerFeedbackTimer?.cancel();
      
      _gameState = _gameState.copyWith(
        phase: GamePhase.paused,
      );
      notifyListeners();
    }
  }

  void resumeGame() {
    if (_gameState.isPaused) {
      _gameState = _gameState.copyWith(
        phase: GamePhase.waitingForAnswer,
      );
      notifyListeners();
    }
  }

  void toggleSound() async {
    final newSoundState = !_gameState.soundEnabled;
    await _storageService.setSoundEnabled(newSoundState);
    
    _gameState = _gameState.copyWith(
      soundEnabled: newSoundState,
    );
    notifyListeners();
  }

  void _clearTimers() {
    _numberDisplayTimer?.cancel();
    _answerFeedbackTimer?.cancel();
    _numberDisplayTimer = null;
    _answerFeedbackTimer = null;
  }

  @override
  void dispose() {
    _clearTimers();
    super.dispose();
  }
}