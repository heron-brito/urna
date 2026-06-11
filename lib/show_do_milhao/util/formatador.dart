/// Formata um valor inteiro como moeda, ex.: 1000000 -> "R$ 1.000.000".
String formatarReais(int valor) {
  final digitos = valor.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digitos.length; i++) {
    final restantes = digitos.length - i;
    buffer.write(digitos[i]);
    if (restantes > 1 && restantes % 3 == 1) buffer.write('.');
  }
  return 'R\$ $buffer';
}
