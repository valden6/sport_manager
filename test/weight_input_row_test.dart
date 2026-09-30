import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sport_manager/widgets/weight_input_row.dart';

void main() {
  Future<void> pumpRow(WidgetTester tester, TextEditingController controller, List<String> saved) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: WeightInputRow(controller: controller, onSave: saved.add),
        ),
      ),
    );
  }

  testWidgets('sauvegarde à chaque frappe, sans appuyer sur Done', (WidgetTester tester) async {
    final TextEditingController controller = TextEditingController();
    final List<String> saved = <String>[];
    await pumpRow(tester, controller, saved);

    await tester.enterText(find.byType(TextField), '7');
    await tester.enterText(find.byType(TextField), '75');

    expect(saved, <String>['7', '75']);

    controller.dispose();
  });

  testWidgets('sauvegarde à la validation Done', (WidgetTester tester) async {
    final TextEditingController controller = TextEditingController();
    final List<String> saved = <String>[];
    await pumpRow(tester, controller, saved);

    await tester.enterText(find.byType(TextField), '72');
    saved.clear();

    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();

    expect(saved, <String>['72']);

    controller.dispose();
  });

  testWidgets('sauvegarde quand on quitte le champ en touchant ailleurs', (WidgetTester tester) async {
    final TextEditingController controller = TextEditingController();
    final List<String> saved = <String>[];
    await pumpRow(tester, controller, saved);

    await tester.enterText(find.byType(TextField), '68');
    saved.clear();

    // Touche en dehors du champ de saisie : le champ perd le focus.
    await tester.tapAt(tester.getTopLeft(find.text('Poid actuel:')));
    await tester.pump();

    expect(saved, <String>['68']);

    controller.dispose();
  });
}
