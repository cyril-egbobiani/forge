import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/main_navigation_screen.dart';

// --- Main App Setup ---
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Forward Nation App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        scaffoldBackgroundColor: const Color(0xFFFFFFFF),
        fontFamily: GoogleFonts.instrumentSans().fontFamily,
        appBarTheme: AppBarTheme(
          color: Colors.white,
          elevation: 0,
          titleTextStyle: GoogleFonts.instrumentSans(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        textTheme: GoogleFonts.instrumentSansTextTheme(
          TextTheme(
            titleLarge: GoogleFonts.instrumentSans(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: const Color(0xFF262626),
            ),
            titleMedium: GoogleFonts.instrumentSans(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: const Color(0xFF262626),
            ),
            bodyLarge: GoogleFonts.instrumentSans(
              fontSize: 16,
              color: const Color(0xFF262626),
            ),
            bodyMedium: GoogleFonts.instrumentSans(
              fontSize: 14,
              color: const Color(0xFF6F6F6F),
            ),
            bodySmall: GoogleFonts.instrumentSans(
              fontSize: 12,
              color: const Color(0xFFAAAAAA),
            ),
          ),
        ),
        useMaterial3: true,
      ),
      home: const MainNavigationScreen(),
    );
  }
}
