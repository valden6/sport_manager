import 'package:health/health.dart';
import 'package:rxdart/rxdart.dart';

class AppService {
  final BehaviorSubject<int> streamHomeSportExerciceTotalTimer = BehaviorSubject<int>.seeded(0);

  Future<bool> requestAuthorization() async {
    List<HealthDataType> types = [
      HealthDataType.STEPS,
      HealthDataType.WORKOUT,
      HealthDataType.ACTIVE_ENERGY_BURNED,
      HealthDataType.DISTANCE_WALKING_RUNNING,
    ];
    List<HealthDataAccess> permissions = [
      HealthDataAccess.READ_WRITE,
      HealthDataAccess.READ_WRITE,
      HealthDataAccess.READ_WRITE,
      HealthDataAccess.READ_WRITE,
    ];
    return await Health().requestAuthorization(types, permissions: permissions);
  }

  DateTime getDay(DateTime d) {
    return DateTime(d.year, d.month, d.day);
  }

  String twoDigits(int n) => n.toString().padLeft(2, "0");

  String showTimer({required int seconde, bool showHours = true}) {
    String twoDigitHours = twoDigits(seconde ~/ 3600);
    String twoDigitMinutes = twoDigits((seconde ~/ 60) % 60);
    String twoDigitSeconde = twoDigits(seconde % 60);

    if (showHours) {
      return "$twoDigitHours:$twoDigitMinutes:$twoDigitSeconde";
    } else {
      return "$twoDigitMinutes:$twoDigitSeconde";
    }
  }

  static final AppService _appService = AppService._internal();
  factory AppService() {
    return _appService;
  }
  AppService._internal();
}

final AppService appService = AppService();
