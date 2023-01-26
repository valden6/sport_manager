import 'package:health/health.dart';
import 'package:sport_manager/enumerations/tennis_activity_type.dart';
import 'package:sport_manager/services/app_service.dart';
import 'package:sport_manager/settings/global_storage.dart';

class TennisService {

  Future<bool> addTennisData({required TennisActivityType tennisActivityType, bool? match, DateTime? beginningSession, DateTime? endSession}) async {
    
    bool success = false;
    DateTime beginningTennisSession;
    DateTime endTennisSession;
    double hoursPlayed = 1;
    final DateTime now = DateTime.now();
    HealthFactory health = HealthFactory();
    final bool authorization = await appService.requestAuthorization();
    final double weight = await weightStorage.getWeight()?? 70;

    if(tennisActivityType == TennisActivityType.lessons){
      final DateTime monday = appService.getDay(now.subtract(Duration(days: now.weekday - 1)));
      final DateTime thursday = appService.getDay(monday.add(const Duration(days: 3)));
      beginningTennisSession = thursday.add(const Duration(hours: 20,minutes: 15));
      endTennisSession = thursday.add(Duration(hours: 20+hoursPlayed.toInt(),minutes: 15));
    } else {
      if(beginningSession == null && endSession == null){
        final DateTime monday = appService.getDay(now.subtract(Duration(days: now.weekday - 1)));
        final DateTime thursday = appService.getDay(monday.add(const Duration(days: 3)));
        beginningTennisSession = thursday.add(const Duration(hours: 21,minutes: 15));
        endTennisSession = thursday.add(Duration(hours: 21+hoursPlayed.toInt(),minutes: 15));
      } else {
        beginningTennisSession = beginningSession!;
        endTennisSession = endSession!;
        hoursPlayed = endSession.difference(beginningTennisSession).inMinutes/60;
      }
    }
    
    final double kcalBurnedPerMin = (tennisActivityType.met * weight* 3.5)/200;
    final int totalKcalBurned = ((hoursPlayed * 60) * kcalBurnedPerMin).round();
    final double totalSteps = ((hoursPlayed * 60) * tennisActivityType.stepsPerMin);
    final int totalMeters = (totalSteps * 0.762).round();
    // log("TennisActivityType: $tennisActivityType");
    // log("beginningSession: $beginningTennisSession");
    // log("endSession: $endTennisSession");
    // log("kcalBurned per minute: $kcalBurnedPerMin");
    // log("Hours played: $hoursPlayed");
    // log("TotalkcalBurned: $totalKcalBurned");
    // log("TotalSteps: $totalSteps");
    // log("TotalMeters: $totalMeters");
    if(authorization){
      final bool writeHealthDataDone1 = await health.writeHealthData(totalSteps, HealthDataType.STEPS, beginningTennisSession, endTennisSession);
      final bool writeHealthDataDone2 = await health.writeHealthData(totalKcalBurned.toDouble(), HealthDataType.ACTIVE_ENERGY_BURNED, beginningTennisSession, endTennisSession,unit: HealthDataUnit.KILOCALORIE);
      final bool writeHealthDataDone3 = await health.writeHealthData(totalMeters.toDouble(), HealthDataType.DISTANCE_WALKING_RUNNING, beginningTennisSession, endTennisSession,unit: HealthDataUnit.METER);
      final bool writeWorkoutDataDone = await health.writeWorkoutData(HealthWorkoutActivityType.TENNIS,beginningTennisSession,endTennisSession,totalEnergyBurned: totalKcalBurned,totalEnergyBurnedUnit: HealthDataUnit.KILOCALORIE,totalDistance: totalMeters,totalDistanceUnit: HealthDataUnit.METER);
      if(writeHealthDataDone1 && writeHealthDataDone2 && writeHealthDataDone3 && writeWorkoutDataDone){
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