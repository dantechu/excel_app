import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  // ═══════════════════════════════════════════════════════════════════════════
  // LIGHT THEME - Modern E-Learning Platform (Udemy-inspired)
  // Clean, professional with Excel green accents
  // ═══════════════════════════════════════════════════════════════════════════
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    // Color Scheme
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.excelGreen,
      brightness: Brightness.light,
      primary: AppColors.excelGreen,
      onPrimary: Colors.white,
      primaryContainer: AppColors.excelGreenLight.withValues(alpha: 0.12),
      onPrimaryContainer: AppColors.excelGreenDark,
      secondary: AppColors.excelAccent,
      onSecondary: Colors.white,
      secondaryContainer: AppColors.excelAccentLight.withValues(alpha: 0.15),
      onSecondaryContainer: AppColors.excelAccentDark,
      tertiary: AppColors.officeGray,
      onTertiary: AppColors.textPrimary,
      surface: AppColors.backgroundLight,
      onSurface: AppColors.textPrimary,
      surfaceContainerHighest: AppColors.cardBackground,
      onSurfaceVariant: AppColors.textSecondary,
      outline: AppColors.borderLight,
      outlineVariant: AppColors.dividerLight,
      error: AppColors.errorLight,
      onError: Colors.white,
    ),

    // Scaffold background - subtle off-white
    scaffoldBackgroundColor: AppColors.backgroundLight,

    // Typography - Inter with proper hierarchy
    textTheme: GoogleFonts.interTextTheme().copyWith(
      // Display - Large marketing headlines
      displayLarge: GoogleFonts.inter(
        fontSize: 40,
        fontWeight: FontWeight.w800,
        letterSpacing: -1.5,
        color: AppColors.textPrimary,
        height: 1.1,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
        color: AppColors.textPrimary,
        height: 1.2,
      ),
      displaySmall: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.25,
        color: AppColors.textPrimary,
        height: 1.2,
      ),
      // Headlines - Section titles
      headlineLarge: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.25,
        color: AppColors.textPrimary,
        height: 1.25,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        letterSpacing: 0,
        color: AppColors.textPrimary,
        height: 1.3,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        color: AppColors.textPrimary,
        height: 1.35,
      ),
      // Titles - Card titles, list items
      titleLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        letterSpacing: 0,
        color: AppColors.textPrimary,
        height: 1.4,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        color: AppColors.textPrimary,
        height: 1.4,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        color: AppColors.textPrimary,
        height: 1.4,
      ),
      // Body - Main content text
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.15,
        color: AppColors.textPrimary,
        height: 1.5,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.15,
        color: AppColors.textSecondary,
        height: 1.5,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.2,
        color: AppColors.textSecondary,
        height: 1.5,
      ),
      // Labels - Buttons, chips, captions
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        color: AppColors.textPrimary,
        height: 1.4,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.25,
        color: AppColors.textSecondary,
        height: 1.4,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.3,
        color: AppColors.textTertiary,
        height: 1.4,
      ),
    ),

    // Card theme - White cards on off-white background
    cardTheme: CardThemeData(
      elevation: 0,
      color: AppColors.cardBackground,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppColors.radiusMD),
        side: BorderSide(color: AppColors.dividerLight, width: 1),
      ),
    ),

    // App bar - Clean, minimal
    appBarTheme: AppBarTheme(
      centerTitle: false,
      elevation: 0,
      scrolledUnderElevation: 0.5,
      backgroundColor: AppColors.backgroundLight,
      surfaceTintColor: Colors.transparent,
      foregroundColor: AppColors.textPrimary,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.25,
        color: AppColors.textPrimary,
      ),
      iconTheme: IconThemeData(
        color: AppColors.textPrimary,
        size: 24,
      ),
    ),

    // Elevated Button - Primary action
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(120, 48),
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppColors.radiusSM),
        ),
        backgroundColor: AppColors.excelGreen,
        foregroundColor: Colors.white,
        textStyle: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
        ),
      ),
    ),

    // Outlined Button
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(120, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppColors.radiusSM),
        ),
        side: BorderSide(color: AppColors.borderLight, width: 1),
        foregroundColor: AppColors.textPrimary,
        textStyle: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
        ),
      ),
    ),

    // Text Button
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        minimumSize: const Size(64, 44),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppColors.radiusSM),
        ),
        foregroundColor: AppColors.excelGreen,
        textStyle: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
        ),
      ),
    ),

    // FAB
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.excelGreen,
      foregroundColor: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppColors.radiusLG),
      ),
    ),

    // Bottom Navigation
    navigationBarTheme: NavigationBarThemeData(
      indicatorColor: AppColors.excelGreen.withValues(alpha: 0.1),
      height: 64,
      backgroundColor: AppColors.cardBackground,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      labelTextStyle: WidgetStateProperty.resolveWith<TextStyle?>(
        (states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.excelGreen,
            );
          }
          return GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          );
        },
      ),
      iconTheme: WidgetStateProperty.resolveWith<IconThemeData?>(
        (states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: AppColors.excelGreen, size: 24);
          }
          return IconThemeData(color: AppColors.textSecondary, size: 24);
        },
      ),
    ),

    // Input Decoration
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.cardBackground,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppColors.radiusSM),
        borderSide: BorderSide(color: AppColors.borderLight),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppColors.radiusSM),
        borderSide: BorderSide(color: AppColors.borderLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppColors.radiusSM),
        borderSide: BorderSide(color: AppColors.excelGreen, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppColors.radiusSM),
        borderSide: BorderSide(color: AppColors.errorLight),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      hintStyle: GoogleFonts.inter(color: AppColors.textTertiary, fontSize: 14),
    ),

    // Chip Theme
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.cardBackground,
      selectedColor: AppColors.excelGreen.withValues(alpha: 0.1),
      labelStyle: GoogleFonts.inter(
        color: AppColors.textPrimary,
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
      secondaryLabelStyle: GoogleFonts.inter(color: AppColors.excelGreen),
      brightness: Brightness.light,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppColors.radiusFull),
        side: BorderSide(color: AppColors.borderLight),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),

    // Progress Indicator
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: AppColors.excelGreen,
      linearTrackColor: AppColors.excelGreen.withValues(alpha: 0.12),
      circularTrackColor: AppColors.excelGreen.withValues(alpha: 0.12),
    ),

    // Slider
    sliderTheme: SliderThemeData(
      activeTrackColor: AppColors.excelGreen,
      inactiveTrackColor: AppColors.excelGreen.withValues(alpha: 0.2),
      thumbColor: AppColors.excelGreen,
      overlayColor: AppColors.excelGreen.withValues(alpha: 0.1),
      trackHeight: 4,
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
    ),

    // Divider
    dividerTheme: DividerThemeData(
      color: AppColors.dividerLight,
      thickness: 1,
      space: 1,
    ),

    // Dialog
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.cardBackground,
      elevation: 16,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppColors.radiusLG),
      ),
    ),

    // Bottom Sheet
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: AppColors.cardBackground,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppColors.radiusXL),
        ),
      ),
    ),

    // Snackbar
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.textPrimary,
      contentTextStyle: GoogleFonts.inter(color: Colors.white, fontSize: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppColors.radiusSM),
      ),
      behavior: SnackBarBehavior.floating,
    ),

    // Switch
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith<Color?>(
        (states) => states.contains(WidgetState.selected) ? Colors.white : AppColors.textTertiary,
      ),
      trackColor: WidgetStateProperty.resolveWith<Color?>(
        (states) => states.contains(WidgetState.selected) ? AppColors.excelGreen : AppColors.dividerLight,
      ),
    ),

    // Checkbox
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color?>(
        (states) => states.contains(WidgetState.selected) ? AppColors.excelGreen : Colors.transparent,
      ),
      checkColor: WidgetStateProperty.all(Colors.white),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      side: BorderSide(color: AppColors.borderLight, width: 1.5),
    ),

    // Radio
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color?>(
        (states) => states.contains(WidgetState.selected) ? AppColors.excelGreen : AppColors.textSecondary,
      ),
    ),

    // List Tile
    listTileTheme: ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppColors.radiusMD),
      ),
    ),

    // Icon Theme
    iconTheme: IconThemeData(color: AppColors.textSecondary, size: 24),
    primaryIconTheme: IconThemeData(color: AppColors.excelGreen, size: 24),
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // DARK THEME
  // ═══════════════════════════════════════════════════════════════════════════
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.excelGreenLight,
      brightness: Brightness.dark,
      primary: AppColors.excelAccent,
      onPrimary: Colors.white,
      primaryContainer: AppColors.excelGreen.withValues(alpha: 0.25),
      onPrimaryContainer: AppColors.excelAccentLight,
      secondary: AppColors.excelAccentLight,
      onSecondary: AppColors.backgroundDark,
      secondaryContainer: AppColors.excelAccent.withValues(alpha: 0.25),
      onSecondaryContainer: AppColors.excelAccentLight,
      surface: AppColors.surfaceDark,
      onSurface: AppColors.textPrimaryDark,
      surfaceContainerHighest: AppColors.surfaceDarkAlt,
      onSurfaceVariant: AppColors.textSecondaryDark,
      outline: AppColors.borderDark,
      outlineVariant: AppColors.dividerDark,
      error: AppColors.errorDark,
      onError: AppColors.backgroundDark,
    ),

    scaffoldBackgroundColor: AppColors.backgroundDark,

    textTheme: GoogleFonts.interTextTheme().copyWith(
      displayLarge: GoogleFonts.inter(fontSize: 40, fontWeight: FontWeight.w800, letterSpacing: -1.5, color: AppColors.textPrimaryDark, height: 1.1),
      displayMedium: GoogleFonts.inter(fontSize: 32, fontWeight: FontWeight.w700, letterSpacing: -0.5, color: AppColors.textPrimaryDark, height: 1.2),
      displaySmall: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.w700, letterSpacing: -0.25, color: AppColors.textPrimaryDark, height: 1.2),
      headlineLarge: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w700, letterSpacing: -0.25, color: AppColors.textPrimaryDark, height: 1.25),
      headlineMedium: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w700, letterSpacing: 0, color: AppColors.textPrimaryDark, height: 1.3),
      headlineSmall: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600, letterSpacing: 0, color: AppColors.textPrimaryDark, height: 1.35),
      titleLarge: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, letterSpacing: 0, color: AppColors.textPrimaryDark, height: 1.4),
      titleMedium: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, letterSpacing: 0.1, color: AppColors.textPrimaryDark, height: 1.4),
      titleSmall: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.1, color: AppColors.textPrimaryDark, height: 1.4),
      bodyLarge: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.15, color: AppColors.textPrimaryDark, height: 1.5),
      bodyMedium: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.15, color: AppColors.textSecondaryDark, height: 1.5),
      bodySmall: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.2, color: AppColors.textSecondaryDark, height: 1.5),
      labelLarge: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.1, color: AppColors.textPrimaryDark, height: 1.4),
      labelMedium: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 0.25, color: AppColors.textSecondaryDark, height: 1.4),
      labelSmall: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500, letterSpacing: 0.3, color: AppColors.textTertiaryDark, height: 1.4),
    ),

    cardTheme: CardThemeData(
      elevation: 0,
      color: AppColors.surfaceDark,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppColors.radiusMD),
        side: BorderSide(color: AppColors.dividerDark, width: 1),
      ),
    ),

    appBarTheme: AppBarTheme(
      centerTitle: false,
      elevation: 0,
      scrolledUnderElevation: 0.5,
      backgroundColor: AppColors.backgroundDark,
      surfaceTintColor: Colors.transparent,
      foregroundColor: AppColors.textPrimaryDark,
      titleTextStyle: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700, letterSpacing: -0.25, color: AppColors.textPrimaryDark),
      iconTheme: IconThemeData(color: AppColors.textPrimaryDark, size: 24),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(120, 48),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppColors.radiusSM)),
        backgroundColor: AppColors.excelAccent,
        foregroundColor: Colors.white,
        textStyle: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(120, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppColors.radiusSM)),
        side: BorderSide(color: AppColors.borderDark, width: 1),
        foregroundColor: AppColors.textPrimaryDark,
        textStyle: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        minimumSize: const Size(64, 44),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppColors.radiusSM)),
        foregroundColor: AppColors.excelAccent,
        textStyle: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    ),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.excelAccent,
      foregroundColor: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppColors.radiusLG)),
    ),

    navigationBarTheme: NavigationBarThemeData(
      indicatorColor: AppColors.excelAccent.withValues(alpha: 0.15),
      height: 64,
      backgroundColor: AppColors.surfaceDark,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      labelTextStyle: WidgetStateProperty.resolveWith<TextStyle?>(
        (states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.excelAccent);
          }
          return GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textSecondaryDark);
        },
      ),
      iconTheme: WidgetStateProperty.resolveWith<IconThemeData?>(
        (states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: AppColors.excelAccent, size: 24);
          }
          return IconThemeData(color: AppColors.textSecondaryDark, size: 24);
        },
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surfaceDarkAlt,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppColors.radiusSM), borderSide: BorderSide(color: AppColors.borderDark)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppColors.radiusSM), borderSide: BorderSide(color: AppColors.borderDark)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppColors.radiusSM), borderSide: BorderSide(color: AppColors.excelAccent, width: 2)),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(AppColors.radiusSM), borderSide: BorderSide(color: AppColors.errorDark)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      hintStyle: GoogleFonts.inter(color: AppColors.textTertiaryDark, fontSize: 14),
    ),

    chipTheme: ChipThemeData(
      backgroundColor: AppColors.surfaceDarkAlt,
      selectedColor: AppColors.excelAccent.withValues(alpha: 0.2),
      labelStyle: GoogleFonts.inter(color: AppColors.textPrimaryDark, fontSize: 13, fontWeight: FontWeight.w500),
      secondaryLabelStyle: GoogleFonts.inter(color: AppColors.excelAccent),
      brightness: Brightness.dark,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppColors.radiusFull), side: BorderSide(color: AppColors.borderDark)),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),

    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: AppColors.excelAccent,
      linearTrackColor: AppColors.excelAccent.withValues(alpha: 0.2),
      circularTrackColor: AppColors.excelAccent.withValues(alpha: 0.2),
    ),

    sliderTheme: SliderThemeData(
      activeTrackColor: AppColors.excelAccent,
      inactiveTrackColor: AppColors.excelAccent.withValues(alpha: 0.25),
      thumbColor: AppColors.excelAccent,
      overlayColor: AppColors.excelAccent.withValues(alpha: 0.1),
      trackHeight: 4,
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
    ),

    dividerTheme: DividerThemeData(color: AppColors.dividerDark, thickness: 1, space: 1),

    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.surfaceDark,
      elevation: 16,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppColors.radiusLG)),
    ),

    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: AppColors.surfaceDark,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(AppColors.radiusXL))),
    ),

    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.surfaceDarkAlt,
      contentTextStyle: GoogleFonts.inter(color: AppColors.textPrimaryDark, fontSize: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppColors.radiusSM)),
      behavior: SnackBarBehavior.floating,
    ),

    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith<Color?>((states) => states.contains(WidgetState.selected) ? Colors.white : AppColors.textTertiaryDark),
      trackColor: WidgetStateProperty.resolveWith<Color?>((states) => states.contains(WidgetState.selected) ? AppColors.excelAccent : AppColors.dividerDark),
    ),

    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color?>((states) => states.contains(WidgetState.selected) ? AppColors.excelAccent : Colors.transparent),
      checkColor: WidgetStateProperty.all(Colors.white),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      side: BorderSide(color: AppColors.borderDark, width: 1.5),
    ),

    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color?>((states) => states.contains(WidgetState.selected) ? AppColors.excelAccent : AppColors.textSecondaryDark),
    ),

    listTileTheme: ListTileThemeData(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppColors.radiusMD)),
    ),

    iconTheme: IconThemeData(color: AppColors.textSecondaryDark, size: 24),
    primaryIconTheme: IconThemeData(color: AppColors.excelAccent, size: 24),
  );
}
