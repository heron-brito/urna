import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';

import '../models/prize_ladder.dart';
import '../models/question.dart';
import '../services/audio_service.dart';
import '../services/question_repository.dart';
import '../services/storage_service.dart';

/// Fases possíveis de uma partida.
enum GamePhase {
  loading,
  playing, // pergunta no ar, aguardando resposta
  feedback, // mostrando se acertou/errou antes de avançar
  won, // chegou a 1.000.000 de coins
  lost, // errou ou tempo esgotou
  stopped, // parou e levou os coins garantidos
}

/// Ajudas disponíveis na partida (estilo "cartas" do Show do Milhão).
enum Lifeline { fiftyFifty, audience, skip }

/// Controla todo o fluxo do "Quiz Gospel do Milhão".
class GameController extends ChangeNotifier {
  final QuestionRepository repository;
  final AudioService audio;
  final StorageService storage;

  GameController({
    required this.repository,
    required this.audio,
    required this.storage,
  });

  // ---- Estado público ----
  GamePhase phase = GamePhase.loading;
  int stepIndex = 0; // degrau atual (0-based)
  Question? question;
  int? selectedIndex;
  bool lastAnswerCorrect = false;

  /// Coins garantidos caso o jogador pare agora (valor do último acerto).
  int coins = 0;

  /// Resultado final consolidado (preenchido ao terminar).
  int finalCoins = 0;
  bool wonBook = false;

  int bestCoins = 0;

  // Ajudas (cada uma só pode ser usada uma vez por partida).
  final Set<Lifeline> _usedLifelines = {};
  final Set<int> _eliminated = {}; // índices removidos pelo 50/50
  int? audienceSuggestion; // índice sugerido pela "plateia"

  // Timer por pergunta.
  static const int _timePerQuestion = 30;
  int secondsLeft = _timePerQuestion;
  Timer? _timer;

  final Set<int> _usedQuestionIds = {};
  final Random _random = Random();

  // ---- Getters auxiliares ----
  int get totalSteps => PrizeLadder.totalSteps;
  PrizeStep get currentStep => PrizeLadder.steps[stepIndex];
  Set<int> get eliminated => _eliminated;
  bool isLifelineUsed(Lifeline l) => _usedLifelines.contains(l);
  bool get isOver =>
      phase == GamePhase.won ||
      phase == GamePhase.lost ||
      phase == GamePhase.stopped;

  /// Coins que o jogador garante (não perde mais) se errar a pergunta atual.
  int get safeNetCoins => PrizeLadder.guaranteedCoinsAt(stepIndex);

  // ---- Ciclo de vida ----
  Future<void> init() async {
    await repository.load();
    bestCoins = await storage.bestCoins();
    audio.muted = await storage.isMuted();
    notifyListeners();
  }

  Future<void> startGame() async {
    if (!repository.isLoaded) {
      await repository.load();
    }
    stepIndex = 0;
    coins = 0;
    finalCoins = 0;
    wonBook = false;
    selectedIndex = null;
    _usedLifelines.clear();
    _usedQuestionIds.clear();
    await storage.incrementGamesPlayed();
    _loadStep();
  }

  void _loadStep() {
    final step = PrizeLadder.steps[stepIndex];
    final next = repository.pick(step.difficulty, _usedQuestionIds);
    if (next == null) {
      // Sem perguntas suficientes: encerra levando o que tem.
      _finishStopped();
      return;
    }
    question = next;
    _usedQuestionIds.add(next.id);
    selectedIndex = null;
    lastAnswerCorrect = false;
    _eliminated.clear();
    audienceSuggestion = null;
    phase = GamePhase.playing;
    _startTimer();
    notifyListeners();
  }

  // ---- Timer ----
  void _startTimer() {
    _timer?.cancel();
    secondsLeft = _timePerQuestion;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      secondsLeft--;
      if (secondsLeft <= 5 && secondsLeft > 0) {
        audio.play(Sfx.tick);
      }
      if (secondsLeft <= 0) {
        _timer?.cancel();
        _onTimeout();
      }
      notifyListeners();
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void _onTimeout() {
    // Tempo esgotado conta como erro.
    selectedIndex = null;
    lastAnswerCorrect = false;
    audio.play(Sfx.wrong);
    _finishLost();
  }

  // ---- Responder ----
  void answer(int index) {
    if (phase != GamePhase.playing) return;
    if (_eliminated.contains(index)) return;
    _stopTimer();
    selectedIndex = index;
    final q = question!;
    lastAnswerCorrect = q.isCorrect(index);
    phase = GamePhase.feedback;

    if (lastAnswerCorrect) {
      coins = currentStep.coins;
      audio.play(Sfx.correct);
    } else {
      audio.play(Sfx.wrong);
    }
    notifyListeners();
  }

  /// Avança para o próximo degrau (chamado após o feedback).
  void next() {
    if (phase != GamePhase.feedback) return;
    if (!lastAnswerCorrect) {
      _finishLost();
      return;
    }
    if (stepIndex >= PrizeLadder.totalSteps - 1) {
      _finishWon();
      return;
    }
    stepIndex++;
    _loadStep();
  }

  // ---- Parar e levar os coins ----
  void stopGame() {
    if (phase != GamePhase.playing && phase != GamePhase.feedback) return;
    _stopTimer();
    _finishStopped();
  }

  // ---- Ajudas ----
  void useFiftyFifty() {
    if (phase != GamePhase.playing || isLifelineUsed(Lifeline.fiftyFifty)) {
      return;
    }
    final q = question!;
    final wrong = <int>[];
    for (var i = 0; i < q.options.length; i++) {
      if (i != q.correctIndex) wrong.add(i);
    }
    wrong.shuffle(_random);
    _eliminated
      ..clear()
      ..addAll(wrong.take(2));
    _usedLifelines.add(Lifeline.fiftyFifty);
    audio.play(Sfx.tap);
    notifyListeners();
  }

  void useAudience() {
    if (phase != GamePhase.playing || isLifelineUsed(Lifeline.audience)) {
      return;
    }
    // A "plateia" aponta a resposta certa na maioria das vezes.
    final q = question!;
    final hitTheRight = _random.nextDouble() < 0.8;
    if (hitTheRight) {
      audienceSuggestion = q.correctIndex;
    } else {
      final others = <int>[];
      for (var i = 0; i < q.options.length; i++) {
        if (i != q.correctIndex && !_eliminated.contains(i)) others.add(i);
      }
      audienceSuggestion =
          others.isEmpty ? q.correctIndex : others[_random.nextInt(others.length)];
    }
    _usedLifelines.add(Lifeline.audience);
    audio.play(Sfx.tap);
    notifyListeners();
  }

  void useSkip() {
    if (phase != GamePhase.playing || isLifelineUsed(Lifeline.skip)) return;
    _usedLifelines.add(Lifeline.skip);
    _stopTimer();
    audio.play(Sfx.tap);
    // Sorteia outra pergunta da mesma dificuldade, sem mudar de degrau.
    final next = repository.pick(currentStep.difficulty, _usedQuestionIds);
    if (next == null) {
      _finishStopped();
      return;
    }
    question = next;
    _usedQuestionIds.add(next.id);
    selectedIndex = null;
    _eliminated.clear();
    audienceSuggestion = null;
    phase = GamePhase.playing;
    _startTimer();
    notifyListeners();
  }

  // ---- Finalizações ----
  Future<void> _finishWon() async {
    _stopTimer();
    finalCoins = PrizeLadder.millionGoal;
    wonBook = true;
    phase = GamePhase.won;
    audio.play(Sfx.win);
    await storage.incrementBooksWon();
    await _persistBest(finalCoins);
    notifyListeners();
  }

  Future<void> _finishLost() async {
    _stopTimer();
    finalCoins = safeNetCoins; // cai para o último checkpoint
    coins = finalCoins;
    phase = GamePhase.lost;
    audio.play(Sfx.lose);
    await _persistBest(finalCoins);
    notifyListeners();
  }

  Future<void> _finishStopped() async {
    _stopTimer();
    finalCoins = coins;
    phase = GamePhase.stopped;
    await _persistBest(finalCoins);
    notifyListeners();
  }

  Future<void> _persistBest(int value) async {
    await storage.saveBestCoins(value);
    if (value > bestCoins) bestCoins = value;
  }

  void backToHome() {
    _stopTimer();
    phase = GamePhase.loading;
    notifyListeners();
  }

  bool get muted => audio.muted;

  Future<void> toggleMute() async {
    audio.toggleMute();
    await storage.setMuted(audio.muted);
    notifyListeners();
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }
}
