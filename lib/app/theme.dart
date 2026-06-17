import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Charte de marque SunuDekk.
/// Toute valeur cosmetique (couleur, radius, ombre) doit etre piochee ici, pas
/// codee en dur dans les ecrans. Voir le brief de marque pour la justification
/// (baobab numerique, identite senegalaise, gouvernemental sobre).

// ── Palette de marque ──────────────────────────────────────────────────────
const Color sdGreenBaobab = Color(0xFF0D6E4D); // vert principal
const Color sdGreenDigital = Color(0xFF19A974); // vert secondaire / accent succes
const Color sdGoldTeranga = Color(0xFFF2B705); // doré accent excellence
const Color sdStoneGrey = Color(0xFF5B646D); // gris pierre
const Color sdLightGrey = Color(0xFFE9EEF0); // gris clair backgrounds
const Color sdSurface = Color(0xFFFFFFFF);
const Color sdScaffoldBg = Color(0xFFF6F8F7); // tres legere teinte verte
const Color sdRed = Color(0xFFD62828); // alertes / erreurs uniquement
const Color sdTextPrimary = Color(0xFF1A2330);
const Color sdTextSecondary = Color(0xFF5B646D);

// Aliases pour compatibilite avec l'ancien code (login, ErrorView).
const Color brandPrimary = sdGreenBaobab;
const Color brandSecondary = sdGreenDigital;
const Color brandSurface = sdScaffoldBg;
const Color brandError = sdRed;

// ── Rayons ──────────────────────────────────────────────────────────────────
const double sdRadiusSm = 8;
const double sdRadiusMd = 16;
const double sdRadiusLg = 24;

// ── Ombres : tres legeres, "gouvernemental sobre" ──────────────────────────
const List<BoxShadow> sdShadowSoft = [
  BoxShadow(
    color: Color(0x14000000),
    blurRadius: 12,
    offset: Offset(0, 4),
  ),
];

const List<BoxShadow> sdShadowSubtle = [
  BoxShadow(
    color: Color(0x0F000000),
    blurRadius: 6,
    offset: Offset(0, 2),
  ),
];

/// Typographies : Montserrat pour les titres, Inter pour le corps.
/// On ne fixe pas un TextStyle complet partout ; on laisse Material 3 deduire
/// l'echelle, mais on injecte les bonnes familles via `textTheme`.
TextTheme _buildTextTheme(ColorScheme scheme) {
  final base = ThemeData.light().textTheme.apply(
        bodyColor: sdTextPrimary,
        displayColor: sdTextPrimary,
      );
  final body = GoogleFonts.interTextTheme(base);
  // On surcharge uniquement les styles "titres" (display/headline/title) avec
  // Montserrat pour leur identite forte. Le reste reste en Inter.
  TextStyle title(TextStyle? s, FontWeight w) =>
      GoogleFonts.montserrat(textStyle: s, fontWeight: w);
  return body.copyWith(
    displayLarge: title(body.displayLarge, FontWeight.w700),
    displayMedium: title(body.displayMedium, FontWeight.w700),
    displaySmall: title(body.displaySmall, FontWeight.w700),
    headlineLarge: title(body.headlineLarge, FontWeight.w700),
    headlineMedium: title(body.headlineMedium, FontWeight.w700),
    headlineSmall: title(body.headlineSmall, FontWeight.w700),
    titleLarge: title(body.titleLarge, FontWeight.w600),
    titleMedium: title(body.titleMedium, FontWeight.w600),
    titleSmall: title(body.titleSmall, FontWeight.w600),
  );
}

ThemeData buildAppTheme() {
  final scheme = ColorScheme(
    brightness: Brightness.light,
    primary: sdGreenBaobab,
    onPrimary: Colors.white,
    primaryContainer: const Color(0xFFD5EDE2),
    onPrimaryContainer: sdGreenBaobab,
    secondary: sdGreenDigital,
    onSecondary: Colors.white,
    secondaryContainer: const Color(0xFFDFF6EA),
    onSecondaryContainer: sdGreenBaobab,
    tertiary: sdGoldTeranga,
    onTertiary: const Color(0xFF1F1500),
    tertiaryContainer: const Color(0xFFFFEFC2),
    onTertiaryContainer: const Color(0xFF1F1500),
    error: sdRed,
    onError: Colors.white,
    errorContainer: const Color(0xFFFADADA),
    onErrorContainer: sdRed,
    surface: sdSurface,
    onSurface: sdTextPrimary,
    surfaceContainerHighest: sdLightGrey,
    onSurfaceVariant: sdTextSecondary,
    outline: const Color(0xFFCDD6D9),
    outlineVariant: const Color(0xFFE2E8E6),
    shadow: Colors.black,
    scrim: Colors.black54,
    inverseSurface: sdTextPrimary,
    onInverseSurface: Colors.white,
    inversePrimary: sdGreenDigital,
  );

  final textTheme = _buildTextTheme(scheme);

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: sdScaffoldBg,
    textTheme: textTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: sdScaffoldBg,
      foregroundColor: sdTextPrimary,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      centerTitle: false,
      titleTextStyle: GoogleFonts.montserrat(
        color: sdTextPrimary,
        fontWeight: FontWeight.w700,
        fontSize: 18,
      ),
      iconTheme: const IconThemeData(color: sdTextPrimary),
    ),
    cardTheme: CardThemeData(
      color: sdSurface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(sdRadiusMd),
        side: const BorderSide(color: Color(0xFFE2E8E6)),
      ),
      margin: EdgeInsets.zero,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: sdSurface,
      hintStyle: GoogleFonts.inter(color: sdTextSecondary, fontSize: 14),
      labelStyle: GoogleFonts.inter(color: sdTextSecondary, fontSize: 14),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(sdRadiusSm),
        borderSide: const BorderSide(color: Color(0xFFCDD6D9)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(sdRadiusSm),
        borderSide: const BorderSide(color: Color(0xFFCDD6D9)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(sdRadiusSm),
        borderSide: const BorderSide(color: sdGreenBaobab, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(sdRadiusSm),
        borderSide: const BorderSide(color: sdRed),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(sdRadiusSm),
        borderSide: const BorderSide(color: sdRed, width: 1.5),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: sdGreenBaobab,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(sdRadiusSm),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: sdGreenBaobab,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(52),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(sdRadiusSm),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: sdGreenBaobab,
        side: const BorderSide(color: sdGreenBaobab, width: 1.2),
        minimumSize: const Size.fromHeight(48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(sdRadiusSm),
        ),
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: sdGreenBaobab,
        textStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: sdLightGrey,
      labelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: sdTextPrimary,
      ),
      side: BorderSide.none,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(sdRadiusSm),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: sdSurface,
      indicatorColor: const Color(0xFFD5EDE2),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return GoogleFonts.inter(
          fontSize: 11,
          fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
          color: selected ? sdGreenBaobab : sdTextSecondary,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return IconThemeData(
          color: selected ? sdGreenBaobab : sdTextSecondary,
          size: 22,
        );
      }),
      height: 68,
      surfaceTintColor: Colors.transparent,
      elevation: 8,
      shadowColor: Colors.black.withValues(alpha: 0.05),
    ),
    navigationRailTheme: NavigationRailThemeData(
      backgroundColor: sdSurface,
      selectedIconTheme: const IconThemeData(color: sdGreenBaobab, size: 24),
      unselectedIconTheme: const IconThemeData(color: sdTextSecondary, size: 24),
      selectedLabelTextStyle: GoogleFonts.inter(
        color: sdGreenBaobab,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelTextStyle: GoogleFonts.inter(
        color: sdTextSecondary,
        fontWeight: FontWeight.w500,
      ),
      indicatorColor: const Color(0xFFD5EDE2),
      useIndicator: true,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: sdSurface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(sdRadiusLg),
      ),
      titleTextStyle: GoogleFonts.montserrat(
        color: sdTextPrimary,
        fontWeight: FontWeight.w700,
        fontSize: 18,
      ),
      contentTextStyle: GoogleFonts.inter(color: sdTextPrimary, fontSize: 14),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: sdTextPrimary,
      contentTextStyle: GoogleFonts.inter(color: Colors.white, fontSize: 14),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(sdRadiusSm),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0xFFE2E8E6),
      thickness: 1,
      space: 1,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: sdGreenBaobab,
    ),
  );
}
