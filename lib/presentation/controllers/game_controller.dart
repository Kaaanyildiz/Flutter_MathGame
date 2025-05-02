import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import '../../domain/entities/game_state.dart';
import '../../domain/usecases/check_answer_usecase.dart';
import '../../domain/usecases/configure_level_usecase.dart';
import '../../domain/usecases/generate_options_usecase.dart';
import '../../domain/usecases/generate_question_usecase.dart';

class GameController extends ChangeNotifier {
  // Use Cases
  final GenerateQuestionUseCase _generateQuestionUseCase;
  final GenerateOptionsUseCase _generateOptionsUseCase;
  final CheckAnswerUseCase _checkAnswerUseCase;
  final ConfigureLevelUseCase _configureLevelUseCase;

  // Audio Players
  late AudioPlayer audioPlayerCorrect;
  late AudioPlayer audioPlayerIncorrect;

  // Game state
  GameState _gameState;
  Timer? _gameTimer;

  GameController({
    required GenerateQuestionUseCase generateQuestionUseCase,
    required GenerateOptionsUseCase generateOptionsUseCase,
    required CheckAnswerUseCase checkAnswerUseCase,
    required ConfigureLevelUseCase configureLevelUseCase,
  })  : _generateQuestionUseCase = generateQuestionUseCase,
        _generateOptionsUseCase = generateOptionsUseCase,
        _checkAnswerUseCase = checkAnswerUseCase,
        _configureLevelUseCase = configureLevelUseCase,
        _gameState = GameState(
          score: 0,
          level: 1,
          numbersToShow: [],
          options: [],
          currentAnswer: 0,
          currentNumberIndex: 0,
          gameStarted: false,
          displayDuration: 1000,
          timeLimit: 5,
        ) {
    _initAudio();
  }
  
  // Getters for state
  GameState get state => _gameState;
  bool get gameStarted => _gameState.gameStarted;
  int get score => _gameState.score;
  int get level => _gameState.level;
  int get currentNumberIndex => _gameState.currentNumberIndex;
  List<int> get numbersToShow => _gameState.numbersToShow;
  List<int> get options => _gameState.options;

  Future<void> _initAudio() async {
    audioPlayerCorrect = AudioPlayer();
    audioPlayerIncorrect = AudioPlayer();
    
    try {
      await audioPlayerCorrect.setAsset('assets/sounds/correct.mp3');
      await audioPlayerIncorrect.setAsset('assets/sounds/incorrect.mp3');
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Ses yüklenirken bir hata oluştu: $e');
      }
    }
  }

  void startGame() {
    _gameState = _gameState.copyWith(gameStarted: true);
    notifyListeners();
    startNewRound();
  }

  void startNewRound() {
    // Cancel existing timer if any
    _gameTimer?.cancel();
    
    // Configure level settings
    _gameState = _configureLevelUseCase.execute(_gameState);
    
    // Generate new question
    _gameState = _generateQuestionUseCase.execute(_gameState);
    
    // Reset current number index
    _gameState = _gameState.copyWith(currentNumberIndex: 0);
    
    notifyListeners();
    
    // Sayıları gösterme mantığını düzelt
    // Her bir sayı için gösterim süresini hesapla
    final int singleNumberDuration = _gameState.displayDuration ~/ _gameState.numbersToShow.length;
    
    // İlk sayıyı göster ve sonra zamanlayıcı başlat
    _showNumbersSequentially(singleNumberDuration);
  }
  
  void _showNumbersSequentially(int singleNumberDuration) {
    // Zamanlayıcıyı başlat
    _gameTimer = Timer.periodic(Duration(milliseconds: singleNumberDuration), (timer) {
      // Bir sonraki sayıya geç
      if (_gameState.currentNumberIndex < _gameState.numbersToShow.length - 1) {
        _gameState = _gameState.copyWith(
          currentNumberIndex: _gameState.currentNumberIndex + 1
        );
        notifyListeners();
      } else {
        // Son sayıya ulaştık
        timer.cancel();
        
        // Kısa bir bekleme süresi ekle ve ardından seçenekleri göster
        Timer(Duration(milliseconds: 500), () {
          // currentNumberIndex'i sayıların dışına taşıyarak seçeneklerin gösterilmesini sağla
          _gameState = _gameState.copyWith(
            currentNumberIndex: _gameState.numbersToShow.length
          );
          // Seçenekleri oluştur
          _gameState = _generateOptionsUseCase.execute(_gameState);
          notifyListeners();
        });
      }
    });
  }

  void showOptions() {
    _gameState = _generateOptionsUseCase.execute(_gameState);
    notifyListeners();
  }

  Future<void> checkAnswer(int selectedAnswer) async {
    if (selectedAnswer == _gameState.currentAnswer) {
      await audioPlayerCorrect.seek(Duration.zero);
      await audioPlayerCorrect.play();
      
      // Önceki seviyeyi sakla
      final int previousLevel = _gameState.level;
      
      // Cevabı kontrol et ve state'i güncelle
      GameState updatedState = _checkAnswerUseCase.execute(_gameState, selectedAnswer);
      _gameState = updatedState;
      
      notifyListeners();
      
      // Seviye değiştiyse seviye yükseltme bildirimi göster
      if (previousLevel != _gameState.level) {
        // Bildirim için bekle
        await Future.delayed(const Duration(milliseconds: 500));
        
        // Seviye değiştiğinde seviye bildirimini göster
        _onLevelChange?.call(_gameState.level);
        
        // Yeni tur otomatik başlamasın, kullanıcının onayını bekle
        return;
      }
      
      // Seviye değişmediyse normal şekilde devam et
      await Future.delayed(const Duration(milliseconds: 500));
      startNewRound();
    } else {
      await audioPlayerIncorrect.seek(Duration.zero);
      await audioPlayerIncorrect.play();
      
      _gameState = _checkAnswerUseCase.execute(_gameState, selectedAnswer);
      notifyListeners();
    }
  }
  
  // Seviye değişikliği bildirim callback'i
  Function(int)? _onLevelChange;
  
  // Seviye değişikliği dinleyicisi
  void setOnLevelChangeListener(Function(int) callback) {
    _onLevelChange = callback;
  }
  
  // Kullanıcı hazır olduğunda yeni turu başlat
  void continueToNextLevel() {
    startNewRound();
  }
  
  void resetGame() {
    _gameState = _gameState.copyWith(
      score: 0,
      level: 1,
      gameStarted: false,
    );
    notifyListeners();
  }
  
  @override
  void dispose() {
    _gameTimer?.cancel();
    audioPlayerCorrect.dispose();
    audioPlayerIncorrect.dispose();
    super.dispose();
  }
}