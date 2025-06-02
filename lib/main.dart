import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';

import 'core/services/storage_service.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/audio_helper.dart';
import 'core/constants/app_constants.dart';
import 'domain/usecases/check_answer_usecase.dart';
import 'domain/usecases/configure_level_usecase.dart';
import 'domain/usecases/generate_options_usecase.dart';
import 'domain/usecases/generate_question_usecase.dart';
import 'presentation/controllers/game_controller.dart';
import 'presentation/pages/game_screen.dart';

final GetIt getIt = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Initialize services
  await _initializeServices();
  
  // Setup dependency injection
  _setupDependencyInjection();
  
  runApp(const MyApp());
}

Future<void> _initializeServices() async {
  // Initialize storage service
  await StorageService.init();
  
  // Initialize audio helper
  final audioHelper = AudioHelper();
  await audioHelper.init();
  
  // Register singletons
  getIt.registerSingleton<AudioHelper>(audioHelper);
  getIt.registerSingleton<StorageService>(StorageService.instance);
}

void _setupDependencyInjection() {
  // Register use cases
  getIt.registerLazySingleton<GenerateQuestionUseCase>(
    () => GenerateQuestionUseCase(),
  );
  getIt.registerLazySingleton<GenerateOptionsUseCase>(
    () => GenerateOptionsUseCase(),
  );
  getIt.registerLazySingleton<CheckAnswerUseCase>(
    () => CheckAnswerUseCase(),
  );
  getIt.registerLazySingleton<ConfigureLevelUseCase>(
    () => ConfigureLevelUseCase(),
  );
  
  // Register controller
  getIt.registerFactory<GameController>(
    () => GameController(
      generateQuestionUseCase: getIt<GenerateQuestionUseCase>(),
      generateOptionsUseCase: getIt<GenerateOptionsUseCase>(),
      checkAnswerUseCase: getIt<CheckAnswerUseCase>(),
      configureLevelUseCase: getIt<ConfigureLevelUseCase>(),
      audioHelper: getIt<AudioHelper>(),
      storageService: getIt<StorageService>(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // iPhone 13 design size
      minTextAdapt: true,
      splitScreenMode: true,
      useInheritedMediaQuery: true,
      builder: (context, child) {
        return MaterialApp(
          title: AppStrings.appTitle,
          theme: AppTheme.lightTheme,
          debugShowCheckedModeBanner: false,
          builder: (context, widget) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: const TextScaler.linear(1.0), // Prevent system text scaling
              ),
              child: widget!,
            );        },
          home: ChangeNotifierProvider<GameController>(
            create: (_) => getIt<GameController>(),
            child: Consumer<GameController>(
              builder: (context, controller, child) {
                return GameScreen(controller: controller);
              },
            ),
          ),
        );
      },
    );
  }
}
