import 'package:flutter/material.dart';

import '../logica/jogo.dart';
import '../tema.dart';
import '../util/formatador.dart';

/// Lista com a escada de prêmios, destacando a pergunta atual.
class EscadaPremios extends StatelessWidget {
  const EscadaPremios({Key? key, required this.indiceAtual}) : super(key: key);

  final int indiceAtual;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      itemCount: Jogo.totalPerguntas,
      itemBuilder: (context, i) {
        // Escada de cima para baixo: o milhão primeiro.
        final indice = Jogo.totalPerguntas - 1 - i;
        final atual = indice == indiceAtual;
        final passada = indice < indiceAtual;
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 2),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
          decoration: BoxDecoration(
            color: atual
                ? CoresDuo.amarelo
                : passada
                    ? CoresDuo.verde.withOpacity(0.25)
                    : Colors.white10,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 28,
                child: Text(
                  '${indice + 1}',
                  style: TextStyle(
                    color: atual ? CoresDuo.palco : Colors.white70,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  formatarReais(Jogo.premios[indice]),
                  style: TextStyle(
                    color: atual ? CoresDuo.palco : Colors.white,
                    fontWeight: atual ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
              ),
              if (passada)
                const Icon(Icons.check_circle,
                    color: CoresDuo.verde, size: 18),
            ],
          ),
        );
      },
    );
  }
}
