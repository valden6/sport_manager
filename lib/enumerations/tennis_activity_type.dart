import 'package:sport_manager/enumerations/sport_type.dart';

enum TennisActivityType { double, simple, lessons }

extension TennisActivityTypeExtension on TennisActivityType {
  String get name {
    switch (this) {
      case TennisActivityType.lessons:
        return "Cours";
      case TennisActivityType.simple:
        return "Simple";
      case TennisActivityType.double:
        return "Double";
    }
  }

  SportType get sportType {
    switch (this) {
      case TennisActivityType.lessons:
        return SportType.tennisLessons;
      case TennisActivityType.simple:
        return SportType.tennisSimple;
      case TennisActivityType.double:
        return SportType.tennisDouble;
    }
  }

  double get met => sportType.met;

  int get stepsPerMin => sportType.stepsPerMin;
}

