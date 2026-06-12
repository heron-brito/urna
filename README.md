# Quiz Gospel do Milhão 🎙️📖

App em **Flutter** de perguntas e respostas com tema **gospel**, inspirado no
game show *Show do Milhão* (Silvio Santos) e com a experiência/sonoplastia no
espírito do **DuoLingo**.

- 💰 Prêmios em **coins** (sem cifrão — usamos ícones de moeda).
- 🏆 Quem chega a **1.000.000 de coins** ganha um **livro gospel**.
- ⏱️ **Cronômetro de 30s** por pergunta.
- 🪜 Escada de prêmios com **pontos seguros** (checkpoints).
- 🆘 Ajudas: **50/50**, **Plateia** e **Pular**.
- 🗂️ Perguntas em um arquivo **JSON** (`assets/data/questions.json`).

> MVP focado em **Web**; em seguida, **Android**.

## Como rodar

Pré-requisitos: [Flutter SDK](https://docs.flutter.dev/get-started/install)
(canal estável, Dart 3+).

```bash
flutter pub get

# Web (MVP)
flutter run -d chrome
# ou gerar o build de produção:
flutter build web

# Android (próxima fase)
flutter run -d android
flutter build apk
```

## Estrutura

```
lib/
├── main.dart                  # entrada + injeção de dependências (provider)
├── models/                    # Question, PrizeLadder
├── services/                  # QuestionRepository, AudioService, StorageService
├── state/game_controller.dart # lógica da partida (timer, ajudas, prêmios)
├── theme/app_theme.dart       # paleta estilo DuoLingo + gospel
├── widgets/                   # CoinCounter, TimerBar, AnswerButton, etc.
└── screens/                   # HomeScreen, QuizScreen, ResultScreen

assets/
├── data/questions.json        # banco de perguntas gospel
└── sounds/                    # efeitos sonoros (placeholders — ver README local)
```

## Adicionando perguntas

Edite `assets/data/questions.json`. Cada item:

```json
{
  "id": 31,
  "difficulty": "facil",        // facil | medio | dificil
  "question": "Texto da pergunta?",
  "options": ["A", "B", "C", "D"],
  "correctIndex": 0,             // índice (0-based) da alternativa correta
  "reference": "João 3:16",
  "explanation": "Comentário mostrado no feedback."
}
```

A escada sorteia perguntas por dificuldade crescente conforme o jogador sobe.

## Sons

Os arquivos em `assets/sounds/` são **placeholders**. Veja
`assets/sounds/README.md` para substituí-los por SFX livres de direitos.
