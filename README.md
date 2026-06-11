# urna

A new Flutter project.

## 📖 Show do Milhão — Edição Gospel

Jogo de perguntas e respostas inspirado no Show do Milhão do Silvio Santos,
com tema gospel (perguntas bíblicas) e sonoplastia no estilo do Duolingo.
Convive com o app da urna no mesmo projeto, como um segundo entrypoint.

### Como rodar

```bash
flutter run -t lib/main_show_do_milhao.dart
```

### Como jogar

- 16 perguntas valendo de R$ 1 mil a R$ 1 milhão.
- **Acertou**: sobe na escada de prêmios. **Parou**: leva o acumulado.
  **Errou**: leva metade do valor de parar (no milhão, sai sem nada).
- Ajudas: 🃏 cartas (Rei, Ás, Dois ou Três), 🎓 universitários,
  👥 plateia e ⏭️ até 3 pulos.

### Estrutura

- `lib/main_show_do_milhao.dart` — entrypoint do jogo.
- `lib/show_do_milhao/logica/jogo.dart` — regras do jogo (Dart puro, testado).
- `assets/dados/perguntas.json` — banco de perguntas (36, em 3 níveis).
  Para adicionar perguntas, basta editar esse JSON.
- `assets/sounds/sdm/` — efeitos sonoros estilo Duolingo, gerados por
  `tool/gerar_sons.py` (`python3 tool/gerar_sons.py`).
- Testes: `test/show_do_milhao_logica_test.dart` e
  `test/show_do_milhao_widget_test.dart`.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
