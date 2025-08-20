import 'package:flutter/material.dart';

class AppTheme {
  // Modern Vibrant Color Palette
  static const Color primaryPurple = Color(0xFF6C5CE7);
  static const Color primaryBlue = Color(0xFF74B9FF);
  static const Color accentPink = Color(0xFFE84393);
  static const Color accentOrange = Color(0xFFE17055);
  static const Color accentGreen = Color(0xFF00B894);
  static const Color accentYellow = Color(0xFFFDCB6E);
  
  // Background colors
  static const Color lightBackground = Color(0xFFF8F9FA);
  static const Color darkBackground = Color(0xFF2D3436);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF636E72);
  
  // Text colors
  static const Color textDark = Color(0xFF2D3436);
  static const Color textLight = Color(0xFFDDD);
  static const Color textGrey = Color(0xFF636E72);
  
  // Status colors
  static const Color successGreen = Color(0xFF00B894);
  static const Color errorRed = Color(0xFFE74C3C);
  static const Color warningOrange = Color(0xFFE17055);
  static const Color infoBlue = Color(0xFF74B9FF);

  // Gradient definitions
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryPurple, primaryBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient accentGradient = LinearGradient(
    colors: [accentPink, accentOrange],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient successGradient = LinearGradient(
    colors: [accentGreen, accentYellow],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Light Theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primarySwatch: Colors.deepPurple,
    primaryColor: primaryPurple,
    scaffoldBackgroundColor: lightBackground,
    
    colorScheme: const ColorScheme.light(
      primary: primaryPurple,
      secondary: accentPink,
      tertiary: primaryBlue,
      surface: cardLight,
      background: lightBackground,
      error: errorRed,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: textDark,
      onBackground: textDark,
      onError: Colors.white,
      outline: textGrey,
    ),
    
    appBarTheme: AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.transparent,
      foregroundColor: textDark,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: textDark,
        letterSpacing: -0.5,
      ),
      iconTheme: const IconThemeData(color: textDark, size: 28),
    ),
    
    cardTheme: CardTheme(
      elevation: 12,
      shadowColor: primaryPurple.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      color: cardLight,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
    
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 8,
        shadowColor: primaryPurple.withOpacity(0.4),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ).copyWith(
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.pressed)) {
            return primaryBlue;
          }
          return primaryPurple;
        }),
        foregroundColor: MaterialStateProperty.all(Colors.white),
      ),
    ),
    
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryPurple,
        side: const BorderSide(color: primaryPurple, width: 2),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    ),
    
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: primaryPurple.withOpacity(0.3)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: primaryPurple.withOpacity(0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: primaryPurple, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      labelStyle: TextStyle(color: primaryPurple.withOpacity(0.8), fontWeight: FontWeight.w600),
      hintStyle: TextStyle(color: textGrey.withOpacity(0.6)),
    ),
    
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: primaryPurple,
      unselectedItemColor: textGrey,
      elevation: 20,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
    ),
    
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: accentPink,
      foregroundColor: Colors.white,
      elevation: 12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.bold,
        color: textDark,
        letterSpacing: -1,
      ),
      displayMedium: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: textDark,
        letterSpacing: -0.5,
      ),
      displaySmall: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: textDark,
      ),
      headlineLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: textDark,
      ),
      headlineMedium: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: textDark,
      ),
      headlineSmall: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textDark,
      ),
      titleLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textDark,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: textDark,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textGrey,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: textDark,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: textDark,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: textGrey,
      ),
    ),
  );

  // Dark Theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primarySwatch: Colors.deepPurple,
    primaryColor: primaryBlue,
    scaffoldBackgroundColor: darkBackground,
    
    colorScheme: const ColorScheme.dark(
      primary: primaryBlue,
      secondary: accentPink,
      tertiary: accentGreen,
      surface: cardDark,
      background: darkBackground,
      error: errorRed,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: textLight,
      onBackground: textLight,
      onError: Colors.white,
      outline: textGrey,
    ),
    
    appBarTheme: AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.transparent,
      foregroundColor: textLight,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: textLight,
        letterSpacing: -0.5,
      ),
      iconTheme: const IconThemeData(color: textLight, size: 28),
    ),
    
    cardTheme: CardTheme(
      elevation: 12,
      shadowColor: primaryBlue.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      color: cardDark,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),
    
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 8,
        shadowColor: primaryBlue.withOpacity(0.4),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ).copyWith(
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.pressed)) {
            return accentPink;
          }
          return primaryBlue;
        }),
        foregroundColor: MaterialStateProperty.all(Colors.white),
      ),
    ),
    
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryBlue,
        side: const BorderSide(color: primaryBlue, width: 2),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    ),
    
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: cardDark,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: primaryBlue.withOpacity(0.3)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: primaryBlue.withOpacity(0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: primaryBlue, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      labelStyle: TextStyle(color: primaryBlue.withOpacity(0.8), fontWeight: FontWeight.w600),
      hintStyle: TextStyle(color: textGrey.withOpacity(0.6)),
    ),
    
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: primaryBlue,
      unselectedItemColor: textGrey,
      elevation: 20,
      type: BottomNavigationBarType.fixed,
      backgroundColor: cardDark,
    ),
    
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: accentPink,
      foregroundColor: Colors.white,
      elevation: 12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.bold,
        color: textLight,
        letterSpacing: -1,
      ),
      displayMedium: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: textLight,
        letterSpacing: -0.5,
      ),
      displaySmall: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: textLight,
      ),
      headlineLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: textLight,
      ),
      headlineMedium: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: textLight,
      ),
      headlineSmall: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textLight,
      ),
      titleLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textLight,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: textLight,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textGrey,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: textLight,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: textLight,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: textGrey,
      ),
    ),
  );
  
  // Helper methods for gradients
  static BoxDecoration primaryGradientDecoration = const BoxDecoration(
    gradient: primaryGradient,
    borderRadius: BorderRadius.all(Radius.circular(20)),
  );
  
  static BoxDecoration accentGradientDecoration = const BoxDecoration(
    gradient: accentGradient,
    borderRadius: BorderRadius.all(Radius.circular(20)),
  );
  
  static BoxDecoration successGradientDecoration = const BoxDecoration(
    gradient: successGradient,
    borderRadius: BorderRadius.all(Radius.circular(20)),
  );
}