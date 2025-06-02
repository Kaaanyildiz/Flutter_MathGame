import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controllers/game_controller.dart';
import '../widgets/game_options_widget.dart';
import '../widgets/game_info_widget.dart';
import '../widgets/number_display_widget.dart';
import '../../core/utils/responsive_helper.dart';
import '../../core/utils/animation_helper.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => GameScreenState();
}

class GameScreenState extends State<GameScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Matematik Oyunu'),
        backgroundColor: Colors.cyan,
      ),
      backgroundColor: Colors.blueGrey,
      body: Center(
        child: _controller.isGameActive
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GameInfoWidget(
                    score: _controller.state.score,
                    level: _controller.state.level,
                  ),
                  const SizedBox(height: 40),
                  if (_controller.isShowingNumbers)
                    NumberDisplayWidget(
                      number: _controller.state.numbersToShow.isNotEmpty && 
                              _controller.state.currentNumberIndex < _controller.state.numbersToShow.length
                          ? _controller.state.numbersToShow[_controller.state.currentNumberIndex]
                          : 0,
                    )
                  else if (_controller.isWaitingForAnswer)
                    GameOptionsWidget(
                      options: _controller.state.options,
                      onOptionSelected: (option) => _controller.selectAnswer(option),
                    )
                  else if (_controller.isLevelCompleted)
                    _buildLevelCompletedWidget()
                  else if (_controller.isShowingResult)
                    _buildResultWidget(),
                ],
              )
            : _buildStartScreen(),
      ),
    );
  }
  Widget _buildStartScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Seviye ${_controller.state.level} hazır mısınız?',
          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _controller.startGame,
          child: const Text('Başla', style: TextStyle(fontSize: 24)),
        ),
      ],
    );
  }

  Widget _buildResultWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          _controller.state.isAnswerCorrect ? Icons.check_circle : Icons.cancel,
          color: _controller.state.isAnswerCorrect ? Colors.green : Colors.red,
          size: 100,
        ),
        const SizedBox(height: 20),
        Text(
          _controller.state.isAnswerCorrect ? 'Doğru!' : 'Yanlış!',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: _controller.state.isAnswerCorrect ? Colors.green : Colors.red,
          ),
        ),
        if (!_controller.state.isAnswerCorrect && _controller.state.correctAnswer != null)
          Text(
            'Doğru cevap: ${_controller.state.correctAnswer}',
            style: const TextStyle(fontSize: 24),
          ),
      ],
    );
  }

  Widget _buildLevelCompletedWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.emoji_events,
          color: Colors.yellow,
          size: 100,
        ),
        const SizedBox(height: 20),
        Text(
          'Seviye ${_controller.state.level} Tamamlandı!',
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.yellow,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Skor: ${_controller.state.score}',
          style: const TextStyle(fontSize: 24),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _controller.nextLevel,
          child: const Text('Sonraki Seviye', style: TextStyle(fontSize: 20)),
        ),
      ],
    );
  }
}