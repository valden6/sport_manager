enum TennisActivityType {
  double,
  simple,
  lessons,
}

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

  double get met {
    switch (this) {
      case TennisActivityType.lessons:
        return 7.3;
      case TennisActivityType.simple:
        return 8;
      case TennisActivityType.double:
        return 6;
    }
  }

  int get stepsPerMin {
    switch (this) {
      case TennisActivityType.lessons:
        return 180;
      case TennisActivityType.simple:
        return 200;
      case TennisActivityType.double:
        return 133;
    }
  }
}
