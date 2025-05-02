import 'package:flutter/material.dart';
import '../controllers/game_controller.dart';
import '../widgets/game_options_widget.dart';
import '../widgets/game_info_widget.dart';
import '../widgets/number_display_widget.dart';

class GameScreen extends StatefulWidget {
  final GameController controller;

  const GameScreen({
    super.key,
    required this.controller,
  });

  @override
  State<GameScreen> createState() => GameScreenState();
}

class GameScreenState extends State<GameScreen> {
  late GameController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    // Listen to state changes
    _controller.addListener(() {
      if (mounted) setState(() {});
    });
    
    // Seviye değişimini dinle
    _controller.setOnLevelChangeListener((newLevel) {
      if (mounted) {
        _showLevelUpMessage(newLevel);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
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
        child: _controller.gameStarted
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GameInfoWidget(
                    score: _controller.score,
                    level: _controller.level,
                  ),
                  const SizedBox(height: 40),
                  if (_controller.currentNumberIndex < _controller.numbersToShow.length)
                    NumberDisplayWidget(
                      number: _controller.numbersToShow[_controller.currentNumberIndex],
                    )
                  else
                    GameOptionsWidget(
                      options: _controller.options,
                      onOptionSelected: (option) => _controller.checkAnswer(option),
                    ),
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
          'Seviye ${_controller.level} hazır mısınız?',
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

  void _showLevelUpMessage(int newLevel) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Tebrikler!'),
          content: Text('Seviye $newLevel hazır mısınız?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _controller.continueToNextLevel();
              },
              child: const Text('Devam'),
            ),
          ],
        );
      },
    );
  }
}