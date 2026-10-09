import 'package:flutter/material.dart';

import '../../core/models/coffee_theme_preset.dart';

/// Named semantic colors for a single Coffeeaholic theme preset.
@immutable
class CoffeePalette {
  const CoffeePalette({
    this.isDark = true,
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

  final bool isDark;
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
    isDark: t < 0.5 ? isDark : other.isDark,
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
  static const Color _darkOverlay = Color(0x99000000);
  static const Color _lightOverlay = Color(0x33000000);

  static const Map<CoffeeThemePreset, CoffeePalette> palettes = {
    // -------------------------------------------------------------
    // DARK PRESETS
    // -------------------------------------------------------------
    CoffeeThemePreset.coffee: CoffeePalette(
      isDark: true,
      brand50: Color(0xFFFDF8F4),
      brand100: Color(0xFFF7ECE2),
      brand200: Color(0xFFEEDBCB),
      brand300: Color(0xFFE2C4A8),
      brand400: Color(0xFFE2C4A8),
      brand500: Color(0xFFA6663E),
      brand600: Color(0xFF8B512E),
      brand700: Color(0xFF6B3C1F),
      brand900: Color(0xFF3A1E0E),
      background: Color(0xFF191310),
      surface: Color(0xFF261D18),
      surfaceRaised: Color(0xFF352922),
      stone700: Color(0xFF524036),
      stone800: Color(0xFF382B24),
      stone900: Color(0xFF1E1613),
      textPrimary: _white,
      textSecondary: Color(0xFFE5DDD6),
      textMuted: Color(0xFFAFA399),
      textSubtle: Color(0xFF82746B),
      stateSuccess: _success,
      stateSuccessStrong: _successStrong,
      stateWarning: _warning,
      stateWarningStrong: _warningStrong,
      stateDanger: _danger,
      stateDangerStrong: _dangerStrong,
      stateInfo: _info,
      stateInfoStrong: _infoStrong,
      overlay: _darkOverlay,
    ),
    CoffeeThemePreset.ocean: CoffeePalette(
      isDark: true,
      brand50: Color(0xFFF2F9FC),
      brand100: Color(0xFFE3F3F9),
      brand200: Color(0xFFC7E8F3),
      brand300: Color(0xFFA3D7E8),
      brand400: Color(0xFFA3D7E8),
      brand500: Color(0xFF459CB8),
      brand600: Color(0xFF358099),
      brand700: Color(0xFF266175),
      brand900: Color(0xFF112E3B),
      background: Color(0xFF0E161C),
      surface: Color(0xFF16232D),
      surfaceRaised: Color(0xFF203342),
      stone700: Color(0xFF334E63),
      stone800: Color(0xFF213442),
      stone900: Color(0xFF111D25),
      textPrimary: _white,
      textSecondary: Color(0xFFD6E2E9),
      textMuted: Color(0xFFA2B4C0),
      textSubtle: Color(0xFF758997),
      stateSuccess: _success,
      stateSuccessStrong: _successStrong,
      stateWarning: _warning,
      stateWarningStrong: _warningStrong,
      stateDanger: _danger,
      stateDangerStrong: _dangerStrong,
      stateInfo: _info,
      stateInfoStrong: _infoStrong,
      overlay: _darkOverlay,
    ),
    CoffeeThemePreset.forest: CoffeePalette(
      isDark: true,
      brand50: Color(0xFFF3FAF0),
      brand100: Color(0xFFE8F7DE),
      brand200: Color(0xFFD2EFC0),
      brand300: Color(0xFFB5E298),
      brand400: Color(0xFFB5E298),
      brand500: Color(0xFF67AA48),
      brand600: Color(0xFF528C37),
      brand700: Color(0xFF3C6A27),
      brand900: Color(0xFF1B3615),
      background: Color(0xFF0E1711),
      surface: Color(0xFF15251B),
      surfaceRaised: Color(0xFF1E3526),
      stone700: Color(0xFF33533D),
      stone800: Color(0xFF203527),
      stone900: Color(0xFF111E15),
      textPrimary: _white,
      textSecondary: Color(0xFFD5E3D4),
      textMuted: Color(0xFFA2B5A0),
      textSubtle: Color(0xFF748872),
      stateSuccess: _success,
      stateSuccessStrong: _successStrong,
      stateWarning: _warning,
      stateWarningStrong: _warningStrong,
      stateDanger: _danger,
      stateDangerStrong: _dangerStrong,
      stateInfo: _info,
      stateInfoStrong: _infoStrong,
      overlay: _darkOverlay,
    ),
    CoffeeThemePreset.amber: CoffeePalette(
      isDark: true,
      brand50: Color(0xFFFFF9EE),
      brand100: Color(0xFFFCF1D6),
      brand200: Color(0xFFFAE4B1),
      brand300: Color(0xFFF7D487),
      brand400: Color(0xFFF7D487),
      brand500: Color(0xFFD99426),
      brand600: Color(0xFFB27519),
      brand700: Color(0xFF8A570E),
      brand900: Color(0xFF452A07),
      background: Color(0xFF18130B),
      surface: Color(0xFF251E12),
      surfaceRaised: Color(0xFF352B1A),
      stone700: Color(0xFF524227),
      stone800: Color(0xFF362B19),
      stone900: Color(0xFF1D170C),
      textPrimary: _white,
      textSecondary: Color(0xFFE6DEC9),
      textMuted: Color(0xFFB3A88F),
      textSubtle: Color(0xFF857A64),
      stateSuccess: _success,
      stateSuccessStrong: _successStrong,
      stateWarning: _warning,
      stateWarningStrong: _warningStrong,
      stateDanger: _danger,
      stateDangerStrong: _dangerStrong,
      stateInfo: _info,
      stateInfoStrong: _infoStrong,
      overlay: _darkOverlay,
    ),

    // -------------------------------------------------------------
    // LIGHT PRESETS
    // -------------------------------------------------------------
    CoffeeThemePreset.coffeeLight: CoffeePalette(
      isDark: false,
      brand50: Color(0xFFFAF3EC),
      brand100: Color(0xFFEEDECF),
      brand200: Color(0xFF261912),
      brand300: Color(0xFF8A4620),
      brand400: Color(0xFF9E5429),
      brand500: Color(0xFF8A4620),
      brand600: Color(0xFF703617),
      brand700: Color(0xFF56280F),
      brand900: Color(0xFF361807),
      background: Color(0xFFFBF8F5),
      surface: Color(0xFFFFFFFF),
      surfaceRaised: Color(0xFFF3ECE4),
      stone700: Color(0xFFD8C7B7),
      stone800: Color(0xFFEAE0D6),
      stone900: Color(0xFFF7F2EC),
      textPrimary: Color(0xFF1E1510),
      textSecondary: Color(0xFF4A382E),
      textMuted: Color(0xFF664F42),
      textSubtle: Color(0xFF7D6556),
      stateSuccess: Color(0xFF059669),
      stateSuccessStrong: Color(0xFF047857),
      stateWarning: Color(0xFFD97706),
      stateWarningStrong: Color(0xFFB45309),
      stateDanger: Color(0xFFE11D48),
      stateDangerStrong: Color(0xFFBE123C),
      stateInfo: Color(0xFF4F46E5),
      stateInfoStrong: Color(0xFF4338CA),
      overlay: _lightOverlay,
    ),
    CoffeeThemePreset.oceanLight: CoffeePalette(
      isDark: false,
      brand50: Color(0xFFEFF7FB),
      brand100: Color(0xFFD0E8F4),
      brand200: Color(0xFF1E293B),
      brand300: Color(0xFF155E75),
      brand400: Color(0xFF0E7490),
      brand500: Color(0xFF0891B2),
      brand600: Color(0xFF0E7490),
      brand700: Color(0xFF155E75),
      brand900: Color(0xFF164E63),
      background: Color(0xFFF1F5F9),
      surface: Color(0xFFFFFFFF),
      surfaceRaised: Color(0xFFE2E8F0),
      stone700: Color(0xFFCBD5E1),
      stone800: Color(0xFFE2E8F0),
      stone900: Color(0xFFF1F5F9),
      textPrimary: Color(0xFF0F172A),
      textSecondary: Color(0xFF334155),
      textMuted: Color(0xFF475569),
      textSubtle: Color(0xFF64748B),
      stateSuccess: Color(0xFF059669),
      stateSuccessStrong: Color(0xFF047857),
      stateWarning: Color(0xFFD97706),
      stateWarningStrong: Color(0xFFB45309),
      stateDanger: Color(0xFFE11D48),
      stateDangerStrong: Color(0xFFBE123C),
      stateInfo: Color(0xFF4F46E5),
      stateInfoStrong: Color(0xFF4338CA),
      overlay: _lightOverlay,
    ),
    CoffeeThemePreset.forestLight: CoffeePalette(
      isDark: false,
      brand50: Color(0xFFF1F9EE),
      brand100: Color(0xFFD7EFCB),
      brand200: Color(0xFF152514),
      brand300: Color(0xFF2E751D),
      brand400: Color(0xFF3B8E27),
      brand500: Color(0xFF2E751D),
      brand600: Color(0xFF235C15),
      brand700: Color(0xFF18420E),
      brand900: Color(0xFF0E2808),
      background: Color(0xFFF4F8F3),
      surface: Color(0xFFFFFFFF),
      surfaceRaised: Color(0xFFE4EDE3),
      stone700: Color(0xFFC3D4C1),
      stone800: Color(0xFFDEE9DC),
      stone900: Color(0xFFF0F5EF),
      textPrimary: Color(0xFF122216),
      textSecondary: Color(0xFF2C4332),
      textMuted: Color(0xFF425E49),
      textSubtle: Color(0xFF5B7863),
      stateSuccess: Color(0xFF059669),
      stateSuccessStrong: Color(0xFF047857),
      stateWarning: Color(0xFFD97706),
      stateWarningStrong: Color(0xFFB45309),
      stateDanger: Color(0xFFE11D48),
      stateDangerStrong: Color(0xFFBE123C),
      stateInfo: Color(0xFF4F46E5),
      stateInfoStrong: Color(0xFF4338CA),
      overlay: _lightOverlay,
    ),
    CoffeeThemePreset.amberLight: CoffeePalette(
      isDark: false,
      brand50: Color(0xFFFDF7EB),
      brand100: Color(0xFFF7E2B7),
      brand200: Color(0xFF231707),
      brand300: Color(0xFFB45309),
      brand400: Color(0xFFD97706),
      brand500: Color(0xFFB45309),
      brand600: Color(0xFF92400E),
      brand700: Color(0xFF712B08),
      brand900: Color(0xFF451A03),
      background: Color(0xFFFBF8F2),
      surface: Color(0xFFFFFFFF),
      surfaceRaised: Color(0xFFF5ECDC),
      stone700: Color(0xFFDDCFBA),
      stone800: Color(0xFFEDE4D4),
      stone900: Color(0xFFF8F3EA),
      textPrimary: Color(0xFF231707),
      textSecondary: Color(0xFF4D381A),
      textMuted: Color(0xFF6B5029),
      textSubtle: Color(0xFF856637),
      stateSuccess: Color(0xFF059669),
      stateSuccessStrong: Color(0xFF047857),
      stateWarning: Color(0xFFD97706),
      stateWarningStrong: Color(0xFFB45309),
      stateDanger: Color(0xFFE11D48),
      stateDangerStrong: Color(0xFFBE123C),
      stateInfo: Color(0xFF4F46E5),
      stateInfoStrong: Color(0xFF4338CA),
      overlay: _lightOverlay,
    ),
  };

  static ThemeData build(CoffeeThemePreset preset) {
    final palette = palettes[preset]!;
    final baseTextTheme = palette.isDark
        ? Typography.material2021().white
        : Typography.material2021().black;

    return ThemeData(
      brightness: palette.isDark ? Brightness.dark : Brightness.light,
      useMaterial3: true,
      colorScheme:
          (palette.isDark
                  ? ColorScheme.dark(
                      primary: palette.brand500,
                      onPrimary: _white,
                      secondary: palette.brand300,
                      onSecondary: palette.background,
                      surface: palette.surface,
                      onSurface: palette.textPrimary,
                      error: palette.stateDangerStrong,
                      onError: _white,
                    )
                  : ColorScheme.light(
                      primary: palette.brand500,
                      onPrimary: _white,
                      secondary: palette.brand300,
                      onSecondary: palette.background,
                      surface: palette.surface,
                      onSurface: palette.textPrimary,
                      error: palette.stateDangerStrong,
                      onError: _white,
                    ))
              .copyWith(
                surfaceTint: Colors.transparent,
                secondaryContainer: palette.surfaceRaised,
                onSecondaryContainer: palette.textPrimary,
                outline: palette.stone700,
              ),
      scaffoldBackgroundColor: palette.background,
      canvasColor: palette.background,
      cardColor: palette.surface,
      dividerColor: palette.stone800,
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        modalBackgroundColor: Colors.transparent,
        modalBarrierColor: palette.overlay,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadii.sheetTop),
          ),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: palette.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.card),
          side: BorderSide(color: palette.stone700),
        ),
      ),
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
            titleSmall: baseTextTheme.titleSmall?.copyWith(
              color: palette.textPrimary,
              fontWeight: FontWeight.w600,
            ),
            bodyLarge: baseTextTheme.bodyLarge?.copyWith(
              color: palette.textSecondary,
            ),
            bodyMedium: baseTextTheme.bodyMedium?.copyWith(
              color: palette.textMuted,
            ),
            bodySmall: baseTextTheme.bodySmall?.copyWith(
              color: palette.textSubtle,
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
