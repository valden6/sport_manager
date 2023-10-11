import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sport_manager/home_screen.dart';
import 'package:sport_manager/services/notification_service.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  if (await FlutterAppBadger.isAppBadgeSupported()) {
    FlutterAppBadger.removeBadge();
  }
  runApp(const SportyApp());
}

class SportyApp extends StatefulWidget {
  const SportyApp({super.key});

  @override
  State<SportyApp> createState() => _SportyAppState();
}

class _SportyAppState extends State<SportyApp> {
  @override
  void initState() {
    super.initState();
    NotificationService.init(initShcheduled: true);
  }

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
