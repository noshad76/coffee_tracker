import 'package:flutter/material.dart';

import '../../core/models/coffee_theme_preset.dart';

/// Named semantic colors for a single Coffeeaholic theme preset.
@immutable
class CoffeePalette {
  const CoffeePalette({
    required this.brand50,
    required this.brand100,
    required this.brand200,
    required this.brand300,
    required this.brand400,
    required this.brand500,
    required this.brand600,
    required this.brand700,
    required this.brand900,
    required this.background,
    required this.surface,
    required this.surfaceRaised,
    required this.stone700,
    required this.stone800,
    required this.stone900,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.textSubtle,
    required this.stateSuccess,
    required this.stateSuccessStrong,
    required this.stateWarning,
    required this.stateWarningStrong,
    required this.stateDanger,
    required this.stateDangerStrong,
    required this.stateInfo,
    required this.stateInfoStrong,
    required this.overlay,
  });

  final Color brand50;
  final Color brand100;
  final Color brand200;
  final Color brand300;
  final Color brand400;
  final Color brand500;
  final Color brand600;
  final Color brand700;
  final Color brand900;
  final Color background;
  final Color surface;
  final Color surfaceRaised;
  final Color stone700;
  final Color stone800;
  final Color stone900;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color textSubtle;
  final Color stateSuccess;
  final Color stateSuccessStrong;
  final Color stateWarning;
  final Color stateWarningStrong;
  final Color stateDanger;
  final Color stateDangerStrong;
  final Color stateInfo;
  final Color stateInfoStrong;
  final Color overlay;

  CoffeePalette lerp(CoffeePalette other, double t) => CoffeePalette(
    brand50: Color.lerp(brand50, other.brand50, t)!,
    brand100: Color.lerp(brand100, other.brand100, t)!,
    brand200: Color.lerp(brand200, other.brand200, t)!,
    brand300: Color.lerp(brand300, other.brand300, t)!,
    brand400: Color.lerp(brand400, other.brand400, t)!,
    brand500: Color.lerp(brand500, other.brand500, t)!,
    brand600: Color.lerp(brand600, other.brand600, t)!,
    brand700: Color.lerp(brand700, other.brand700, t)!,
    brand900: Color.lerp(brand900, other.brand900, t)!,
    background: Color.lerp(background, other.background, t)!,
    surface: Color.lerp(surface, other.surface, t)!,
    surfaceRaised: Color.lerp(surfaceRaised, other.surfaceRaised, t)!,
    stone700: Color.lerp(stone700, other.stone700, t)!,
    stone800: Color.lerp(stone800, other.stone800, t)!,
    stone900: Color.lerp(stone900, other.stone900, t)!,
    textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
    textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
    textMuted: Color.lerp(textMuted, other.textMuted, t)!,
    textSubtle: Color.lerp(textSubtle, other.textSubtle, t)!,
    stateSuccess: Color.lerp(stateSuccess, other.stateSuccess, t)!,
    stateSuccessStrong: Color.lerp(
      stateSuccessStrong,
      other.stateSuccessStrong,
      t,
    )!,
    stateWarning: Color.lerp(stateWarning, other.stateWarning, t)!,
    stateWarningStrong: Color.lerp(
      stateWarningStrong,
      other.stateWarningStrong,
      t,
    )!,
    stateDanger: Color.lerp(stateDanger, other.stateDanger, t)!,
    stateDangerStrong: Color.lerp(
      stateDangerStrong,
      other.stateDangerStrong,
      t,
    )!,
    stateInfo: Color.lerp(stateInfo, other.stateInfo, t)!,
    stateInfoStrong: Color.lerp(stateInfoStrong, other.stateInfoStrong, t)!,
    overlay: Color.lerp(overlay, other.overlay, t)!,
  );
}

/// Exposes the active Coffeeaholic palette through the Flutter theme.
@immutable
class CoffeeThemeExtension extends ThemeExtension<CoffeeThemeExtension> {
  const CoffeeThemeExtension(this.palette);

  final CoffeePalette palette;

  @override
  CoffeeThemeExtension copyWith({CoffeePalette? palette}) =>
      CoffeeThemeExtension(palette ?? this.palette);

  @override
  CoffeeThemeExtension lerp(covariant CoffeeThemeExtension? other, double t) {
    if (other == null) return this;
    return CoffeeThemeExtension(palette.lerp(other.palette, t));
  }
}

abstract final class AppSpacing {
  static const double x1 = 4;
  static const double x1_5 = 6;
  static const double x2 = 8;
  static const double x2_5 = 10;
  static const double x3 = 12;
  static const double x3_5 = 14;
  static const double x4 = 16;
  static const double x5 = 20;
  static const double x6 = 24;
  static const double x8 = 32;
  static const double x10 = 40;
}

abstract final class AppRadii {
  static const double small = 6;
  static const double control = 12;
  static const double card = 16;
  static const double largeCard = 24;
  static const double sheetTop = 32;
}

abstract final class AppTargets {
  static const double minimumInteractive = 44;
}

abstract final class AppTheme {
  static const Color _white = Color(0xFFFFFFFF);
  static const Color _success = Color(0xFF34D399);
  static const Color _successStrong = Color(0xFF10B981);
  static const Color _warning = Color(0xFFFBBF24);
  static const Color _warningStrong = Color(0xFFF59E0B);
  static const Color _danger = Color(0xFFFB7185);
  static const Color _dangerStrong = Color(0xFFF43F5E);
  static const Color _info = Color(0xFF818CF8);
  static const Color _infoStrong = Color(0xFF6366F1);
  static const Color _overlay = Color(0xFF000000);

  static const Map<CoffeeThemePreset, CoffeePalette> palettes = {
    CoffeeThemePreset.coffee: CoffeePalette(
      brand50: Color(0xFFFDF8F5),
      brand100: Color(0xFFF5EBE1),
      brand200: Color(0xFFE7D5C4),
      brand300: Color(0xFFD5BAA0),
      brand400: Color(0xFFD5BAA0),
      brand500: Color(0xFF8C5A3C),
      brand600: Color(0xFF6E452D),
      brand700: Color(0xFF5A3622),
      brand900: Color(0xFF2E180E),
      background: Color(0xFF18120F),
      surface: Color(0xFF241B16),
      surfaceRaised: Color(0xFF322620),
      stone700: Color(0xFF44403C),
      stone800: Color(0xFF292524),
      stone900: Color(0xFF1C1917),
      textPrimary: _white,
      textSecondary: Color(0xFFD6D3D1),
      textMuted: Color(0xFFA8A29E),
      textSubtle: Color(0xFF78716C),
      stateSuccess: _success,
      stateSuccessStrong: _successStrong,
      stateWarning: _warning,
      stateWarningStrong: _warningStrong,
      stateDanger: _danger,
      stateDangerStrong: _dangerStrong,
      stateInfo: _info,
      stateInfoStrong: _infoStrong,
      overlay: _overlay,
    ),
    CoffeeThemePreset.ocean: CoffeePalette(
      brand50: Color(0xFFF2F8FB),
      brand100: Color(0xFFE3EFF5),
      brand200: Color(0xFFC7DEEA),
      brand300: Color(0xFF9CC4D9),
      brand400: Color(0xFF9CC4D9),
      brand500: Color(0xFF4F8FAE),
      brand600: Color(0xFF3E7391),
      brand700: Color(0xFF2C566E),
      brand900: Color(0xFF142A38),
      background: Color(0xFF0F1519),
      surface: Color(0xFF172128),
      surfaceRaised: Color(0xFF20303A),
      stone700: Color(0xFF2F4352),
      stone800: Color(0xFF1D2A33),
      stone900: Color(0xFF111A20),
      textPrimary: _white,
      textSecondary: Color(0xFFD6D3D1),
      textMuted: Color(0xFFA8A29E),
      textSubtle: Color(0xFF78716C),
      stateSuccess: _success,
      stateSuccessStrong: _successStrong,
      stateWarning: _warning,
      stateWarningStrong: _warningStrong,
      stateDanger: _danger,
      stateDangerStrong: _dangerStrong,
      stateInfo: _info,
      stateInfoStrong: _infoStrong,
      overlay: _overlay,
    ),
    CoffeeThemePreset.forest: CoffeePalette(
      brand50: Color(0xFFF3F8EE),
      brand100: Color(0xFFE3EFD7),
      brand200: Color(0xFFC9DFB2),
      brand300: Color(0xFFA5C97F),
      brand400: Color(0xFFA5C97F),
      brand500: Color(0xFF5E8F3E),
      brand600: Color(0xFF497330),
      brand700: Color(0xFF355524),
      brand900: Color(0xFF182A12),
      background: Color(0xFF0E1510),
      surface: Color(0xFF16211A),
      surfaceRaised: Color(0xFF1F3125),
      stone700: Color(0xFF2F4535),
      stone800: Color(0xFF1C2A20),
      stone900: Color(0xFF111A13),
      textPrimary: _white,
      textSecondary: Color(0xFFD6D3D1),
      textMuted: Color(0xFFA8A29E),
      textSubtle: Color(0xFF78716C),
      stateSuccess: _success,
      stateSuccessStrong: _successStrong,
      stateWarning: _warning,
      stateWarningStrong: _warningStrong,
      stateDanger: _danger,
      stateDangerStrong: _dangerStrong,
      stateInfo: _info,
      stateInfoStrong: _infoStrong,
      overlay: _overlay,
    ),
    CoffeeThemePreset.amber: CoffeePalette(
      brand50: Color(0xFFFFF9ED),
      brand100: Color(0xFFFBEFD3),
      brand200: Color(0xFFF3DCA8),
      brand300: Color(0xFFE8C27A),
      brand400: Color(0xFFE8C27A),
      brand500: Color(0xFFC98A2B),
      brand600: Color(0xFFA06E1F),
      brand700: Color(0xFF7A5217),
      brand900: Color(0xFF3A260A),
      background: Color(0xFF17120A),
      surface: Color(0xFF241C10),
      surfaceRaised: Color(0xFF33281A),
      stone700: Color(0xFF4A412F),
      stone800: Color(0xFF2E281C),
      stone900: Color(0xFF1C1810),
      textPrimary: _white,
      textSecondary: Color(0xFFD6D3D1),
      textMuted: Color(0xFFA8A29E),
      textSubtle: Color(0xFF78716C),
      stateSuccess: _success,
      stateSuccessStrong: _successStrong,
      stateWarning: _warning,
      stateWarningStrong: _warningStrong,
      stateDanger: _danger,
      stateDangerStrong: _dangerStrong,
      stateInfo: _info,
      stateInfoStrong: _infoStrong,
      overlay: _overlay,
    ),
  };

  static ThemeData build(CoffeeThemePreset preset) {
    final palette = palettes[preset]!;
    final baseTextTheme = Typography.material2021().white;

    return ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      colorScheme:
          ColorScheme.dark(
            primary: palette.brand500,
            onPrimary: _white,
            secondary: palette.brand300,
            onSecondary: palette.background,
            surface: palette.background,
            onSurface: palette.textPrimary,
            error: palette.stateDangerStrong,
            onError: _white,
          ).copyWith(
            surfaceTint: Colors.transparent,
            secondaryContainer: palette.surfaceRaised,
            onSecondaryContainer: palette.textPrimary,
            outline: palette.stone700,
          ),
      scaffoldBackgroundColor: palette.background,
      canvasColor: palette.background,
      cardColor: palette.surface,
      dividerColor: palette.stone800,
      fontFamily: 'Inter',
      textTheme: baseTextTheme
          .copyWith(
            displayLarge: baseTextTheme.displayLarge?.copyWith(
              color: palette.textPrimary,
              fontWeight: FontWeight.w900,
            ),
            headlineMedium: baseTextTheme.headlineMedium?.copyWith(
              color: palette.textPrimary,
              fontWeight: FontWeight.w700,
            ),
            titleLarge: baseTextTheme.titleLarge?.copyWith(
              color: palette.textPrimary,
              fontWeight: FontWeight.w700,
            ),
            titleMedium: baseTextTheme.titleMedium?.copyWith(
              color: palette.textPrimary,
              fontWeight: FontWeight.w600,
            ),
            bodyLarge: baseTextTheme.bodyLarge?.copyWith(
              color: palette.textSecondary,
            ),
            bodyMedium: baseTextTheme.bodyMedium?.copyWith(
              color: palette.textMuted,
            ),
            labelLarge: baseTextTheme.labelLarge?.copyWith(
              color: palette.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          )
          .apply(fontFamily: 'Inter'),
      extensions: [CoffeeThemeExtension(palette)],
    );
  }

  static CoffeePalette paletteOf(BuildContext context) =>
      Theme.of(context).extension<CoffeeThemeExtension>()!.palette;
}
