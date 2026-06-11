import 'package:flutter/material.dart';

import 'show_do_milhao/telas/tela_inicial.dart';
import 'show_do_milhao/tema.dart';

/// Show do Milhão — Edição Gospel, com sonoplastia estilo Duolingo.
/// Para rodar: `flutter run -t lib/main_show_do_milhao.dart`
void main() {
  runApp(const AppShowDoMilhao());
}

class AppShowDoMilhao extends StatelessWidget {
  const AppShowDoMilhao({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Show do Milhão Gospel',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: CoresDuo.palco,
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: CoresDuo.verde,
          secondary: CoresDuo.azul,
        ),
      ),
      home: const TelaInicial(),
    );
  }
}
