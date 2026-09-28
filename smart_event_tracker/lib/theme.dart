import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Design tokens taken from the ClearRoute Utility (SmartQueue) and
/// Workforce Blueprint (CrewMatch) DESIGN.md files.
class C {
  C._();
  static const primary = Color(0xFF2557A7);
  static const primaryDeep = Color(0xFF003A9B);
  static const navy = Color(0xFF003F8B);
  static const surface = Color(0xFFF8F9FF);
  static const blueLow = Color(0xFFEFF4FF);
  static const blue = Color(0xFFE5EEFF);
  static const blueHigh = Color(0xFFDCE9FF);
  static const blueSoft = Color(0xFFADC6FF);
  static const ink = Color(0xFF0F172A);
  static const slate700 = Color(0xFF334155);
  static const slate600 = Color(0xFF475569);
  static const slate500 = Color(0xFF64748B);
  static const slate400 = Color(0xFF94A3B8);
  static const slate300 = Color(0xFFCBD5E1);
  static const slate200 = Color(0xFFE2E8F0);
  static const slate100 = Color(0xFFF1F5F9);
  static const slate50 = Color(0xFFF8FAFC);
  static const white = Color(0xFFFFFFFF);
  static const green = Color(0xFF15803D);
  static const greenMid = Color(0xFF16A34A);
  static const greenBg = Color(0xFFDCFCE7);
  static const greenBg50 = Color(0xFFF0FDF4);
  static const greenBorder = Color(0xFFBBF7D0);
  static const amber = Color(0xFFB45309);
  static const amberBg = Color(0xFFFFFBEB);
  static const amberBorder = Color(0xFFFDE68A);
  static const red = Color(0xFFB91C1C);
  static const redBg = Color(0xFFFEF2F2);
  static const redBorder = Color(0xFFFECACA);
}

/// SmartQueue uses Inter, CrewMatch uses Noto Sans. Each shell sets this on init.
class AppFont {
  static String family = 'Inter';
}

TextStyle ts(
  double size, {
  FontWeight w = FontWeight.w400,
  Color color = C.ink,
  double? height,
  double? ls,
}) =>
    GoogleFonts.getFont(
      AppFont.family,
      fontSize: size,
      fontWeight: w,
      color: color,
      height: height,
      letterSpacing: ls,
    );

ThemeData buildTheme() => ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: C.primary, surface: C.surface),
      scaffoldBackgroundColor: C.surface,
      dividerColor: C.slate200,
      snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
    );
