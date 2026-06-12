import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/home_screen.dart';
import 'services/audio_service.dart';
import 'services/question_repository.dart';
import 'services/storage_service.dart';
import 'state/game_controller.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const QuizGospelApp());
}

class QuizGospelApp extends StatefulWidget {
  const QuizGospelApp({super.key});

  @override
  State<QuizGospelApp> createState() => _QuizGospelAppState();
}

class _QuizGospelAppState extends State<QuizGospelApp> {
  late final AudioService _audio = AudioService();
  late final StorageService _storage = StorageService();
  late final QuestionRepository _repository = QuestionRepository();
  late final GameController _game = GameController(
    repository: _repository,
    audio: _audio,
    storage: _storage,
  )..init();

  @override
  void dispose() {
    _game.dispose();
    _audio.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AudioService>.value(value: _audio),
        Provider<StorageService>.value(value: _storage),
        ChangeNotifierProvider<GameController>.value(value: _game),
      ],
      child: MaterialApp(
        title: 'Quiz Gospel do Milhão',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const HomeScreen(),
      ),
    );
  }
}
