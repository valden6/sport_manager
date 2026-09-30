import 'package:health/health.dart';

enum SportType { jumpRope, tennisLessons, tennisSimple, tennisDouble, dance }

extension SportTypeExtension on SportType {
  double get met {
    switch (this) {
      case SportType.jumpRope:
        return 11;
      case SportType.tennisLessons:
        return 7.3;
      case SportType.tennisSimple:
        return 8;
      case SportType.tennisDouble:
        return 6;
      case SportType.dance:
        return 5.5;
    }
  }

  int get stepsPerMin {
    switch (this) {
      case SportType.jumpRope:
        return 110;
      case SportType.tennisLessons:
        return 180;
      case SportType.tennisSimple:
        return 200;
      case SportType.tennisDouble:
        return 133;
      case SportType.dance:
        return 109;
    }
  }

  HealthWorkoutActivityType get healthWorkoutActivityType {
    switch (this) {
      case SportType.jumpRope:
        return HealthWorkoutActivityType.JUMP_ROPE;
      case SportType.tennisLessons:
      case SportType.tennisSimple:
      case SportType.tennisDouble:
        return HealthWorkoutActivityType.TENNIS;
      case SportType.dance:
        return HealthWorkoutActivityType.CARDIO_DANCE;
    }
  }
}
