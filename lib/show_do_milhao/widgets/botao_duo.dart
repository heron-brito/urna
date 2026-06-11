import 'package:flutter/material.dart';

/// Botão no estilo Duolingo: cantos bem arredondados e uma "borda 3D"
/// embaixo que afunda quando o botão é pressionado.
class BotaoDuo extends StatefulWidget {
  const BotaoDuo({
    Key? key,
    required this.cor,
    required this.corSombra,
    required this.child,
    this.onPressed,
    this.corTexto = Colors.white,
    this.altura = 52,
    this.usarEstiloDesabilitado = true,
  }) : super(key: key);

  final Color cor;
  final Color corSombra;
  final Color corTexto;
  final double altura;
  final Widget child;
  final VoidCallback? onPressed;

  /// Quando `false`, mantém as cores informadas mesmo sem [onPressed]
  /// (usado para exibir o feedback verde/vermelho da resposta).
  final bool usarEstiloDesabilitado;

  @override
  State<BotaoDuo> createState() => _BotaoDuoState();
}

class _BotaoDuoState extends State<BotaoDuo> {
  bool _pressionado = false;

  @override
  Widget build(BuildContext context) {
    const profundidade = 4.0;
    final habilitado = widget.onPressed != null;
    final apagado = !habilitado && widget.usarEstiloDesabilitado;
    final cor = apagado ? const Color(0xFFE5E5E5) : widget.cor;
    final corSombra = apagado ? const Color(0xFFCCCCCC) : widget.corSombra;
    final afundado = _pressionado && habilitado;

    return GestureDetector(
      onTapDown: (_) => setState(() => _pressionado = true),
      onTapUp: (_) {
        setState(() => _pressionado = false);
        widget.onPressed?.call();
      },
      onTapCancel: () => setState(() => _pressionado = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 60),
        height: widget.altura,
        margin: EdgeInsets.only(
          top: afundado ? profundidade : 0,
          bottom: afundado ? 0 : profundidade,
        ),
        decoration: BoxDecoration(
          color: cor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            if (!afundado)
              BoxShadow(color: corSombra, offset: const Offset(0, profundidade)),
          ],
        ),
        child: Center(
          child: DefaultTextStyle(
            style: TextStyle(
              color: apagado ? const Color(0xFFAFAFAF) : widget.corTexto,
              fontSize: 17,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
