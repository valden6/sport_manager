enum HomeSportTarget { chest, legs, back, arms }

extension HomeSportTargetExtension on HomeSportTarget {
  String get text {
    switch (this) {
      case HomeSportTarget.chest:
        return "Poitrine";
      case HomeSportTarget.legs:
        return "Jambes";
      case HomeSportTarget.back:
        return "Dos";
      case HomeSportTarget.arms:
        return "Bras";
    }
  }
}
