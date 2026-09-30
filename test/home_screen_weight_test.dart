import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sport_manager/screens/home_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    SharedPreferences.setMockInitialValues({});

    // flutter_tts n'a pas de plateforme native pendant les tests.
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('flutter_tts'),
      (MethodCall call) async => null,
    );
  });

  testWidgets('le poids saisi est conservé même sans appuyer sur Done', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
    await tester.pumpAndSettle();

    // Saisie du poids, sans jamais valider avec la touche "Done".
    await tester.enterText(find.byType(TextField), '75.5');
    await tester.pump();

    // Simule un redémarrage : on recrée HomeScreen avec un état neuf.
    await tester.pumpWidget(const SizedBox());
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
    await tester.pumpAndSettle();

    expect(find.widgetWithText(TextField, '75.5'), findsOneWidget);
  });
}
