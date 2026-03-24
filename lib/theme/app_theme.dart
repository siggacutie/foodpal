import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryAccent = Color(0xFF6ED69A); // Mint Green
  static const Color background = Color(0xFFFAFAFA); // Soft White
  static const Color slateGrey = Color(0xFF707070);
  static const Color textBlack = Color(0xFF2D2D2D);
  static const Color softShadow = Color(0x1A000000);

  // Animation Constants
  static const Duration animationDuration = Duration(milliseconds: 350);
  static const Curve animationCurve = Curves.easeInOutQuart; // Apple-like smooth curve
  static const Duration slowAnimationDuration = Duration(milliseconds: 450);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      textTheme: GoogleFonts.plusJakartaSansTextTheme().copyWith(
        displayLarge: GoogleFonts.plusJakartaSans(
          color: textBlack,
          fontWeight: FontWeight.w800,
          fontSize: 32,
          letterSpacing: -1,
        ),
        displayMedium: GoogleFonts.plusJakartaSans(
          color: textBlack,
          fontWeight: FontWeight.w800,
          fontSize: 24,
          letterSpacing: -0.5,
        ),
        bodyLarge: GoogleFonts.plusJakartaSans(
          color: textBlack,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        bodyMedium: GoogleFonts.plusJakartaSans(
          color: slateGrey,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        labelSmall: GoogleFonts.plusJakartaSans(
          color: slateGrey,
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.5,
        ),
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryAccent,
        primary: primaryAccent,
        surface: Colors.white,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        color: Colors.white,
      ),
    );
  }
}
