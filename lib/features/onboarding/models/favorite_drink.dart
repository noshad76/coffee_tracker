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
