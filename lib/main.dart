import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sport_manager/home_screen.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = ThemeData(fontFamily: GoogleFonts.barlow().fontFamily);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme.copyWith(primaryColor: Colors.white, colorScheme: theme.colorScheme.copyWith(background: Colors.grey[100], primary: Colors.black, secondary: Colors.white, tertiary: const Color.fromARGB(255, 131, 215, 253))),
      localizationsDelegates: const [GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate],
      supportedLocales: const [Locale("fr", "FR")],
      home: const HomeScreen(),
    );
  }
}
