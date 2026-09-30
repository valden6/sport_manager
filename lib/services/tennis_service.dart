import 'dart:developer';

import 'package:health/health.dart';
import 'package:sport_manager/enumerations/sport_type.dart';
import 'package:sport_manager/enumerations/tennis_activity_type.dart';
import 'package:sport_manager/services/app_service.dart';
import 'package:sport_manager/services/calorie_service.dart';
import 'package:sport_manager/settings/global_storage.dart';

class TennisService {
  Future<bool> addTennisData({required TennisActivityType tennisActivityType, bool? match, DateTime? beginningSession, DateTime? endSession}) async {
    bool success = false;
    DateTime beginningTennisSession;
    DateTime endTennisSession;
    double hoursPlayed = 1;
    final DateTime now = DateTime.now();
    Health health = Health();
    final bool authorization = await appService.requestAuthorization();
    final double weight = await weightStorage.getWeight() ?? 70;

    if (tennisActivityType == TennisActivityType.lessons) {
      final DateTime monday = appService.getDay(now.subtract(Duration(days: now.weekday - 1)));
      final DateTime friday = appService.getDay(monday.add(const Duration(days: 4)));
      beginningTennisSession = friday.add(const Duration(hours: 19));
      endTennisSession = friday.add(Duration(hours: 19 + hoursPlayed.toInt(), minutes: 30));
    } else {
      if (beginningSession == null && endSession == null) {
        final DateTime monday = appService.getDay(now.subtract(Duration(days: now.weekday - 1)));
        final DateTime thursday = appService.getDay(monday.add(const Duration(days: 3)));
        beginningTennisSession = thursday.add(const Duration(hours: 21, minutes: 15));
        endTennisSession = thursday.add(Duration(hours: 21 + hoursPlayed.toInt(), minutes: 15));
      } else {
        beginningTennisSession = beginningSession!;
        endTennisSession = endSession!;
        hoursPlayed = endSession.difference(beginningTennisSession).inMinutes / 60;
      }
    }

    final SportType sportType = tennisActivityType.sportType;
    final double minutesPlayed = hoursPlayed * 60;
    final double kcalBurnedPerMin = calorieService.kcalBurnedPerMin(met: sportType.met, weight: weight);
    final int totalKcalBurned = calorieService.totalKcalBurned(met: sportType.met, weight: weight, minutes: minutesPlayed);
    final double totalSteps = calorieService.totalSteps(minutes: minutesPlayed, stepsPerMin: sportType.stepsPerMin);
    final int totalMeters = calorieService.totalMeters(steps: totalSteps);
    log("TennisActivityType: $tennisActivityType");
    log("beginningSession: $beginningTennisSession");
    log("endSession: $endTennisSession");
    log("kcalBurned per minute: $kcalBurnedPerMin");
    log("Hours played: $hoursPlayed");
    log("TotalkcalBurned: $totalKcalBurned");
    log("TotalSteps: $totalSteps");
    log("TotalMeters: $totalMeters");
    if (authorization) {
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

  static final TennisService _tennisService = TennisService._internal();
  factory TennisService() {
    return _tennisService;
  }
  TennisService._internal();
}

final TennisService tennisService = TennisService();
