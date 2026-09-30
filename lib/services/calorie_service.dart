class CalorieService {
  /// kcal/min = (MET * poids(kg) * 3.5) / 200
  double kcalBurnedPerMin({required double met, required double weight}) {
    return (met * weight * 3.5) / 200;
  }

  int totalKcalBurned({required double met, required double weight, required double minutes}) {
    return (minutes * kcalBurnedPerMin(met: met, weight: weight)).round();
  }

  double totalSteps({required double minutes, required int stepsPerMin}) {
    return minutes * stepsPerMin;
  }

  /// Longueur moyenne d'une foulée : 0.762 m
  int totalMeters({required double steps}) {
    return (steps * 0.762).round();
  }

  static final CalorieService _calorieService = CalorieService._internal();
  factory CalorieService() {
    return _calorieService;
  }
  CalorieService._internal();
}

final CalorieService calorieService = CalorieService();
