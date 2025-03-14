import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Matematik Oyunu',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int score = 0;
  int level = 1;
  int currentAnswer = 0;
  List<int> options = [];
  int selectedAnswer = -1;
  late Timer gameTimer;
  late int timeLimit;
  bool gameStarted = false;
  List<int> numbersToShow = [];
  int currentNumberIndex = 0;
  int displayDuration = 1000;

  late AudioPlayer audioPlayerCorrect;
  late AudioPlayer audioPlayerIncorrect;

  @override
  void initState() {
    super.initState();
    audioPlayerCorrect = AudioPlayer();
    audioPlayerIncorrect = AudioPlayer();

    // Ses dosyalarını yükle
    loadSounds();
  }

  Future<void> loadSounds() async {
    try {
      await audioPlayerCorrect.setAsset('assets/sounds/correct.mp3');
      await audioPlayerIncorrect.setAsset('assets/sounds/incorrect.mp3');
      print('Sesler yüklendi');
    } catch (e) {
      print('Ses yüklenirken bir hata oluştu: $e');
    }
  }

  @override
  void dispose() {
    gameTimer.cancel();
    audioPlayerCorrect.dispose();
    audioPlayerIncorrect.dispose();
    super.dispose();
  }

  void playSound(String sound) async {
    if (sound == "correct") {
      await audioPlayerCorrect.seek(Duration.zero);
      await audioPlayerCorrect.play();
    } else if (sound == "incorrect") {
      await audioPlayerIncorrect.seek(Duration.zero);
      await audioPlayerIncorrect.play();
    }
  }

  void startGame() {
    setState(() {
      gameStarted = true;
    });
    startNewRound();
  }

  void startNewRound() {
    currentNumberIndex = 0;
    numbersToShow.clear();

    switch (level) {
      case 1:
        timeLimit = 5;
        displayDuration = 1000;
        break;
      case 2:
        timeLimit = 4;
        displayDuration = 1500;
        break;
      case 3:
        timeLimit = 3;
        displayDuration = 2000;
        break;
      default:
        timeLimit = 3;
        displayDuration = 2000;
    }

    generateQuestion();

    gameTimer = Timer.periodic(Duration(milliseconds: displayDuration), (timer) {
      setState(() {
        if (currentNumberIndex < numbersToShow.length) {
          currentNumberIndex++;
        } else {
          timer.cancel();
          showOptions();
        }
      });
    });
  }

  void generateQuestion() {
    Random random = Random();
    numbersToShow.clear();

    if (level == 1) {
      for (int i = 0; i < 5; i++) {
        numbersToShow.add(random.nextInt(10) + 1);
      }
    } else if (level == 2) {
      for (int i = 0; i < 6; i++) {
        numbersToShow.add(random.nextInt(16) + 5);
      }
    } else {
      for (int i = 0; i < 8; i++) {
        numbersToShow.add(random.nextInt(41) + 10);
      }
    }
    currentAnswer = numbersToShow.reduce((a, b) => a + b);
  }

  void showOptions() {
    Random random = Random();
    options.clear();
    options.add(currentAnswer);

    while (options.length < 4) {
      int incorrectOption = currentAnswer + random.nextInt(10) - 5;
      if (!options.contains(incorrectOption)) {
        options.add(incorrectOption);
      }
    }

    options.shuffle();
    setState(() {
      selectedAnswer = -1;
    });
  }

  void checkAnswer(int answer) {
    if (answer == currentAnswer) {
      playSound("correct");
      setState(() {
        score++;
        if (level < 3) {
          level++;
          showLevelUpMessage();
        } else {
          showGameCompletionDialog();
        }
      });
    } else {
      playSound("incorrect");
      setState(() {
        gameStarted = false;
      });
    }
  }

  void showLevelUpMessage() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Tebrikler!'),
          content: Text('Seviye $level hazır mısınız?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  gameStarted = false;
                });
              },
              child: Text('Devam'),
            ),
          ],
        );
      },
    );
  }

  void showGameCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Tebrikler!'),
          content: Text('Tüm seviyeleri tamamladınız. Puanınız: $score'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                resetGame();
              },
              child: Text('Yeniden Başla'),
            ),
          ],
        );
      },
    );
  }

  void resetGame() {
    setState(() {
      score = 0;
      level = 1;
      gameStarted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Matematik Oyunu'),
        backgroundColor: Colors.cyan,
      ),
      backgroundColor: Colors.blueGrey,
      body: Center(
        child: gameStarted
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Puan: $score', style: TextStyle(fontSize: 24)),
                  SizedBox(height: 20),
                  Text('Seviye: $level', style: TextStyle(fontSize: 24)),
                  SizedBox(height: 40),
                  if (currentNumberIndex < numbersToShow.length)
                    Text(
                      'Sayı: ${numbersToShow[currentNumberIndex]}',
                      style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                    )
                  else
                    Column(
                      children: options.map((option) {
                        return ElevatedButton(
                          onPressed: () {
                            checkAnswer(option);
                          },
                          child: Text(option.toString()),
                        );
                      }).toList(),
                    ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Seviye $level hazır mısınız?',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: startGame,
                    child: Text('Başla', style: TextStyle(fontSize: 24)),
                  ),
                ],
              ),
      ),
    );
  }
}
