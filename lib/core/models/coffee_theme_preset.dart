enum CoffeeThemePreset {
  coffee,
  ocean,
  forest,
  amber,
  coffeeLight,
  oceanLight,
  forestLight,
  amberLight;

  bool get isLight =>
      this == coffeeLight ||
      this == oceanLight ||
      this == forestLight ||
      this == amberLight;

  CoffeeThemePreset toLight() => switch (this) {
    coffee || coffeeLight => coffeeLight,
    ocean || oceanLight => oceanLight,
    forest || forestLight => forestLight,
    amber || amberLight => amberLight,
  };

  CoffeeThemePreset toDark() => switch (this) {
    coffee || coffeeLight => coffee,
    ocean || oceanLight => ocean,
    forest || forestLight => forest,
    amber || amberLight => amber,
  };

  CoffeeThemePreset basePreset() => switch (this) {
    coffee || coffeeLight => coffee,
    ocean || oceanLight => ocean,
    forest || forestLight => forest,
    amber || amberLight => amber,
  };
}
