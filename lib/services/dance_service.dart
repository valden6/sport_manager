import 'dart:io';

import 'package:health/health.dart';
import 'package:sport_manager/services/app_service.dart';
import 'package:sport_manager/settings/global_storage.dart';

class DanceService {
  Future<bool> addDanceData() async {
    bool success = false;
    DateTime beginningTennisSession;
    DateTime endTennisSession;
    final DateTime now = DateTime.now();
    HealthFactory health = HealthFactory();
    final bool authorization = await appService.requestAuthorization();
    final double weight = await weightStorage.getWeight() ?? 70;

    final DateTime monday = appService.getDay(now.subtract(Duration(days: now.weekday - 1)));
    final DateTime wednesday = appService.getDay(monday.add(const Duration(days: 2)));
    beginningTennisSession = wednesday.add(const Duration(hours: 19, minutes: 30));
    endTennisSession = wednesday.add(const Duration(hours: 20, minutes: 30));

    const double met = 5.5;
    final double kcalBurnedPerMin = (met * weight * 3.5) / 200;
    final int totalKcalBurned = ((1 * 60) * kcalBurnedPerMin).round();
    const double totalSteps = ((1 * 60) * 109);
    final int totalMeters = (totalSteps * 0.762).round();
    // log("beginningSession: $beginningTennisSession");
    // log("endSession: $endTennisSession");
    // log("kcalBurned per minute: $kcalBurnedPerMin");
    // log("TotalkcalBurned: $totalKcalBurned");
    // log("TotalSteps: $totalSteps");
    // log("TotalMeters: $totalMeters");
    if (authorization && Platform.isIOS) {
      final bool writeHealthDataDone1 = await health.writeHealthData(totalSteps, HealthDataType.STEPS, beginningTennisSession, endTennisSession);
      final bool writeHealthDataDone2 = await health.writeHealthData(totalKcalBurned.toDouble(), HealthDataType.ACTIVE_ENERGY_BURNED, beginningTennisSession, endTennisSession, unit: HealthDataUnit.KILOCALORIE);
      final bool writeHealthDataDone3 = await health.writeHealthData(totalMeters.toDouble(), HealthDataType.DISTANCE_WALKING_RUNNING, beginningTennisSession, endTennisSession, unit: HealthDataUnit.METER);
      final bool writeWorkoutDataDone = await health.writeWorkoutData(HealthWorkoutActivityType.WALKING, beginningTennisSession, endTennisSession,
          totalEnergyBurned: totalKcalBurned, totalEnergyBurnedUnit: HealthDataUnit.KILOCALORIE, totalDistance: totalMeters, totalDistanceUnit: HealthDataUnit.METER);
      if (writeHealthDataDone1 && writeHealthDataDone2 && writeHealthDataDone3 && writeWorkoutDataDone) {
        success = true;
      }
    } else {
      await appService.requestAuthorization();
    }
    return success;
  }

  static final DanceService _danceService = DanceService._internal();
  factory DanceService() {
    return _danceService;
  }
  DanceService._internal();
}

final DanceService danceService = DanceService();
