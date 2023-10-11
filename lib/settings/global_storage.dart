import 'package:shared_preferences/shared_preferences.dart';

const String _storageKey = "Prefs_";
Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

class WeightStorage {
  Future<double?> getWeight() async {
    return _getApplicationSavedInformation();
  }

  Future<bool> setWeight(double weight) async {
    return _setApplicationSavedInformation(weight);
  }

  Future<double?> _getApplicationSavedInformation() async {
    final SharedPreferences prefs = await _prefs;
    double? weight;
    final String? storage = prefs.getString("${_storageKey}Weight");
    if (storage != null) {
      weight = double.parse(storage);
    }
    return weight;
  }

  Future<bool> _setApplicationSavedInformation(double value) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.setString("${_storageKey}Weight", value.toString());
  }

  static final WeightStorage _weightStorage = WeightStorage._internal();
  factory WeightStorage() {
    return _weightStorage;
  }
  WeightStorage._internal();
}

WeightStorage weightStorage = WeightStorage();

class GlobalNotificationSetting {
  Future<String?> getNotificationSetting() async {
    return _getApplicationSavedInformation();
  }

  Future<bool> setNotificationSetting({required bool activated}) async {
    return _setApplicationSavedInformation(activated: activated);
  }

  Future<String?> _getApplicationSavedInformation() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString("${_storageKey}Notification_Setting");
  }

  Future<bool> _setApplicationSavedInformation({required bool activated}) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.setString("${_storageKey}Notification_Setting", activated.toString());
  }

  static final GlobalNotificationSetting _notificationSetting = GlobalNotificationSetting._internal();
  factory GlobalNotificationSetting() {
    return _notificationSetting;
  }
  GlobalNotificationSetting._internal();
}

GlobalNotificationSetting notificationSetting = GlobalNotificationSetting();
