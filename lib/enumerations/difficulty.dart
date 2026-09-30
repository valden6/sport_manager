enum Difficulty { beginner, intermediate, advanced }

extension DifficultyExtension on Difficulty {
  String get text {
    switch (this) {
      case Difficulty.beginner:
        return "Débutant";
      case Difficulty.intermediate:
        return "Intermédiaire";
      case Difficulty.advanced:
        return "Avnancé";
    }
  }
}
