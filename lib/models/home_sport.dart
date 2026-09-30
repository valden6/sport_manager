import 'package:sport_manager/enumerations/difficulty.dart';
import 'package:sport_manager/enumerations/home_sport_target.dart';
import 'package:sport_manager/models/home_exercise.dart';

class HomeSport {
  final String img;
  final int duration;
  final Difficulty difficulty;
  final HomeSportTarget target;
  final List<HomeExercise> exercises;

  HomeSport({required this.img, required this.duration, required this.difficulty, required this.target, required this.exercises});

  factory HomeSport.beginnerChest() {
    final List<HomeExercise> exercises = [
      HomeExercise(
        img: "",
        title: "Jumping jacks",
        duration: 5,
        instruction:
            "is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum. is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
      ),
      HomeExercise(
        img: "",
        title: "Pompes avec mains surélevées",
        repetition: 16,
        instruction:
            "is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
      ),
      HomeExercise(img: "", title: "Pompes sur les genoux", repetition: 12, instruction: ""),
      HomeExercise(img: "", title: "Pompes", repetition: 10, instruction: ""),
      HomeExercise(img: "", title: "Pompes avec bras écartés", repetition: 10, instruction: ""),
      HomeExercise(img: "", title: "Pompes avec mains surélevées", repetition: 12, instruction: ""),
      HomeExercise(img: "", title: "Pompes genoux au sol", repetition: 12, instruction: ""),
      HomeExercise(img: "", title: "Pompes avec bras écartés", repetition: 10, instruction: ""),
    ];

    return HomeSport(img: "assets/men.png", duration: 10, difficulty: Difficulty.beginner, target: HomeSportTarget.chest, exercises: exercises);
  }

  factory HomeSport.intermediateChest() {
    return HomeSport(img: "assets/men-2.png", duration: 13, difficulty: Difficulty.intermediate, target: HomeSportTarget.chest, exercises: []);
  }
}
