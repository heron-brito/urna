import 'package:flutter/material.dart';

import '../logica/jogo.dart';
import '../servicos/sonoplastia.dart';
import '../tema.dart';
import '../util/formatador.dart';
import '../widgets/botao_duo.dart';
import '../widgets/escada_premios.dart';
import 'tela_resultado.dart';

class TelaJogo extends StatefulWidget {
  const TelaJogo({Key? key, required this.sonoplastia, required this.jogo})
      : super(key: key);

  final Sonoplastia sonoplastia;
  final Jogo jogo;

  @override
  State<TelaJogo> createState() => _TelaJogoState();
}

class _TelaJogoState extends State<TelaJogo> {
  static const _letras = ['A', 'B', 'C', 'D'];
  static const _universitarios = ['Ana', 'Bruno', 'Carla'];

  Jogo get _jogo => widget.jogo;
  Sonoplastia get _som => widget.sonoplastia;

  int? _selecionada;
  int? _corretaRevelada;
  bool _ocupado = false;

  Future<void> _responder(int alternativa) async {
    if (_ocupado || _jogo.eliminadas.contains(alternativa)) return;
    setState(() {
      _ocupado = true;
      _selecionada = alternativa;
    });
    _som.botao();

    // Suspense antes de revelar, como no programa.
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;

    final correta = _jogo.perguntaAtual.indiceCorreta;
    final acertou = alternativa == correta;
    setState(() => _corretaRevelada = correta);
    if (acertou) {
      _som.acerto();
    } else {
      _som.erro();
    }

    await Future.delayed(const Duration(milliseconds: 1100));
    if (!mounted) return;

    _jogo.responder(alternativa);
    if (_jogo.fase == FaseJogo.jogando) {
      setState(() {
        _selecionada = null;
        _corretaRevelada = null;
        _ocupado = false;
      });
    } else {
      _irParaResultado();
    }
  }

  void _irParaResultado() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => TelaResultado(
          fase: _jogo.fase,
          premio: _jogo.premioFinal,
          sonoplastia: _som,
        ),
      ),
    );
  }

  void _pular() {
    if (_ocupado) return;
    _som.pular();
    setState(() {
      _jogo.pular();
      _selecionada = null;
    });
  }

  void _confirmarParar() {
    if (_ocupado) return;
    _som.botao();
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Parar agora?'),
        content: Text(
            'Você leva ${formatarReais(_jogo.valorParar)} para casa. '
            'Tem certeza?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CONTINUAR JOGANDO'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _jogo.parar();
              _irParaResultado();
            },
            child: const Text('PARAR'),
          ),
        ],
      ),
    );
  }

  void _usarCartas() {
    if (_ocupado) return;
    final carta = _jogo.usarCartas();
    if (carta == null) return;
    _som.ajuda();
    setState(() {});
    _mostrarAjuda(
      titulo: '🃏 Cartas',
      child: Text(
        'Saiu a carta: ${carta.nome}!\n'
        '${carta.eliminadas == 0 ? 'Nenhuma alternativa foi eliminada... azar!' : '${carta.eliminadas} alternativa(s) errada(s) eliminada(s).'}',
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  void _usarUniversitarios() {
    if (_ocupado) return;
    final palpites = _jogo.usarUniversitarios();
    if (palpites == null) return;
    _som.ajuda();
    setState(() {});
    _mostrarAjuda(
      titulo: '🎓 Universitários',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < palpites.length; i++)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                '${_universitarios[i]} acha que é a '
                'alternativa ${_letras[palpites[i]]}.',
                style: const TextStyle(fontSize: 16),
              ),
            ),
        ],
      ),
    );
  }

  void _usarPlateia() {
    if (_ocupado) return;
    final votos = _jogo.usarPlateia();
    if (votos == null) return;
    _som.ajuda();
    setState(() {});
    _mostrarAjuda(
      titulo: '👥 Plateia',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < 4; i++)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                children: [
                  SizedBox(
                      width: 24,
                      child: Text(_letras[i],
                          style:
                              const TextStyle(fontWeight: FontWeight.bold))),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: (votos[i] ?? 0) / 100,
                        minHeight: 14,
                        backgroundColor: CoresDuo.cinzaBorda,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            CoresDuo.azul),
                      ),
                    ),
                  ),
                  SizedBox(
                      width: 48,
                      child: Text('${votos[i] ?? 0}%',
                          textAlign: TextAlign.right)),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _mostrarAjuda({required String titulo, required Widget child}) {
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(titulo,
                style: const TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            child,
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _mostrarEscada() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: CoresDuo.palcoClaro,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => EscadaPremios(indiceAtual: _jogo.indice),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pergunta = _jogo.perguntaAtual;
    return Scaffold(
      backgroundColor: CoresDuo.palco,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              children: [
                _cabecalho(),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 8),
                    children: [
                      _cartaoPergunta(pergunta.enunciado),
                      const SizedBox(height: 16),
                      for (var i = 0; i < 4; i++) ...[
                        _botaoAlternativa(i, pergunta.alternativas[i]),
                        const SizedBox(height: 8),
                      ],
                    ],
                  ),
                ),
                _barraDeAjudas(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _cabecalho() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 8, 0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Pergunta ${_jogo.numeroPergunta} de ${Jogo.totalPerguntas}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                key: const Key('botaoEscada'),
                onPressed: _mostrarEscada,
                tooltip: 'Escada de prêmios',
                icon: const Icon(Icons.emoji_events, color: CoresDuo.amarelo),
              ),
            ],
          ),
          Row(
            children: [
              _chipValor('Certas', _jogo.valorAcerto, CoresDuo.verde),
              const SizedBox(width: 8),
              _chipValor('Parar', _jogo.valorParar, CoresDuo.amarelo),
              const SizedBox(width: 8),
              _chipValor('Errar', _jogo.valorErro, CoresDuo.vermelho),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chipValor(String rotulo, int valor, Color cor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: cor, width: 1.5),
        ),
        child: Column(
          children: [
            Text(rotulo,
                style: TextStyle(
                    color: cor, fontSize: 11, fontWeight: FontWeight.bold)),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                formatarReais(valor),
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cartaoPergunta(String enunciado) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: CoresDuo.palcoClaro,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white24),
      ),
      child: Text(
        enunciado,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 19,
          fontWeight: FontWeight.w600,
          height: 1.3,
        ),
      ),
    );
  }

  Widget _botaoAlternativa(int i, String texto) {
    final eliminada = _jogo.eliminadas.contains(i);

    var cor = CoresDuo.branco;
    var corSombra = CoresDuo.cinzaBorda;
    var corTexto = CoresDuo.cinzaTexto;
    if (_corretaRevelada != null) {
      if (i == _corretaRevelada) {
        cor = CoresDuo.verde;
        corSombra = CoresDuo.verdeEscuro;
        corTexto = Colors.white;
      } else if (i == _selecionada) {
        cor = CoresDuo.vermelho;
        corSombra = CoresDuo.vermelhoEscuro;
        corTexto = Colors.white;
      }
    } else if (i == _selecionada) {
      cor = CoresDuo.amarelo;
      corSombra = CoresDuo.amareloEscuro;
      corTexto = CoresDuo.palco;
    }

    return BotaoDuo(
      key: Key('alternativa$i'),
      cor: cor,
      corSombra: corSombra,
      corTexto: corTexto,
      altura: 56,
      usarEstiloDesabilitado: eliminada,
      onPressed: eliminada || _ocupado ? null : () => _responder(i),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Text('${_letras[i]})'),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                texto,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  decoration: eliminada
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _barraDeAjudas() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _botaoAjuda(
            emoji: '🃏',
            rotulo: 'Cartas',
            chave: 'ajudaCartas',
            habilitado: _jogo.cartasDisponivel,
            aoTocar: _usarCartas,
          ),
          _botaoAjuda(
            emoji: '🎓',
            rotulo: 'Univers.',
            chave: 'ajudaUniversitarios',
            habilitado: _jogo.universitariosDisponivel,
            aoTocar: _usarUniversitarios,
          ),
          _botaoAjuda(
            emoji: '👥',
            rotulo: 'Plateia',
            chave: 'ajudaPlateia',
            habilitado: _jogo.plateiaDisponivel,
            aoTocar: _usarPlateia,
          ),
          _botaoAjuda(
            emoji: '⏭️',
            rotulo: 'Pular ${_jogo.pulosRestantes}',
            chave: 'ajudaPular',
            habilitado: _jogo.pulosRestantes > 0,
            aoTocar: _pular,
          ),
          _botaoAjuda(
            emoji: '✋',
            rotulo: 'Parar',
            chave: 'botaoParar',
            habilitado: _jogo.indice > 0,
            aoTocar: _confirmarParar,
          ),
        ],
      ),
    );
  }

  Widget _botaoAjuda({
    required String emoji,
    required String rotulo,
    required String chave,
    required bool habilitado,
    required VoidCallback aoTocar,
  }) {
    return Opacity(
      opacity: habilitado ? 1 : 0.35,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Material(
            color: CoresDuo.palcoClaro,
            shape: const CircleBorder(side: BorderSide(color: Colors.white24)),
            child: InkWell(
              key: Key(chave),
              customBorder: const CircleBorder(),
              onTap: habilitado && !_ocupado ? aoTocar : null,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(emoji, style: const TextStyle(fontSize: 22)),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(rotulo,
              style: const TextStyle(color: Colors.white70, fontSize: 11)),
        ],
      ),
    );
  }
}
