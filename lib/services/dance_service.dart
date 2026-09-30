import 'dart:io';
import 'package:health/health.dart';
import 'package:sport_manager/enumerations/sport_type.dart';
import 'package:sport_manager/services/app_service.dart';
import 'package:sport_manager/services/calorie_service.dart';
import 'package:sport_manager/settings/global_storage.dart';

class DanceService {
  Future<bool> addDanceData() async {
    bool success = false;
    DateTime beginningTennisSession;
    DateTime endTennisSession;
    final DateTime now = DateTime.now();
    Health health = Health();
    final bool authorization = await appService.requestAuthorization();
    final double weight = await weightStorage.getWeight() ?? 70;

    final DateTime monday = appService.getDay(now.subtract(Duration(days: now.weekday - 1)));
    final DateTime wednesday = appService.getDay(monday.add(const Duration(days: 2)));
    beginningTennisSession = wednesday.add(const Duration(hours: 20, minutes: 30));
    endTennisSession = wednesday.add(const Duration(hours: 21, minutes: 30));

    const SportType sportType = SportType.dance;
    final int totalKcalBurned = calorieService.totalKcalBurned(met: sportType.met, weight: weight, minutes: 60);
    final double totalSteps = calorieService.totalSteps(minutes: 60, stepsPerMin: sportType.stepsPerMin);
    final int totalMeters = calorieService.totalMeters(steps: totalSteps);
    // log("beginningSession: $beginningTennisSession");
    // log("endSession: $endTennisSession");
    // log("kcalBurned per minute: $kcalBurnedPerMin");
    // log("TotalkcalBurned: $totalKcalBurned");
    // log("TotalSteps: $totalSteps");
    // log("TotalMeters: $totalMeters");
    if (authorization && Platform.isIOS) {
      final bool writeHealthDataDone1 = await health.writeHealthData(
        value: totalSteps,
        type: HealthDataType.STEPS,
        startTime: beginningTennisSession,
        endTime: endTennisSession,
      );
      final bool writeHealthDataDone2 = await health.writeHealthData(
        value: totalKcalBurned.toDouble(),
        type: HealthDataType.ACTIVE_ENERGY_BURNED,
        startTime: beginningTennisSession,
        endTime: endTennisSession,
        unit: HealthDataUnit.KILOCALORIE,
      );
      final bool writeHealthDataDone3 = await health.writeHealthData(
        value: totalMeters.toDouble(),
        type: HealthDataType.DISTANCE_WALKING_RUNNING,
        startTime: beginningTennisSession,
        endTime: endTennisSession,
        unit: HealthDataUnit.METER,
      );
      final bool writeWorkoutDataDone = await health.writeWorkoutData(
        activityType: sportType.healthWorkoutActivityType,
        start: beginningTennisSession,
        end: endTennisSession,
        totalEnergyBurned: totalKcalBurned,
        totalEnergyBurnedUnit: HealthDataUnit.KILOCALORIE,
        totalDistance: totalMeters,
        totalDistanceUnit: HealthDataUnit.METER,
      );
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
