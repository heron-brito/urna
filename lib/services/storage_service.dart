import 'package:shared_preferences/shared_preferences.dart';

/// Persistência simples de progresso usando shared_preferences
/// (funciona em web e Android).
class StorageService {
  static const _kBestCoins = 'best_coins';
  static const _kGamesPlayed = 'games_played';
  static const _kBooksWon = 'books_won';
  static const _kMuted = 'muted';

  Future<int> bestCoins() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_kBestCoins) ?? 0;
  }

  Future<void> saveBestCoins(int coins) async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getInt(_kBestCoins) ?? 0;
    if (coins > current) {
      await prefs.setInt(_kBestCoins, coins);
    }
  }

  Future<int> gamesPlayed() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_kGamesPlayed) ?? 0;
  }

  Future<void> incrementGamesPlayed() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kGamesPlayed, (prefs.getInt(_kGamesPlayed) ?? 0) + 1);
  }

  Future<int> booksWon() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_kBooksWon) ?? 0;
  }

  Future<void> incrementBooksWon() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kBooksWon, (prefs.getInt(_kBooksWon) ?? 0) + 1);
  }

  Future<bool> isMuted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kMuted) ?? false;
  }

  Future<void> setMuted(bool muted) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kMuted, muted);
  }
}
