import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sport_manager/settings/global_storage.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // IMPORTANT : ce mock doit être posé AVANT la première lecture de `weightStorage`,
  // car global_storage.dart capture le Future<SharedPreferences> une seule fois
  // au premier accès (variable top-level, initialisation paresseuse).
  // On pré-remplit avec la valeur d'une "session précédente" pour simuler un
  // redémarrage de l'app.
  SharedPreferences.setMockInitialValues({"Prefs_Weight": "63.5"});

  test('getWeight() restitue le poids enregistré par une session précédente', () async {
    // Doit passer AVANT le test suivant qui modifie la valeur.
    expect(await weightStorage.getWeight(), 63.5);
  });

  test('setWeight() rend le poids relisible (aller-retour)', () async {
    await weightStorage.setWeight(75.5);
    expect(await weightStorage.getWeight(), 75.5);
  });

  test('le poids est écrit sous la clé Persistante attendue', () async {
    await weightStorage.setWeight(80);

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // `setWeight` stocke un double : `toString()` produit "80.0".
    expect(prefs.getString('Prefs_Weight'), '80.0');
    expect(await weightStorage.getWeight(), 80);
  });
}
