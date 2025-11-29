import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get darkTheme {
    const Color primaryBlue = Color(0xFF1A3A7D);
    const Color darkBlue = Color(0xFF0C101C);
    const Color surfaceBlue = Color(0xFF13192B);
    const Color dialogBlue = Color(0xFF1A2038);
    const Color highlightBlue = Color(0xFF27498C);

    final ThemeData base = ThemeData.dark();

    final TextTheme textTheme =
        GoogleFonts.poppinsTextTheme(base.textTheme).apply(
      bodyColor: Colors.white,
      displayColor: Colors.white,
    );

    return base.copyWith(
      primaryColor: primaryBlue,
      scaffoldBackgroundColor: darkBlue,
      canvasColor: darkBlue,
      splashColor: primaryBlue.withOpacity(0.1),
      highlightColor: highlightBlue.withOpacity(0.15),
      textTheme: textTheme,

      // AppBar escura com detalhes em azul
      appBarTheme: AppBarTheme(
        backgroundColor: surfaceBlue,
        elevation: 0,
        titleTextStyle: GoogleFonts.poppins(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      // Dialogs elegantes azulados
      dialogTheme: DialogThemeData(
        backgroundColor: dialogBlue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        titleTextStyle: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        contentTextStyle: GoogleFonts.poppins(
          color: Colors.white70,
          fontSize: 15,
        ),
      ),

      // Botões elevados com azul como destaque
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlue,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey.shade800,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 1,
        ),
      ),

      // Campos de texto com azul discreto
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceBlue,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryBlue.withOpacity(0.4)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryBlue.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryBlue, width: 1.6),
        ),
        labelStyle: const TextStyle(color: Colors.white70),
        hintStyle: const TextStyle(color: Colors.white38),
      ),

      // Ícones brancos para boa leitura
      iconTheme: const IconThemeData(color: Colors.white),

      // Cards azulados
      cardColor: surfaceBlue,
      cardTheme: CardThemeData(
        color: surfaceBlue,
        elevation: 2,
        margin: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      // Barra de navegação inferior
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: darkBlue,
        selectedItemColor: primaryBlue,
        unselectedItemColor: Colors.white70,
        showSelectedLabels: true,
        showUnselectedLabels: false,
      ),

      // Switches e radios azulados
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith(
          (states) => states.contains(MaterialState.selected)
              ? primaryBlue
              : Colors.white70,
        ),
        trackColor: MaterialStateProperty.resolveWith(
          (states) => states.contains(MaterialState.selected)
              ? primaryBlue.withOpacity(0.5)
              : Colors.grey.shade700,
        ),
      ),
    );
  }
}
