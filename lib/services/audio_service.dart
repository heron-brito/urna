import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

/// Efeitos sonoros disponíveis. Os arquivos ficam em assets/sounds/.
/// A sonoplastia segue o espírito do DuoLingo: feedback curto e marcante.
enum Sfx {
  tap('botao.wav'),
  correct('correct.wav'),
  wrong('wrong.wav'),
  tick('tick.wav'),
  win('win.wav'),
  lose('fim.wav');

  final String file;
  const Sfx(this.file);
}

/// Toca efeitos sonoros do jogo. Falhas (ex.: arquivo ausente no MVP)
/// são silenciosas para nunca interromper a jogabilidade.
class AudioService {
  final AudioPlayer _player = AudioPlayer(playerId: 'sfx');
  bool muted = false;

  AudioService() {
    _player.setReleaseMode(ReleaseMode.stop);
  }

  Future<void> play(Sfx sfx) async {
    if (muted) return;
    try {
      await _player.stop();
      await _player.play(AssetSource('sounds/${sfx.file}'));
    } catch (e) {
      // Som é opcional: ignora se o asset não existir.
      if (kDebugMode) {
        debugPrint('AudioService: não foi possível tocar ${sfx.file} ($e)');
      }
    }
  }

  void toggleMute() => muted = !muted;

  void dispose() {
    _player.dispose();
  }
}
