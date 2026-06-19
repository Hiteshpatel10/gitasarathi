import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

// ============================================================
//  AppTheme — GitaSarathi Design System
//
//  Design intent: Modern Spiritual · Premium Indian · Celestial Depth
//  - Backgrounds / labels / separators: iOS HIG-style layering tokens
//  - Primary accent: Saffron — CTAs, active tabs, primary buttons
//  - Secondary accent: Gold — highlights, shimmer, decorative elements
//  - Typography: Lora (serif display) + Inter (body) — scripture meets clarity
//  - surfaceTint: transparent — no M3 elevation colour-washing
//
//  Usage in MaterialApp.router:
//    theme: AppTheme.light,
//    darkTheme: AppTheme.dark,
// ============================================================

abstract final class AppTheme {
  AppTheme._();

  // ── Typography ─────────────────────────────────────────────────────────────
  // Lora — elegant serif for verse titles / chapter headings (devotional feel)
  // Inter — clean sans-serif for body text / UI labels (modern readability)
  //
  // Usage pattern:
  //   chapter title  → GoogleFonts.lora(...)
  //   verse text     → GoogleFonts.lora(fontStyle: FontStyle.italic, ...)
  //   UI labels      → default textTheme (Inter)
  //   Sanskrit glyphs → GoogleFonts.notoSansDevanagari(...)

  static TextTheme _buildTextTheme(TextTheme base) {
    // Inter for all UI text; Lora is applied per-widget for display use.
    return GoogleFonts.interTextTheme(base).copyWith(
      // Large display — chapter numbers, hero titles
      displayLarge: GoogleFonts.lora(
        textStyle: base.displayLarge,
        fontWeight: FontWeight.w700,
      ),
      displayMedium: GoogleFonts.lora(
        textStyle: base.displayMedium,
        fontWeight: FontWeight.w700,
      ),
      displaySmall: GoogleFonts.lora(
        textStyle: base.displaySmall,
        fontWeight: FontWeight.w600,
      ),
      // Headlines — section titles
      headlineLarge: GoogleFonts.lora(
        textStyle: base.headlineLarge,
        fontWeight: FontWeight.w600,
      ),
      headlineMedium: GoogleFonts.lora(
        textStyle: base.headlineMedium,
        fontWeight: FontWeight.w600,
      ),
      headlineSmall: GoogleFonts.lora(
        textStyle: base.headlineSmall,
        fontWeight: FontWeight.w600,
      ),
      // Titles — card headers, list section headers (Inter, semi-bold)
      titleLarge: GoogleFonts.inter(
        textStyle: base.titleLarge,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: GoogleFonts.inter(
        textStyle: base.titleMedium,
        fontWeight: FontWeight.w600,
      ),
      titleSmall: GoogleFonts.inter(
        textStyle: base.titleSmall,
        fontWeight: FontWeight.w500,
      ),
      // Body — verse translations, descriptions (Inter, regular)
      bodyLarge: GoogleFonts.inter(textStyle: base.bodyLarge),
      bodyMedium: GoogleFonts.inter(textStyle: base.bodyMedium),
      bodySmall: GoogleFonts.inter(textStyle: base.bodySmall),
      // Labels — UI chips, badges, metadata
      labelLarge: GoogleFonts.inter(
        textStyle: base.labelLarge,
        fontWeight: FontWeight.w500,
      ),
      labelMedium: GoogleFonts.inter(textStyle: base.labelMedium),
      labelSmall: GoogleFonts.inter(textStyle: base.labelSmall),
    );
  }

  // ── Light theme ────────────────────────────────────────────────────────────
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: _lightScheme,
        extensions: const [AppThemeColors.light],
        scaffoldBackgroundColor: AppColors.lightSystemBackground,
        textTheme: _buildTextTheme(ThemeData.light().textTheme),

        // ── AppBar ───────────────────────────────────────────────────────────
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.lightSystemBackground,
          foregroundColor: AppColors.lightLabel,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            // Lora for the app bar title — reinforces spiritual identity
            fontFamily: 'Lora',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.lightLabel,
          ),
        ),

        // ── Cards ────────────────────────────────────────────────────────────
        cardTheme: const CardThemeData(
          color: AppColors.lightSecondaryGroupedBackground,
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
        ),

        // ── Dividers ─────────────────────────────────────────────────────────
        dividerTheme: const DividerThemeData(
          color: AppColors.lightSeparator,
          thickness: 0.5,
          space: 0,
        ),

        // ── Navigation bar ───────────────────────────────────────────────────
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: AppColors.lightSystemBackground,
          indicatorColor: AppColors.saffron.withAlpha(28), // 11% saffron tint
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(color: AppColors.saffron);
            }
            return const IconThemeData(color: AppColors.lightGray1);
          }),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const TextStyle(
                color: AppColors.saffron,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              );
            }
            return const TextStyle(
              color: AppColors.lightGray1,
              fontSize: 12,
            );
          }),
        ),

        // ── FAB ──────────────────────────────────────────────────────────────
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.saffron,
          foregroundColor: Colors.white,
          elevation: 0,
          focusElevation: 0,
          hoverElevation: 0,
          highlightElevation: 0,
          shape: CircleBorder(),
        ),

        // ── Chips ────────────────────────────────────────────────────────────
        chipTheme: ChipThemeData(
          backgroundColor: AppColors.lightGray6,
          selectedColor: AppColors.saffron.withAlpha(30),
          labelStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
          side: BorderSide.none,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
        ),

        // ── Elevated buttons ─────────────────────────────────────────────────
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.saffron,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            textStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),

        // ── Text buttons ─────────────────────────────────────────────────────
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.saffron,
            textStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),

        // ── Input fields ─────────────────────────────────────────────────────
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.lightSecondarySystemBackground,
          border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide(color: AppColors.lightSeparator),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide(color: AppColors.lightSeparator),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide(color: AppColors.saffron, width: 1.5),
          ),
          hintStyle: const TextStyle(color: AppColors.lightGray1),
        ),

        // ── Bottom sheet ─────────────────────────────────────────────────────
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: AppColors.lightSystemBackground,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
        ),

        // ── Dialog ───────────────────────────────────────────────────────────
        dialogTheme: const DialogThemeData(
          backgroundColor: AppColors.lightSystemBackground,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
        ),
      );

  // ── Dark theme ─────────────────────────────────────────────────────────────
  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: _darkScheme,
        extensions: const [AppThemeColors.dark],
        scaffoldBackgroundColor: AppColors.darkSystemBackground,
        textTheme: _buildTextTheme(ThemeData.dark().textTheme),

        // ── AppBar ───────────────────────────────────────────────────────────
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.darkSystemBackground,
          foregroundColor: AppColors.darkLabel,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontFamily: 'Lora',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.darkLabel,
          ),
        ),

        // ── Cards ────────────────────────────────────────────────────────────
        cardTheme: const CardThemeData(
          color: AppColors.darkSecondaryGroupedBackground,
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
        ),

        // ── Dividers ─────────────────────────────────────────────────────────
        dividerTheme: const DividerThemeData(
          color: AppColors.darkSeparator,
          thickness: 0.5,
          space: 0,
        ),

        // ── Navigation bar ───────────────────────────────────────────────────
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: AppColors.darkSystemBackground,
          indicatorColor: AppColors.saffronLight.withAlpha(36), // 14% saffron
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const IconThemeData(color: AppColors.saffronLight);
            }
            return const IconThemeData(color: AppColors.darkGray1);
          }),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const TextStyle(
                color: AppColors.saffronLight,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              );
            }
            return const TextStyle(
              color: AppColors.darkGray1,
              fontSize: 12,
            );
          }),
        ),

        // ── FAB ──────────────────────────────────────────────────────────────
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.saffronLight,
          foregroundColor: Colors.white,
          elevation: 0,
          focusElevation: 0,
          hoverElevation: 0,
          highlightElevation: 0,
          shape: CircleBorder(),
        ),

        // ── Chips ────────────────────────────────────────────────────────────
        chipTheme: ChipThemeData(
          backgroundColor: AppColors.darkGray5,
          selectedColor: AppColors.saffronLight.withAlpha(40),
          labelStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
          side: BorderSide.none,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
        ),

        // ── Elevated buttons ─────────────────────────────────────────────────
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.saffronLight,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            textStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),

        // ── Text buttons ─────────────────────────────────────────────────────
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.saffronLight,
            textStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),

        // ── Input fields ─────────────────────────────────────────────────────
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.darkSecondarySystemBackground,
          border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide(color: AppColors.darkSeparator),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide(color: AppColors.darkSeparator),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide(color: AppColors.saffronLight, width: 1.5),
          ),
          hintStyle: const TextStyle(color: AppColors.darkGray1),
        ),

        // ── Bottom sheet ─────────────────────────────────────────────────────
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: AppColors.darkSecondarySystemBackground,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
        ),

        // ── Dialog ───────────────────────────────────────────────────────────
        dialogTheme: const DialogThemeData(
          backgroundColor: AppColors.darkSecondarySystemBackground,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
        ),
      );

  // ── Light ColorScheme ──────────────────────────────────────────────────────
  static final ColorScheme _lightScheme = ColorScheme.fromSeed(
    seedColor: AppColors.saffron,
  ).copyWith(
    primary: AppColors.saffron,
    onPrimary: Colors.white,
    secondary: AppColors.gold,
    onSecondary: Colors.white,
    surface: AppColors.lightSystemBackground,
    onSurface: AppColors.lightLabel,
    surfaceContainerLow: AppColors.lightSecondarySystemBackground,
    surfaceContainerHighest: AppColors.lightTertiarySystemBackground,
    onSurfaceVariant: AppColors.lightSecondaryLabel,
    outline: AppColors.lightSeparator,
    outlineVariant: AppColors.lightOpaqueSeparator,
    error: AppColors.lightRed,
    onError: Colors.white,
    // THE KEY: no M3 blue-washing on elevated surfaces
    surfaceTint: Colors.transparent,
  );

  // ── Dark ColorScheme ───────────────────────────────────────────────────────
  static final ColorScheme _darkScheme = ColorScheme.fromSeed(
    seedColor: AppColors.saffronLight,
    brightness: Brightness.dark,
  ).copyWith(
    primary: AppColors.saffronLight,
    onPrimary: Colors.white,
    secondary: AppColors.goldLight,
    onSecondary: Colors.white,
    surface: AppColors.darkSystemBackground,
    onSurface: AppColors.darkLabel,
    surfaceContainerLow: AppColors.darkSecondarySystemBackground,
    surfaceContainerHighest: AppColors.darkTertiarySystemBackground,
    onSurfaceVariant: AppColors.darkSecondaryLabel,
    outline: AppColors.darkSeparator,
    outlineVariant: AppColors.darkOpaqueSeparator,
    error: AppColors.darkRed,
    onError: Colors.white,
    surfaceTint: Colors.transparent,
  );
}
