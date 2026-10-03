import '../onboarding/models/favorite_drink.dart';

/// Resolves artwork identifier for a drink, handling custom drinks, encoded cupStyles,
/// and fallback catalog items.
String drinkArtworkId(
  String name, {
  String? cupStyle,
  Iterable<FavoriteDrink>? favorites,
}) {
  // 1. Check if cupStyle contains encoded artwork e.g. "artwork:matcha"
  if (cupStyle != null && cupStyle.startsWith('artwork:')) {
    final art = cupStyle.substring('artwork:'.length).trim();
    if (art.isNotEmpty) return art;
  }

  final normalized = name.trim().toLowerCase();

  // 2. Check user's favorite drinks (handles custom drinks by name!)
  if (favorites != null) {
    for (final fav in favorites) {
      if (fav.name.trim().toLowerCase() == normalized) {
        return fav.artworkId;
      }
    }
  }

  // 3. Match against standard catalogs
  for (final drink in FavoriteDrink.fullLogCatalog) {
    if (drink.name.toLowerCase() == normalized) return drink.id;
  }
  for (final drink in FavoriteDrink.catalog) {
    if (drink.name.toLowerCase() == normalized) return drink.id;
  }
  if (normalized == 'matcha latte') return 'matcha';
  if (normalized == 'cold brew') return 'coldbrew';
  if (normalized == 'black coffee') return 'blackcoffee';
  if (normalized == 'iced latte') return 'icedlatte';
  return 'other';
}
