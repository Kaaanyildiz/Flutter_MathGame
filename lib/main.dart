import 'package:flutter/material.dart';
import 'core/utils/audio_helper.dart';
import 'domain/usecases/check_answer_usecase.dart';
import 'domain/usecases/configure_level_usecase.dart';
import 'domain/usecases/generate_options_usecase.dart';
import 'domain/usecases/generate_question_usecase.dart';
import 'presentation/controllers/game_controller.dart';
import 'presentation/pages/game_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Ses yardımcı sınıfını başlat
  final audioHelper = AudioHelper();
  await audioHelper.init();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Matematik Oyunu',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: _buildHomeScreen(),
    );
  }

  Widget _buildHomeScreen() {
    // Use case'leri oluştur
    final generateQuestionUseCase = GenerateQuestionUseCase();
    final generateOptionsUseCase = GenerateOptionsUseCase();
    final checkAnswerUseCase = CheckAnswerUseCase();
    final configureLevelUseCase = ConfigureLevelUseCase();
    
    // Controller'ı oluştur
    final gameController = GameController(
      generateQuestionUseCase: generateQuestionUseCase,
      generateOptionsUseCase: generateOptionsUseCase,
      checkAnswerUseCase: checkAnswerUseCase,
      configureLevelUseCase: configureLevelUseCase,
    );
    
    // Ana oyun ekranını döndür
    return GameScreen(controller: gameController);
  }
}
