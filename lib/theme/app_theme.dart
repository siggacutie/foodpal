import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryAccent = Color(0xFF6ED69A); // Mint Green
  static const Color background = Color(0xFFFAFAFA); // Soft White
  static const Color slateGrey = Color(0xFF707070);
  static const Color textBlack = Color(0xFF2D2D2D);
  static const Color softShadow = Color(0x1A000000);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      textTheme: GoogleFonts.plusJakartaSansTextTheme().copyWith(
        displayLarge: GoogleFonts.plusJakartaSans(
          color: textBlack,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
        bodyLarge: GoogleFonts.plusJakartaSans(
          color: textBlack,
          fontSize: 16,
        ),
        bodyMedium: GoogleFonts.plusJakartaSans(
          color: slateGrey,
          fontSize: 14,
        ),
        labelSmall: GoogleFonts.plusJakartaSans(
          color: slateGrey,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryAccent,
        primary: primaryAccent,
        surface: Colors.white,
      ),
    );
  }
}
