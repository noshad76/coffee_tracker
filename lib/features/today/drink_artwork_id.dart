import '../onboarding/models/favorite_drink.dart';

/// Resolves existing locally stored names without changing the database schema.
String drinkArtworkId(String name) {
  final normalized = name.trim().toLowerCase();
  for (final drink in FavoriteDrink.fullLogCatalog) {
    if (drink.name.toLowerCase() == normalized) return drink.id;
  }
  if (normalized == 'matcha latte') return 'matcha';
  if (normalized == 'cold brew') return 'coldbrew';
  return 'other';
}
