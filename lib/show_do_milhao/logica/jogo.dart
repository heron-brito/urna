import 'dart:math';

import '../modelos/pergunta.dart';

/// Em que pé está a partida.
enum FaseJogo { jogando, ganhou, perdeu, parou }

/// Resultado do sorteio da ajuda das cartas.
class CartaSorteada {
  const CartaSorteada(this.nome, this.eliminadas);

  /// Nome da carta sorteada (Rei, Ás, Dois ou Três).
  final String nome;

  /// Quantas alternativas erradas a carta eliminou.
  final int eliminadas;
}

/// Motor do jogo, com as regras clássicas do Show do Milhão:
/// 16 perguntas valendo de R$ 1 mil a R$ 1 milhão, três pulos e as
/// ajudas das cartas, dos universitários e da plateia (uso único).
class Jogo {
  Jogo({required List<Pergunta> perguntas, Random? random})
      : _random = random ?? Random() {
    final todas = List<Pergunta>.from(perguntas);
    final faceis =
        todas.where((p) => p.dificuldade == Dificuldade.facil).toList()
          ..shuffle(_random);
    final medias =
        todas.where((p) => p.dificuldade == Dificuldade.media).toList()
          ..shuffle(_random);
    final dificeis =
        todas.where((p) => p.dificuldade == Dificuldade.dificil).toList()
          ..shuffle(_random);
    assert(faceis.length >= 5 && medias.length >= 5 && dificeis.length >= 6,
        'O banco precisa de ao menos 5 fáceis, 5 médias e 6 difíceis.');

    _roteiro
      ..addAll(faceis.take(5))
      ..addAll(medias.take(5))
      ..addAll(dificeis.take(6));
    _reservas[Dificuldade.facil] = faceis.skip(5).toList();
    _reservas[Dificuldade.media] = medias.skip(5).toList();
    _reservas[Dificuldade.dificil] = dificeis.skip(6).toList();
  }

  /// Escada de prêmios: o valor da pergunta 1 até a pergunta 16.
  static const List<int> premios = [
    1000, 2000, 3000, 4000, 5000,
    10000, 20000, 30000, 40000, 50000,
    100000, 200000, 300000, 400000, 500000,
    1000000,
  ];

  static const int totalPerguntas = 16;
  static const List<String> _cartas = ['Rei', 'Ás', 'Dois', 'Três'];

  final Random _random;
  final List<Pergunta> _roteiro = [];
  final Map<Dificuldade, List<Pergunta>> _reservas = {};

  /// Índice (base 0) da pergunta atual na escada.
  int indice = 0;
  FaseJogo fase = FaseJogo.jogando;
  int pulosRestantes = 3;
  bool cartasDisponivel = true;
  bool universitariosDisponivel = true;
  bool plateiaDisponivel = true;

  /// Alternativas eliminadas pela ajuda das cartas na pergunta atual.
  final Set<int> eliminadas = <int>{};

  /// Prêmio levado para casa quando a partida termina.
  int premioFinal = 0;

  Pergunta get perguntaAtual => _roteiro[indice];

  /// Número da pergunta exibido ao jogador (1 a 16).
  int get numeroPergunta => indice + 1;

  bool get ultimaPergunta => indice == totalPerguntas - 1;

  /// Quanto o jogador ganha se acertar a pergunta atual.
  int get valorAcerto => premios[indice];

  /// Quanto o jogador leva se parar agora.
  int get valorParar => indice == 0 ? 0 : premios[indice - 1];

  /// Quanto o jogador leva se errar: metade do valor de parar.
  /// Na pergunta do milhão, quem erra sai sem nada.
  int get valorErro => ultimaPergunta ? 0 : valorParar ~/ 2;

  /// Responde a pergunta atual. Retorna `true` em caso de acerto.
  bool responder(int alternativa) {
    assert(fase == FaseJogo.jogando);
    if (alternativa == perguntaAtual.indiceCorreta) {
      if (ultimaPergunta) {
        fase = FaseJogo.ganhou;
        premioFinal = valorAcerto;
      } else {
        indice++;
        eliminadas.clear();
      }
      return true;
    }
    premioFinal = valorErro;
    fase = FaseJogo.perdeu;
    return false;
  }

  /// Para o jogo e leva o prêmio acumulado.
  void parar() {
    assert(fase == FaseJogo.jogando);
    premioFinal = valorParar;
    fase = FaseJogo.parou;
  }

  /// Pula a pergunta atual, trocando-a por outra do mesmo nível.
  /// Retorna `false` se não houver mais pulos ou perguntas de reserva.
  bool pular() {
    if (pulosRestantes <= 0) return false;
    final reserva = _reservas[perguntaAtual.dificuldade]!;
    if (reserva.isEmpty) return false;
    _roteiro[indice] = reserva.removeAt(0);
    pulosRestantes--;
    eliminadas.clear();
    return true;
  }

  /// Ajuda das cartas: sorteia Rei (elimina 0), Ás (1), Dois (2) ou
  /// Três (3) e elimina alternativas erradas. Retorna `null` se a
  /// ajuda já foi usada.
  CartaSorteada? usarCartas() {
    if (!cartasDisponivel) return null;
    cartasDisponivel = false;
    final sorteio = _random.nextInt(_cartas.length);
    final erradas = _alternativasErradasRestantes()..shuffle(_random);
    final quantidade = min(sorteio, erradas.length);
    eliminadas.addAll(erradas.take(quantidade));
    return CartaSorteada(_cartas[sorteio], quantidade);
  }

  /// Ajuda dos universitários: retorna o palpite de cada um dos três.
  /// Eles acertam com mais frequência nas perguntas fáceis.
  /// Retorna `null` se a ajuda já foi usada.
  List<int>? usarUniversitarios() {
    if (!universitariosDisponivel) return null;
    universitariosDisponivel = false;
    final chance = _chanceDeAcerto();
    return List<int>.generate(3, (_) {
      if (_random.nextDouble() < chance) return perguntaAtual.indiceCorreta;
      final erradas = _alternativasErradasRestantes();
      return erradas[_random.nextInt(erradas.length)];
    });
  }

  /// Ajuda da plateia: retorna o percentual de votos de cada
  /// alternativa (soma 100). Retorna `null` se a ajuda já foi usada.
  Map<int, int>? usarPlateia() {
    if (!plateiaDisponivel) return null;
    plateiaDisponivel = false;
    final votos = <int, int>{for (var i = 0; i < 4; i++) i: 0};
    final base = (_chanceDeAcerto() * 100).round();
    var pctCorreta = base - 15 + _random.nextInt(21); // base -15 a +5
    pctCorreta = pctCorreta.clamp(20, 95).toInt();
    final erradas = _alternativasErradasRestantes();
    if (erradas.isEmpty) {
      votos[perguntaAtual.indiceCorreta] = 100;
      return votos;
    }
    votos[perguntaAtual.indiceCorreta] = pctCorreta;
    var restante = 100 - pctCorreta;
    for (var i = 0; i < erradas.length; i++) {
      final ultima = i == erradas.length - 1;
      final parte = ultima ? restante : _random.nextInt(restante + 1);
      votos[erradas[i]] = parte;
      restante -= parte;
    }
    return votos;
  }

  List<int> _alternativasErradasRestantes() {
    return [
      for (var i = 0; i < 4; i++)
        if (i != perguntaAtual.indiceCorreta && !eliminadas.contains(i)) i
    ];
  }

  double _chanceDeAcerto() {
    switch (perguntaAtual.dificuldade) {
      case Dificuldade.facil:
        return 0.90;
      case Dificuldade.media:
        return 0.72;
      case Dificuldade.dificil:
        return 0.55;
    }
  }
}
