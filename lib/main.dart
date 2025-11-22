import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'utils/app_colors.dart';
import 'services/audio_service.dart';
import 'services/game_tracking_service.dart';
import 'widgets/auth_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize audio service
  await TeachingAudioService().init();

  // Initialize game tracking service
  await GameTrackingService.instance.initialize();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Forge',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
        fontFamily: GoogleFonts.archivo().fontFamily,
        scaffoldBackgroundColor: Colors.black, // Main screen background
        colorScheme: const ColorScheme.dark(
          brightness: Brightness.dark,
          primary: AppColors.primary,
          background: Colors.black, // Screen background
          surface: AppColors.surface,
          onBackground: Colors.white,
          onSurface: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black, // AppBar background
          foregroundColor: Colors.white,
        ),
        // ),
        // bottomSheetTheme: const BottomSheetThemeData(
        //   backgroundColor: Colors.black,
        //   surfaceTintColor: Colors.black,
        //   modalBackgroundColor: Colors.black,
        // ),
        popupMenuTheme: const PopupMenuThemeData(
          color: Colors.black,
          surfaceTintColor: Colors.black,
        ),
        drawerTheme: const DrawerThemeData(
          backgroundColor: Colors.black,
          surfaceTintColor: Colors.black,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        fontFamily: GoogleFonts.archivo().fontFamily,
        scaffoldBackgroundColor: Colors.black,
        colorScheme: const ColorScheme.dark(
          brightness: Brightness.dark,
          primary: AppColors.primary,
          background: Colors.black,
          surface: Colors.black,
          surfaceVariant: Colors.black,
          surfaceTint: Colors.black,
          onBackground: Colors.white,
          onSurface: Colors.white,
        ),
      ),
      themeMode: ThemeMode.dark,
      home: const AuthWrapper(),
    );
  }
}
