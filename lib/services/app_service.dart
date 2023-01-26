import 'package:health/health.dart';

class AppService {

  Future<bool> requestAuthorization() async {
    HealthFactory health = HealthFactory();
    List<HealthDataType> types = [HealthDataType.STEPS,HealthDataType.WORKOUT,HealthDataType.ACTIVE_ENERGY_BURNED,HealthDataType.DISTANCE_WALKING_RUNNING];
    List<HealthDataAccess> permissions = [HealthDataAccess.READ_WRITE,HealthDataAccess.READ_WRITE,HealthDataAccess.READ_WRITE,HealthDataAccess.READ_WRITE];
    return await health.requestAuthorization(types, permissions: permissions);
  }

  DateTime getDay(DateTime d) {
    return DateTime(d.year, d.month, d.day);
  }

  static final AppService _appService = AppService._internal();
  factory AppService() {
    return _appService;
  }
  AppService._internal();
  
}

final AppService appService = AppService();