import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'game_state.dart';
import 'screens/main_menu_screen.dart';
import 'widgets/gradient_background.dart';
import 'utils/utils.dart';

void main() {
  runApp(ChangeNotifierProvider(create: (context) => GameState(), child: const CEOJourneyApp()));
}

class CEOJourneyApp extends StatelessWidget {
  const CEOJourneyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: scaffoldMessengerKey,
      title: 'CEO Journey',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.transparent, // Required for GradientBackground
        colorScheme: const ColorScheme.dark(primary: Color(0xFF536DFE), secondary: Color(0xFF00BFA5), surface: Color(0xFF0A192F)),
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme).apply(bodyColor: Colors.white, displayColor: Colors.white),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: const Color(0xFF536DFE),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
        cardTheme: CardThemeData(color: const Color.fromRGBO(22, 33, 62, 0.8), elevation: 2, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xFF536DFE)), borderRadius: BorderRadius.circular(10)),
        ),
        appBarTheme: const AppBarTheme(backgroundColor: Colors.transparent, elevation: 0, centerTitle: true, titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ),
      home: const GradientBackground(
        child: MainMenuScreen(),
      ),
    );
  }
}
