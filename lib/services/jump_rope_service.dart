import 'dart:developer';

import 'package:health/health.dart';
import 'package:sport_manager/enumerations/sport_type.dart';
import 'package:sport_manager/services/app_service.dart';
import 'package:sport_manager/services/calorie_service.dart';
import 'package:sport_manager/settings/global_storage.dart';

class JumpRopeService {
  Future<bool> addJumpRopeData({required DateTime beginningSession, required DateTime endSession, required int effortSeconds}) async {
    bool success = false;
    Health health = Health();
    final bool authorization = await appService.requestAuthorization();
    final double weight = await weightStorage.getWeight() ?? 70;

    const SportType sportType = SportType.jumpRope;
    final double minutesEffort = effortSeconds / 60;
    final double kcalBurnedPerMin = calorieService.kcalBurnedPerMin(met: sportType.met, weight: weight);
    final int totalKcalBurned = calorieService.totalKcalBurned(met: sportType.met, weight: weight, minutes: minutesEffort);
    final double totalSteps = calorieService.totalSteps(minutes: minutesEffort, stepsPerMin: sportType.stepsPerMin);
    final int totalMeters = calorieService.totalMeters(steps: totalSteps);

    log("JumpRope beginningSession: $beginningSession");
    log("JumpRope endSession: $endSession");
    log("JumpRope effortSeconds: $effortSeconds");
    log("JumpRope kcalBurned per minute: $kcalBurnedPerMin");
    log("JumpRope TotalkcalBurned: $totalKcalBurned");
    log("JumpRope TotalSteps: $totalSteps");
    log("JumpRope TotalMeters: $totalMeters");

    if (authorization && minutesEffort > 0) {
      final bool writeHealthDataDone1 = await health.writeHealthData(
        value: totalSteps,
        type: HealthDataType.STEPS,
        startTime: beginningSession,
        endTime: endSession,
      );
      final bool writeHealthDataDone2 = await health.writeHealthData(
        value: totalKcalBurned.toDouble(),
        type: HealthDataType.ACTIVE_ENERGY_BURNED,
        startTime: beginningSession,
        endTime: endSession,
        unit: HealthDataUnit.KILOCALORIE,
      );
      final bool writeHealthDataDone3 = await health.writeHealthData(
        value: totalMeters.toDouble(),
        type: HealthDataType.DISTANCE_WALKING_RUNNING,
        startTime: beginningSession,
        endTime: endSession,
        unit: HealthDataUnit.METER,
      );
      final bool writeWorkoutDataDone = await health.writeWorkoutData(
        activityType: sportType.healthWorkoutActivityType,
        start: beginningSession,
        end: endSession,
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

  static final JumpRopeService _jumpRopeService = JumpRopeService._internal();
  factory JumpRopeService() {
    return _jumpRopeService;
  }
  JumpRopeService._internal();
}

final JumpRopeService jumpRopeService = JumpRopeService();