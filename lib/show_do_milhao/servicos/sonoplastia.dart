import 'package:audioplayers/audioplayers.dart';

/// Sonoplastia do jogo, no estilo Duolingo: efeitos curtos, alegres
/// e imediatos para cada interação.
class Sonoplastia {
  Sonoplastia({this.ativada = true});

  /// Quando `false`, nenhum som é tocado (botão de mudo e testes).
  bool ativada;

  // Criado só no primeiro uso, para que testes com o som desligado
  // não dependam do plugin de áudio.
  AudioPlayer? _player;

  Future<void> _tocar(String arquivo) async {
    if (!ativada) return;
    try {
      final player = _player ??= AudioPlayer();
      await player.stop();
      await player.play(AssetSource('sounds/sdm/$arquivo'));
    } catch (_) {
      // Sem suporte a áudio (ex.: testes): o jogo segue em silêncio.
    }
  }

  /// Clique de botão/seleção de alternativa.
  Future<void> botao() => _tocar('botao.wav');

  /// "Ding" de resposta correta.
  Future<void> acerto() => _tocar('acerto.wav');

  /// "Thud" de resposta errada.
  Future<void> erro() => _tocar('erro.wav');

  /// Blip ao acionar uma ajuda (cartas, universitários, plateia).
  Future<void> ajuda() => _tocar('ajuda.wav');

  /// Whoosh ao pular a pergunta.
  Future<void> pular() => _tocar('pular.wav');

  /// Moedas ao parar e levar o prêmio.
  Future<void> parar() => _tocar('parar.wav');

  /// Fanfarra do milhão.
  Future<void> vitoria() => _tocar('vitoria.wav');

  void descartar() {
    _player?.dispose();
    _player = null;
  }
}
