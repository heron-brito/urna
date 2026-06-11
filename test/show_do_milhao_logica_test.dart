import 'dart:io';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';

import 'package:urna/show_do_milhao/dados/repositorio_perguntas.dart';
import 'package:urna/show_do_milhao/logica/jogo.dart';
import 'package:urna/show_do_milhao/modelos/pergunta.dart';
import 'package:urna/show_do_milhao/util/formatador.dart';

List<Pergunta> carregarBanco() {
  final texto = File('assets/dados/perguntas.json').readAsStringSync();
  return RepositorioPerguntas.decodificar(texto);
}

Jogo novoJogo({int semente = 42}) =>
    Jogo(perguntas: carregarBanco(), random: Random(semente));

void main() {
  group('Banco de perguntas (JSON)', () {
    test('carrega 36 perguntas válidas, 12 por nível', () {
      final banco = carregarBanco();
      expect(banco.length, 36);
      for (final nivel in Dificuldade.values) {
        expect(banco.where((p) => p.dificuldade == nivel).length, 12);
      }
      for (final p in banco) {
        expect(p.alternativas.length, 4);
        expect(p.indiceCorreta, inInclusiveRange(0, 3));
        expect(p.enunciado, isNotEmpty);
      }
    });
  });

  group('Formatador de prêmios', () {
    test('formata valores em reais', () {
      expect(formatarReais(0), 'R\$ 0');
      expect(formatarReais(2500), 'R\$ 2.500');
      expect(formatarReais(50000), 'R\$ 50.000');
      expect(formatarReais(1000000), 'R\$ 1.000.000');
    });
  });

  group('Regras do jogo', () {
    test('escada tem 16 prêmios até o milhão', () {
      expect(Jogo.premios.length, 16);
      expect(Jogo.premios.first, 1000);
      expect(Jogo.premios.last, 1000000);
    });

    test('acertando as 16 perguntas, ganha o milhão', () {
      final jogo = novoJogo();
      for (var i = 0; i < 16; i++) {
        expect(jogo.fase, FaseJogo.jogando);
        expect(jogo.numeroPergunta, i + 1);
        expect(jogo.responder(jogo.perguntaAtual.indiceCorreta), isTrue);
      }
      expect(jogo.fase, FaseJogo.ganhou);
      expect(jogo.premioFinal, 1000000);
    });

    test('errando a primeira pergunta, sai sem nada', () {
      final jogo = novoJogo();
      final errada = (jogo.perguntaAtual.indiceCorreta + 1) % 4;
      expect(jogo.responder(errada), isFalse);
      expect(jogo.fase, FaseJogo.perdeu);
      expect(jogo.premioFinal, 0);
    });

    test('errando a sexta pergunta, leva metade dos R\$ 5 mil', () {
      final jogo = novoJogo();
      for (var i = 0; i < 5; i++) {
        jogo.responder(jogo.perguntaAtual.indiceCorreta);
      }
      expect(jogo.valorParar, 5000);
      expect(jogo.valorErro, 2500);
      jogo.responder((jogo.perguntaAtual.indiceCorreta + 1) % 4);
      expect(jogo.fase, FaseJogo.perdeu);
      expect(jogo.premioFinal, 2500);
    });

    test('parando após 10 acertos, leva R\$ 50 mil', () {
      final jogo = novoJogo();
      for (var i = 0; i < 10; i++) {
        jogo.responder(jogo.perguntaAtual.indiceCorreta);
      }
      jogo.parar();
      expect(jogo.fase, FaseJogo.parou);
      expect(jogo.premioFinal, 50000);
    });

    test('errando a pergunta do milhão, perde tudo', () {
      final jogo = novoJogo();
      for (var i = 0; i < 15; i++) {
        jogo.responder(jogo.perguntaAtual.indiceCorreta);
      }
      expect(jogo.ultimaPergunta, isTrue);
      expect(jogo.valorErro, 0);
      jogo.responder((jogo.perguntaAtual.indiceCorreta + 1) % 4);
      expect(jogo.premioFinal, 0);
    });

    test('só é possível pular três vezes', () {
      final jogo = novoJogo();
      final primeira = jogo.perguntaAtual;
      expect(jogo.pular(), isTrue);
      expect(jogo.perguntaAtual, isNot(same(primeira)));
      expect(jogo.pular(), isTrue);
      expect(jogo.pular(), isTrue);
      expect(jogo.pulosRestantes, 0);
      expect(jogo.pular(), isFalse);
    });

    test('cartas eliminam só alternativas erradas e têm uso único', () {
      final jogo = novoJogo();
      final carta = jogo.usarCartas();
      expect(carta, isNotNull);
      expect(carta!.eliminadas, jogo.eliminadas.length);
      expect(jogo.eliminadas.contains(jogo.perguntaAtual.indiceCorreta),
          isFalse);
      expect(jogo.usarCartas(), isNull);
    });

    test('universitários dão três palpites válidos e têm uso único', () {
      final jogo = novoJogo();
      final palpites = jogo.usarUniversitarios();
      expect(palpites, isNotNull);
      expect(palpites!.length, 3);
      for (final palpite in palpites) {
        expect(palpite, inInclusiveRange(0, 3));
      }
      expect(jogo.usarUniversitarios(), isNull);
    });

    test('votação da plateia soma 100% e tem uso único', () {
      final jogo = novoJogo();
      final votos = jogo.usarPlateia();
      expect(votos, isNotNull);
      expect(votos!.values.reduce((a, b) => a + b), 100);
      expect(jogo.usarPlateia(), isNull);
    });
  });
}
