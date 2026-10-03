class FavoriteDrink {
  const FavoriteDrink({
    required this.id,
    required this.name,
    required this.caffeineMg,
    required this.volumeMl,
  });

  final String id;
  final String name;
  final int caffeineMg;
  final int volumeMl;

  bool get isCustom => id.startsWith('custom:');

  String get artworkId {
    if (isCustom) {
      final parts = id.split(':');
      return parts.length >= 5 ? parts[4] : 'mug';
    }
    return id;
  }

  static String buildCustomId({
    required String name,
    required int caffeineMg,
    required int volumeMl,
    String artworkId = 'mug',
  }) {
    final encodedName = Uri.encodeComponent(name.trim());
    return 'custom:$encodedName:$caffeineMg:$volumeMl:$artworkId';
  }

  static FavoriteDrink? findById(String id) {
    if (id.startsWith('custom:')) {
      final parts = id.split(':');
      if (parts.length >= 4) {
        final name = Uri.decodeComponent(parts[1]);
        final caffeine = int.tryParse(parts[2]) ?? 80;
        final volume = int.tryParse(parts[3]) ?? 200;
        return FavoriteDrink(
          id: id,
          name: name.isEmpty ? 'Custom Drink' : name,
          caffeineMg: caffeine,
          volumeMl: volume,
        );
      }
    }

    final normalized = id == 'cold_brew' ? 'coldbrew' : id;
    for (final drink in fullLogCatalog) {
      if (drink.id == id || drink.id == normalized) return drink;
    }
    for (final drink in catalog) {
      if (drink.id == id || drink.id == normalized) return drink;
    }
    return null;
  }

  static const catalog = <FavoriteDrink>[
    FavoriteDrink(
      id: 'espresso',
      name: 'Espresso',
      caffeineMg: 75,
      volumeMl: 30,
    ),
    FavoriteDrink(
      id: 'americano',
      name: 'Americano',
      caffeineMg: 150,
      volumeMl: 250,
    ),
    FavoriteDrink(id: 'latte', name: 'Latte', caffeineMg: 120, volumeMl: 300),
    FavoriteDrink(
      id: 'matcha',
      name: 'Matcha Latte',
      caffeineMg: 70,
      volumeMl: 250,
    ),
    FavoriteDrink(id: 'tea', name: 'Black Tea', caffeineMg: 50, volumeMl: 200),
    FavoriteDrink(
      id: 'cold_brew',
      name: 'Cold Brew',
      caffeineMg: 200,
      volumeMl: 350,
    ),
  ];

  static const fullLogCatalog = <FavoriteDrink>[
    FavoriteDrink(
      id: 'blackcoffee',
      name: 'Black Coffee',
      caffeineMg: 95,
      volumeMl: 240,
    ),
    FavoriteDrink(
      id: 'espresso',
      name: 'Espresso',
      caffeineMg: 75,
      volumeMl: 30,
    ),
    FavoriteDrink(
      id: 'americano',
      name: 'Americano',
      caffeineMg: 150,
      volumeMl: 250,
    ),
    FavoriteDrink(id: 'latte', name: 'Latte', caffeineMg: 120, volumeMl: 300),
    FavoriteDrink(
      id: 'cappuccino',
      name: 'Cappuccino',
      caffeineMg: 80,
      volumeMl: 180,
    ),
    FavoriteDrink(
      id: 'icedlatte',
      name: 'Iced Latte',
      caffeineMg: 130,
      volumeMl: 350,
    ),
    FavoriteDrink(
      id: 'coldbrew',
      name: 'Cold Brew',
      caffeineMg: 200,
      volumeMl: 350,
    ),
    FavoriteDrink(id: 'matcha', name: 'Matcha', caffeineMg: 70, volumeMl: 250),
    FavoriteDrink(id: 'tea', name: 'Black Tea', caffeineMg: 50, volumeMl: 200),
    FavoriteDrink(
      id: 'energy',
      name: 'Energy Drink',
      caffeineMg: 80,
      volumeMl: 250,
    ),
    FavoriteDrink(id: 'other', name: 'Other', caffeineMg: 80, volumeMl: 200),
  ];
}
