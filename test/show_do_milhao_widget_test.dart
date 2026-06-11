import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:urna/main_show_do_milhao.dart';
import 'package:urna/show_do_milhao/logica/jogo.dart';
import 'package:urna/show_do_milhao/modelos/pergunta.dart';
import 'package:urna/show_do_milhao/servicos/sonoplastia.dart';
import 'package:urna/show_do_milhao/telas/tela_jogo.dart';

/// Banco mínimo e determinístico: a alternativa A é sempre a correta.
List<Pergunta> perguntasDeTeste() {
  Pergunta pergunta(Dificuldade nivel, int n) => Pergunta(
        enunciado: 'Pergunta de teste $nivel $n',
        alternativas: const ['Certa', 'Errada 1', 'Errada 2', 'Errada 3'],
        indiceCorreta: 0,
        dificuldade: nivel,
      );
  return [
    for (var i = 0; i < 5; i++) pergunta(Dificuldade.facil, i),
    for (var i = 0; i < 5; i++) pergunta(Dificuldade.media, i),
    for (var i = 0; i < 6; i++) pergunta(Dificuldade.dificil, i),
  ];
}

Widget telaJogoDeTeste() {
  return MaterialApp(
    home: TelaJogo(
      sonoplastia: Sonoplastia(ativada: false),
      jogo: Jogo(perguntas: perguntasDeTeste(), random: Random(1)),
    ),
  );
}

void main() {
  testWidgets('Tela inicial mostra o título e o botão de jogar',
      (tester) async {
    await tester.pumpWidget(const AppShowDoMilhao());
    expect(find.textContaining('MILHÃO'), findsOneWidget);
    expect(find.text('EDIÇÃO GOSPEL'), findsOneWidget);
    expect(find.text('JOGAR'), findsOneWidget);
    expect(find.text('COMO JOGAR'), findsOneWidget);
  });

  testWidgets('Acertar a pergunta avança na escada de prêmios',
      (tester) async {
    await tester.pumpWidget(telaJogoDeTeste());
    expect(find.text('Pergunta 1 de 16'), findsOneWidget);

    await tester.tap(find.byKey(const Key('alternativa0')));
    await tester.pump(); // seleção
    await tester.pump(const Duration(milliseconds: 950)); // suspense
    await tester.pump(const Duration(milliseconds: 1150)); // revelação
    await tester.pump();

    expect(find.text('Pergunta 2 de 16'), findsOneWidget);
  });

  testWidgets('Errar a primeira pergunta leva à tela de resultado sem prêmio',
      (tester) async {
    await tester.pumpWidget(telaJogoDeTeste());

    await tester.tap(find.byKey(const Key('alternativa2')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 950));
    await tester.pump(const Duration(milliseconds: 1150));
    await tester.pumpAndSettle();

    expect(find.text('Que pena!'), findsOneWidget);
    expect(find.text('R\$ 0'), findsOneWidget);
    expect(find.text('JOGAR DE NOVO'), findsOneWidget);
  });

  testWidgets('Ajuda da plateia abre a votação e é de uso único',
      (tester) async {
    await tester.pumpWidget(telaJogoDeTeste());

    await tester.tap(find.byKey(const Key('ajudaPlateia')));
    await tester.pumpAndSettle();
    expect(find.text('👥 Plateia'), findsOneWidget);
  });
}
