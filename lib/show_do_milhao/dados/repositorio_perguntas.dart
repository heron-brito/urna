import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../modelos/pergunta.dart';

/// Carrega o banco de perguntas do arquivo JSON em
/// `assets/dados/perguntas.json`, mantendo o resultado em cache.
class RepositorioPerguntas {
  RepositorioPerguntas._();

  static const String caminhoAsset = 'assets/dados/perguntas.json';
  static List<Pergunta>? _cache;

  static Future<List<Pergunta>> carregar() async {
    final cache = _cache;
    if (cache != null) return cache;
    final texto = await rootBundle.loadString(caminhoAsset);
    return _cache = decodificar(texto);
  }

  /// Converte o conteúdo do JSON em uma lista de perguntas.
  static List<Pergunta> decodificar(String textoJson) {
    final dados = json.decode(textoJson) as Map<String, dynamic>;
    final itens = dados['perguntas'] as List;
    return itens
        .map((item) => Pergunta.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
