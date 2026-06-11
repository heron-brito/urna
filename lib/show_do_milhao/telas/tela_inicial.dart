import 'package:flutter/material.dart';

import '../dados/repositorio_perguntas.dart';
import '../logica/jogo.dart';
import '../servicos/sonoplastia.dart';
import '../tema.dart';
import '../widgets/botao_duo.dart';
import 'tela_jogo.dart';

class TelaInicial extends StatefulWidget {
  const TelaInicial({Key? key, this.sonoplastia}) : super(key: key);

  /// Permite injetar uma sonoplastia desligada nos testes.
  final Sonoplastia? sonoplastia;

  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  late final Sonoplastia _som = widget.sonoplastia ?? Sonoplastia();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CoresDuo.palco,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                key: const Key('botaoSom'),
                icon: Icon(
                  _som.ativada ? Icons.volume_up : Icons.volume_off,
                  color: Colors.white70,
                ),
                tooltip: _som.ativada ? 'Desligar som' : 'Ligar som',
                onPressed: () => setState(() => _som.ativada = !_som.ativada),
              ),
            ),
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text('📖', style: TextStyle(fontSize: 72),
                          textAlign: TextAlign.center),
                      const SizedBox(height: 8),
                      const Text(
                        'SHOW DO\nMILHÃO',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: CoresDuo.amarelo,
                          fontSize: 44,
                          height: 1.05,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'EDIÇÃO GOSPEL',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 4,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Perguntas bíblicas valendo R\$ 1 milhão,\ncom sonoplastia do Duolingo 🦉',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                      const SizedBox(height: 40),
                      BotaoDuo(
                        key: const Key('botaoJogar'),
                        cor: CoresDuo.verde,
                        corSombra: CoresDuo.verdeEscuro,
                        onPressed: _comecarJogo,
                        child: const Text('JOGAR'),
                      ),
                      const SizedBox(height: 12),
                      BotaoDuo(
                        cor: CoresDuo.azul,
                        corSombra: CoresDuo.azulEscuro,
                        onPressed: () {
                          _som.botao();
                          _mostrarRegras(context);
                        },
                        child: const Text('COMO JOGAR'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _comecarJogo() async {
    _som.botao();
    final perguntas = await RepositorioPerguntas.carregar();
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TelaJogo(
          sonoplastia: _som,
          jogo: Jogo(perguntas: perguntas),
        ),
      ),
    );
  }

  void _mostrarRegras(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Como jogar'),
        content: const SingleChildScrollView(
          child: Text(
            'São 16 perguntas valendo de R\$ 1 mil a R\$ 1 MILHÃO.\n\n'
            '✅ Acertou: sobe na escada de prêmios.\n'
            '✋ Parou: leva o prêmio acumulado.\n'
            '❌ Errou: leva metade do valor de parar '
            '(na pergunta do milhão, sai sem nada!).\n\n'
            'Ajudas (uso único, exceto os pulos):\n'
            '🃏 Cartas — sorteia Rei, Ás, Dois ou Três e elimina '
            'até 3 alternativas erradas.\n'
            '🎓 Universitários — três estudantes dão seus palpites.\n'
            '👥 Plateia — mostra a votação do auditório.\n'
            '⏭️ Pular — troca a pergunta (até 3 vezes).',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ENTENDI'),
          ),
        ],
      ),
    );
  }
}
