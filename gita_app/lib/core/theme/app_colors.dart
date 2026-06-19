import 'package:flutter/material.dart';

// ============================================================
//  AppColors — GitaSarathi Design System
//
//  Brand identity: Modern Spiritual · Premium Indian · Celestial Depth
//
//  Accent palette:
//    - Saffron  (#FF7A1A) — primary accent, devotional energy
//    - Gold     (#D4A017) — secondary accent, shimmer / highlights
//
//  Light mode:  Soft Ivory (#FAF7F0) — warm parchment feel
//  Dark mode:   Deep Indigo (#0D0F1E) — cosmic, celestial
//
//  Structural tokens (labels, separators, backgrounds) mirror the iOS
//  HIG layering model used in Koshly so the same widget patterns work.
//
//  Usage:
//    Color c = AppColors.saffron;
//    Color c = context.colors.label;   // via the extension below
// ============================================================

abstract class AppColors {
  AppColors._();

  // ── Brand / Accent ────────────────────────────────────────────────────
  /// Primary brand accent — Saffron. Use for CTAs, active tab indicators,
  /// primary buttons, and key interactive elements.
  static const Color saffron = Color(0xFFFF7A1A);

  /// Secondary accent — Gold. Use for highlights, shimmer effects,
  /// decorative dividers, and star/rating icons.
  static const Color gold = Color(0xFFD4A017);

  /// Darker saffron for light-mode pressed states / elevated contexts.
  static const Color saffronDeep = Color(0xFFE05E00);

  /// Lighter saffron for dark-mode — maintains contrast on deep indigo.
  static const Color saffronLight = Color(0xFFFF9A4D);

  /// Muted gold for dark-mode secondary use.
  static const Color goldLight = Color(0xFFEDBC4A);

  // ── Global ────────────────────────────────────────────────────────────
  static const Color whiteTransparent = Color(0x80FFFFFF); // 50% white
  static const Color blackTransparent = Color(0x80000000); // 50% black

  // ══ LIGHT MODE ════════════════════════════════════════════════════════

  // ── System Colors (light) ─────────────────────────────────────────────
  static const Color lightRed = Color(0xFFFF3B30);
  static const Color lightOrange = Color(0xFFFF9500);
  static const Color lightYellow = Color(0xFFFFCC00);
  static const Color lightGreen = Color(0xFF34C759);
  static const Color lightMint = Color(0xFF00C7BE);
  static const Color lightTeal = Color(0xFF30B0C7);
  static const Color lightCyan = Color(0xFF32ADE6);
  static const Color lightBlue = Color(0xFF007AFF);
  static const Color lightIndigo = Color(0xFF5856D6);
  static const Color lightPurple = Color(0xFFAF52DE);
  static const Color lightPink = Color(0xFFFF2D55);
  static const Color lightBrown = Color(0xFFA2845E);

  // ── Gray scale (light) — warm-tinted to harmonise with ivory BG ───────
  static const Color lightGray1 = Color(0xFF8E8881);
  static const Color lightGray2 = Color(0xFFAEA89F);
  static const Color lightGray3 = Color(0xFFC8C2B8);
  static const Color lightGray4 = Color(0xFFD6D0C6);
  static const Color lightGray5 = Color(0xFFE8E2D8);
  static const Color lightGray6 = Color(0xFFF5F0E8);

  // ── Labels (light) ────────────────────────────────────────────────────
  // Alpha values per iOS HIG: 100% / 60% / 30% / 18%
  static const Color lightLabel = Color(0xFF1A1208);         // warm black
  static const Color lightSecondaryLabel = Color(0x993D3020); // 60%
  static const Color lightTertiaryLabel = Color(0x4D3D3020);  // 30%
  static const Color lightQuaternaryLabel = Color(0x2E3D3020); // 18%

  // ── Backgrounds (light) — Soft Ivory layering ─────────────────────────
  static const Color lightSystemBackground = Color(0xFFFAF7F0);          // ivory base
  static const Color lightSecondarySystemBackground = Color(0xFFF2EDE2); // slightly deeper
  static const Color lightTertiarySystemBackground = Color(0xFFFAF7F0);  // same as base
  static const Color lightGroupedBackground = Color(0xFFF2EDE2);
  static const Color lightSecondaryGroupedBackground = Color(0xFFFAF7F0);
  static const Color lightTertiaryGroupedBackground = Color(0xFFF2EDE2);

  // ── Separators (light) — warm tint ────────────────────────────────────
  static const Color lightSeparator = Color(0x4A3D3020);      // 29% warm
  static const Color lightOpaqueSeparator = Color(0xFFCEC8BC); // 100%

  // ══ DARK MODE ═════════════════════════════════════════════════════════

  // ── System Colors (dark) ──────────────────────────────────────────────
  static const Color darkRed = Color(0xFFFF453A);
  static const Color darkOrange = Color(0xFFFF9F0A);
  static const Color darkYellow = Color(0xFFFFD60A);
  static const Color darkGreen = Color(0xFF30D158);
  static const Color darkMint = Color(0xFF63E6E2);
  static const Color darkTeal = Color(0xFF40CBE0);
  static const Color darkCyan = Color(0xFF64D2FF);
  static const Color darkBlue = Color(0xFF0A84FF);
  static const Color darkIndigo = Color(0xFF7B79F0);
  static const Color darkPurple = Color(0xFFBF5AF2);
  static const Color darkPink = Color(0xFFFF375F);
  static const Color darkBrown = Color(0xFFAC8E68);

  // ── Gray scale (dark) — indigo-tinted neutrals ────────────────────────
  static const Color darkGray1 = Color(0xFF9896A8);
  static const Color darkGray2 = Color(0xFF6C6A7C);
  static const Color darkGray3 = Color(0xFF4A4858);
  static const Color darkGray4 = Color(0xFF353444);
  static const Color darkGray5 = Color(0xFF1E1D2E);
  static const Color darkGray6 = Color(0xFF131222);

  // ── Labels (dark) ─────────────────────────────────────────────────────
  static const Color darkLabel = Color(0xFFF5F0E8);           // warm white
  static const Color darkSecondaryLabel = Color(0x99E8E0D5);  // 60%
  static const Color darkTertiaryLabel = Color(0x4DE8E0D5);   // 30%
  static const Color darkQuaternaryLabel = Color(0x29E8E0D5);  // 16%

  // ── Backgrounds (dark) — Deep Indigo layering ─────────────────────────
  static const Color darkSystemBackground = Color(0xFF0D0F1E);           // cosmic base
  static const Color darkSecondarySystemBackground = Color(0xFF161828);  // layer 1
  static const Color darkTertiarySystemBackground = Color(0xFF1F2135);   // layer 2
  static const Color darkGroupedBackground = Color(0xFF0D0F1E);
  static const Color darkSecondaryGroupedBackground = Color(0xFF161828);
  static const Color darkTertiaryGroupedBackground = Color(0xFF1F2135);

  // ── Separators (dark) ─────────────────────────────────────────────────
  static const Color darkSeparator = Color(0x66635F80);        // 40% indigo-tinted
  static const Color darkOpaqueSeparator = Color(0xFF2C2A40);  // 100%

  // ══ SEMANTIC / PRODUCT TOKENS ═════════════════════════════════════════

  /// Positive returns / success — warm green, avoids clash with saffron.
  static const Color lightGreenReturns = Color(0xFF1B7A3E);
  static const Color darkGreenReturns = Color(0xFF3DD068);

  /// Verse highlight / quote background tints
  static const Color lightVerseHighlight = Color(0x1AFF7A1A); // 10% saffron
  static const Color darkVerseHighlight = Color(0x26FF7A1A);  // 15% saffron

  /// Glassmorphism overlay base — used for frosted cards
  static const Color lightGlassOverlay = Color(0xB3FAF7F0); // 70% ivory
  static const Color darkGlassOverlay = Color(0xB30D0F1E);  // 70% deep indigo
}

// ============================================================
//  AppThemeColors — ThemeExtension for adaptive colors
//
//  Register in MaterialApp:
//    theme: ThemeData(extensions: [AppThemeColors.light], ...)
//    darkTheme: ThemeData(extensions: [AppThemeColors.dark], ...)
//
//  Read via the extension at the bottom of this file:
//    context.colors.label
//    context.colors.saffron
//    context.colors.gold
// ============================================================

class AppThemeColors extends ThemeExtension<AppThemeColors> {
  const AppThemeColors({
    required this.red,
    required this.orange,
    required this.yellow,
    required this.green,
    required this.mint,
    required this.teal,
    required this.cyan,
    required this.blue,
    required this.indigo,
    required this.purple,
    required this.pink,
    required this.brown,
    required this.gray1,
    required this.gray2,
    required this.gray3,
    required this.gray4,
    required this.gray5,
    required this.gray6,
    required this.label,
    required this.secondaryLabel,
    required this.tertiaryLabel,
    required this.quaternaryLabel,
    required this.systemBackground,
    required this.secondarySystemBackground,
    required this.tertiarySystemBackground,
    required this.groupedBackground,
    required this.secondaryGroupedBackground,
    required this.tertiaryGroupedBackground,
    required this.separator,
    required this.opaqueSeparator,
    required this.greenReturns,
    // ── GitaSarathi brand tokens ─────────────────────────────────────────
    required this.saffron,
    required this.gold,
    required this.verseHighlight,
    required this.glassOverlay,
  });

  // ── System colors ─────────────────────────────────────────────────────
  final Color red;
  final Color orange;
  final Color yellow;
  final Color green;
  final Color mint;
  final Color teal;
  final Color cyan;
  final Color blue;
  final Color indigo;
  final Color purple;
  final Color pink;
  final Color brown;

  // ── Grayscale ─────────────────────────────────────────────────────────
  final Color gray1;
  final Color gray2;
  final Color gray3;
  final Color gray4;
  final Color gray5;
  final Color gray6;

  // ── Labels ────────────────────────────────────────────────────────────
  final Color label;
  final Color secondaryLabel;
  final Color tertiaryLabel;
  final Color quaternaryLabel;

  // ── Backgrounds ───────────────────────────────────────────────────────
  final Color systemBackground;
  final Color secondarySystemBackground;
  final Color tertiarySystemBackground;
  final Color groupedBackground;
  final Color secondaryGroupedBackground;
  final Color tertiaryGroupedBackground;

  // ── Separators ────────────────────────────────────────────────────────
  final Color separator;
  final Color opaqueSeparator;

  // ── Semantic ──────────────────────────────────────────────────────────
  final Color greenReturns;

  // ── Brand (GitaSarathi) ───────────────────────────────────────────────
  /// Adaptive primary accent. Saffron in light, lighter saffron in dark.
  final Color saffron;

  /// Adaptive gold. Use for shimmer, decorative highlights, ratings.
  final Color gold;

  /// Tinted background for verse quote blocks.
  final Color verseHighlight;

  /// Glassmorphism frosted card overlay color.
  final Color glassOverlay;

  // ── Light preset ──────────────────────────────────────────────────────
  static const AppThemeColors light = AppThemeColors(
    red: AppColors.lightRed,
    orange: AppColors.lightOrange,
    yellow: AppColors.lightYellow,
    green: AppColors.lightGreen,
    mint: AppColors.lightMint,
    teal: AppColors.lightTeal,
    cyan: AppColors.lightCyan,
    blue: AppColors.lightBlue,
    indigo: AppColors.lightIndigo,
    purple: AppColors.lightPurple,
    pink: AppColors.lightPink,
    brown: AppColors.lightBrown,
    gray1: AppColors.lightGray1,
    gray2: AppColors.lightGray2,
    gray3: AppColors.lightGray3,
    gray4: AppColors.lightGray4,
    gray5: AppColors.lightGray5,
    gray6: AppColors.lightGray6,
    label: AppColors.lightLabel,
    secondaryLabel: AppColors.lightSecondaryLabel,
    tertiaryLabel: AppColors.lightTertiaryLabel,
    quaternaryLabel: AppColors.lightQuaternaryLabel,
    systemBackground: AppColors.lightSystemBackground,
    secondarySystemBackground: AppColors.lightSecondarySystemBackground,
    tertiarySystemBackground: AppColors.lightTertiarySystemBackground,
    groupedBackground: AppColors.lightGroupedBackground,
    secondaryGroupedBackground: AppColors.lightSecondaryGroupedBackground,
    tertiaryGroupedBackground: AppColors.lightTertiaryGroupedBackground,
    separator: AppColors.lightSeparator,
    opaqueSeparator: AppColors.lightOpaqueSeparator,
    greenReturns: AppColors.lightGreenReturns,
    saffron: AppColors.saffron,
    gold: AppColors.gold,
    verseHighlight: AppColors.lightVerseHighlight,
    glassOverlay: AppColors.lightGlassOverlay,
  );

  // ── Dark preset ───────────────────────────────────────────────────────
  static const AppThemeColors dark = AppThemeColors(
    red: AppColors.darkRed,
    orange: AppColors.darkOrange,
    yellow: AppColors.darkYellow,
    green: AppColors.darkGreen,
    mint: AppColors.darkMint,
    teal: AppColors.darkTeal,
    cyan: AppColors.darkCyan,
    blue: AppColors.darkBlue,
    indigo: AppColors.darkIndigo,
    purple: AppColors.darkPurple,
    pink: AppColors.darkPink,
    brown: AppColors.darkBrown,
    gray1: AppColors.darkGray1,
    gray2: AppColors.darkGray2,
    gray3: AppColors.darkGray3,
    gray4: AppColors.darkGray4,
    gray5: AppColors.darkGray5,
    gray6: AppColors.darkGray6,
    label: AppColors.darkLabel,
    secondaryLabel: AppColors.darkSecondaryLabel,
    tertiaryLabel: AppColors.darkTertiaryLabel,
    quaternaryLabel: AppColors.darkQuaternaryLabel,
    systemBackground: AppColors.darkSystemBackground,
    secondarySystemBackground: AppColors.darkSecondarySystemBackground,
    tertiarySystemBackground: AppColors.darkTertiarySystemBackground,
    groupedBackground: AppColors.darkGroupedBackground,
    secondaryGroupedBackground: AppColors.darkSecondaryGroupedBackground,
    tertiaryGroupedBackground: AppColors.darkTertiaryGroupedBackground,
    separator: AppColors.darkSeparator,
    opaqueSeparator: AppColors.darkOpaqueSeparator,
    greenReturns: AppColors.darkGreenReturns,
    saffron: AppColors.saffronLight,
    gold: AppColors.goldLight,
    verseHighlight: AppColors.darkVerseHighlight,
    glassOverlay: AppColors.darkGlassOverlay,
  );

  @override
  AppThemeColors copyWith({
    Color? red,
    Color? orange,
    Color? yellow,
    Color? green,
    Color? mint,
    Color? teal,
    Color? cyan,
    Color? blue,
    Color? indigo,
    Color? purple,
    Color? pink,
    Color? brown,
    Color? gray1,
    Color? gray2,
    Color? gray3,
    Color? gray4,
    Color? gray5,
    Color? gray6,
    Color? label,
    Color? secondaryLabel,
    Color? tertiaryLabel,
    Color? quaternaryLabel,
    Color? systemBackground,
    Color? secondarySystemBackground,
    Color? tertiarySystemBackground,
    Color? groupedBackground,
    Color? secondaryGroupedBackground,
    Color? tertiaryGroupedBackground,
    Color? separator,
    Color? opaqueSeparator,
    Color? greenReturns,
    Color? saffron,
    Color? gold,
    Color? verseHighlight,
    Color? glassOverlay,
  }) {
    return AppThemeColors(
      red: red ?? this.red,
      orange: orange ?? this.orange,
      yellow: yellow ?? this.yellow,
      green: green ?? this.green,
      mint: mint ?? this.mint,
      teal: teal ?? this.teal,
      cyan: cyan ?? this.cyan,
      blue: blue ?? this.blue,
      indigo: indigo ?? this.indigo,
      purple: purple ?? this.purple,
      pink: pink ?? this.pink,
      brown: brown ?? this.brown,
      gray1: gray1 ?? this.gray1,
      gray2: gray2 ?? this.gray2,
      gray3: gray3 ?? this.gray3,
      gray4: gray4 ?? this.gray4,
      gray5: gray5 ?? this.gray5,
      gray6: gray6 ?? this.gray6,
      label: label ?? this.label,
      secondaryLabel: secondaryLabel ?? this.secondaryLabel,
      tertiaryLabel: tertiaryLabel ?? this.tertiaryLabel,
      quaternaryLabel: quaternaryLabel ?? this.quaternaryLabel,
      systemBackground: systemBackground ?? this.systemBackground,
      secondarySystemBackground:
          secondarySystemBackground ?? this.secondarySystemBackground,
      tertiarySystemBackground:
          tertiarySystemBackground ?? this.tertiarySystemBackground,
      groupedBackground: groupedBackground ?? this.groupedBackground,
      secondaryGroupedBackground:
          secondaryGroupedBackground ?? this.secondaryGroupedBackground,
      tertiaryGroupedBackground:
          tertiaryGroupedBackground ?? this.tertiaryGroupedBackground,
      separator: separator ?? this.separator,
      opaqueSeparator: opaqueSeparator ?? this.opaqueSeparator,
      greenReturns: greenReturns ?? this.greenReturns,
      saffron: saffron ?? this.saffron,
      gold: gold ?? this.gold,
      verseHighlight: verseHighlight ?? this.verseHighlight,
      glassOverlay: glassOverlay ?? this.glassOverlay,
    );
  }

  @override
  AppThemeColors lerp(AppThemeColors? other, double t) {
    if (other is! AppThemeColors) return this;
    return AppThemeColors(
      red: Color.lerp(red, other.red, t)!,
      orange: Color.lerp(orange, other.orange, t)!,
      yellow: Color.lerp(yellow, other.yellow, t)!,
      green: Color.lerp(green, other.green, t)!,
      mint: Color.lerp(mint, other.mint, t)!,
      teal: Color.lerp(teal, other.teal, t)!,
      cyan: Color.lerp(cyan, other.cyan, t)!,
      blue: Color.lerp(blue, other.blue, t)!,
      indigo: Color.lerp(indigo, other.indigo, t)!,
      purple: Color.lerp(purple, other.purple, t)!,
      pink: Color.lerp(pink, other.pink, t)!,
      brown: Color.lerp(brown, other.brown, t)!,
      gray1: Color.lerp(gray1, other.gray1, t)!,
      gray2: Color.lerp(gray2, other.gray2, t)!,
      gray3: Color.lerp(gray3, other.gray3, t)!,
      gray4: Color.lerp(gray4, other.gray4, t)!,
      gray5: Color.lerp(gray5, other.gray5, t)!,
      gray6: Color.lerp(gray6, other.gray6, t)!,
      label: Color.lerp(label, other.label, t)!,
      secondaryLabel: Color.lerp(secondaryLabel, other.secondaryLabel, t)!,
      tertiaryLabel: Color.lerp(tertiaryLabel, other.tertiaryLabel, t)!,
      quaternaryLabel: Color.lerp(quaternaryLabel, other.quaternaryLabel, t)!,
      systemBackground:
          Color.lerp(systemBackground, other.systemBackground, t)!,
      secondarySystemBackground: Color.lerp(
          secondarySystemBackground, other.secondarySystemBackground, t)!,
      tertiarySystemBackground: Color.lerp(
          tertiarySystemBackground, other.tertiarySystemBackground, t)!,
      groupedBackground:
          Color.lerp(groupedBackground, other.groupedBackground, t)!,
      secondaryGroupedBackground: Color.lerp(
          secondaryGroupedBackground, other.secondaryGroupedBackground, t)!,
      tertiaryGroupedBackground: Color.lerp(
          tertiaryGroupedBackground, other.tertiaryGroupedBackground, t)!,
      separator: Color.lerp(separator, other.separator, t)!,
      opaqueSeparator: Color.lerp(opaqueSeparator, other.opaqueSeparator, t)!,
      greenReturns: Color.lerp(greenReturns, other.greenReturns, t)!,
      saffron: Color.lerp(saffron, other.saffron, t)!,
      gold: Color.lerp(gold, other.gold, t)!,
      verseHighlight: Color.lerp(verseHighlight, other.verseHighlight, t)!,
      glassOverlay: Color.lerp(glassOverlay, other.glassOverlay, t)!,
    );
  }
}

// ============================================================
//  Convenience extension
//
//  Usage:
//    Container(color: context.colors.systemBackground)
//    Text('ॐ', style: TextStyle(color: context.colors.saffron))
//    Icon(Icons.star, color: context.colors.gold)
// ============================================================
extension AppThemeColorsX on BuildContext {
  AppThemeColors get colors => Theme.of(this).extension<AppThemeColors>()!;
}

// ============================================================
//  Gradient helpers — frequently used saffron/gold gradients
//
//  Usage:
//    container.decoration = BoxDecoration(gradient: AppGradients.saffronGold)
// ============================================================
abstract class AppGradients {
  AppGradients._();

  /// Primary brand gradient — saffron → gold (horizontal)
  static const LinearGradient saffronGold = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [AppColors.saffron, AppColors.gold],
  );

  /// Vertical variant — use for hero sections / banners
  static const LinearGradient saffronGoldVertical = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [AppColors.saffron, AppColors.gold],
  );

  /// Subtle tinted gradient for light-mode cards
  static const LinearGradient lightCardShimmer = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFAF7F0), Color(0xFFF5EDD8)],
  );

  /// Dark cosmic card gradient — indigo layers
  static const LinearGradient darkCard = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF161828), Color(0xFF1F2135)],
  );

  /// Saffron glow — for active tab / selected state indicator
  static const RadialGradient saffronGlow = RadialGradient(
    colors: [Color(0x40FF7A1A), Color(0x00FF7A1A)],
    radius: 0.8,
  );
}
