import 'package:flutter/material.dart';

import '../dados/repositorio_perguntas.dart';
import '../logica/jogo.dart';
import '../servicos/sonoplastia.dart';
import '../tema.dart';
import '../util/formatador.dart';
import '../widgets/botao_duo.dart';
import 'tela_jogo.dart';

class TelaResultado extends StatefulWidget {
  const TelaResultado({
    Key? key,
    required this.fase,
    required this.premio,
    required this.sonoplastia,
  }) : super(key: key);

  final FaseJogo fase;
  final int premio;
  final Sonoplastia sonoplastia;

  @override
  State<TelaResultado> createState() => _TelaResultadoState();
}

class _TelaResultadoState extends State<TelaResultado> {
  @override
  void initState() {
    super.initState();
    if (widget.fase == FaseJogo.ganhou) {
      widget.sonoplastia.vitoria();
    } else if (widget.fase == FaseJogo.parou) {
      widget.sonoplastia.parar();
    }
  }

  String get _emoji {
    switch (widget.fase) {
      case FaseJogo.ganhou:
        return '🏆';
      case FaseJogo.parou:
        return '🤝';
      default:
        return '😅';
    }
  }

  String get _titulo {
    switch (widget.fase) {
      case FaseJogo.ganhou:
        return 'VOCÊ GANHOU\nUM MILHÃO!';
      case FaseJogo.parou:
        return 'Boa decisão!';
      default:
        return 'Que pena!';
    }
  }

  String get _mensagem {
    switch (widget.fase) {
      case FaseJogo.ganhou:
        return 'Você respondeu as 16 perguntas e faturou o prêmio máximo!';
      case FaseJogo.parou:
        return 'Você parou na hora certa e levou para casa:';
      default:
        return widget.premio > 0
            ? 'Você errou, mas não sai de mãos vazias. Seu prêmio:'
            : 'Você errou e desta vez não levou nada. Tente de novo!';
    }
  }

  Future<void> _jogarDeNovo() async {
    widget.sonoplastia.botao();
    final perguntas = await RepositorioPerguntas.carregar();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => TelaJogo(
          sonoplastia: widget.sonoplastia,
          jogo: Jogo(perguntas: perguntas),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CoresDuo.palco,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(_emoji,
                      style: const TextStyle(fontSize: 72),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  Text(
                    _titulo,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: CoresDuo.amarelo,
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _mensagem,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    formatarReais(widget.premio),
                    key: const Key('premioFinal'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 40),
                  BotaoDuo(
                    key: const Key('botaoJogarDeNovo'),
                    cor: CoresDuo.verde,
                    corSombra: CoresDuo.verdeEscuro,
                    onPressed: _jogarDeNovo,
                    child: const Text('JOGAR DE NOVO'),
                  ),
                  const SizedBox(height: 12),
                  BotaoDuo(
                    cor: CoresDuo.azul,
                    corSombra: CoresDuo.azulEscuro,
                    onPressed: () {
                      widget.sonoplastia.botao();
                      Navigator.popUntil(context, (rota) => rota.isFirst);
                    },
                    child: const Text('INÍCIO'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
