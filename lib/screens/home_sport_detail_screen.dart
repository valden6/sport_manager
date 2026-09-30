import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';
import 'package:sport_manager/animations/slide_top_route.dart';
import 'package:sport_manager/animations/swipe_back.dart';
import 'package:sport_manager/dialog/instruction_bottom_dialog.dart';
import 'package:sport_manager/enumerations/difficulty.dart';
import 'package:sport_manager/enumerations/home_sport_target.dart';
import 'package:sport_manager/models/home_exercise.dart';
import 'package:sport_manager/models/home_sport.dart';
import 'package:sport_manager/screens/home_sport_activity_screen.dart';
import 'package:sport_manager/widgets/card_button.dart';
import 'package:sport_manager/widgets/card_large_button.dart';

class HomeSportDetailScreen extends StatefulWidget {
  final HomeSport homeSport;
  const HomeSportDetailScreen({super.key, required this.homeSport});

  @override
  State<HomeSportDetailScreen> createState() => _HomeSportDetailScreenState();
}

class _HomeSportDetailScreenState extends State<HomeSportDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (DragUpdateDetails details) => SwipeBack().onHorizontalDragLeft(context, details),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: Text(
            "${widget.homeSport.target.text} ${widget.homeSport.difficulty.text}",
            style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          leading: Padding(
            padding: const EdgeInsets.only(left: 10, top: 5, bottom: 5),
            child: CardButton(
              onTap: () {
                HapticFeedback.lightImpact();
                Navigator.pop(context);
              },
              icon: Ionicons.chevronBackOutline,
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListView.builder(
                  itemCount: widget.homeSport.exercises.length,
                  itemBuilder: (context, index) {
                    final HomeExercise exercise = widget.homeSport.exercises[index];

                    return GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        showModalBottomSheet<String>(
                          context: context,
                          backgroundColor: Colors.transparent,
                          useRootNavigator: true,
                          builder: (BuildContext context) => InstructionBottomDialog(instruction: exercise.instruction),
                        );
                      },
                      child: Card(
                        elevation: 0,
                        color: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  "${index + 1}.",
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      exercise.title,
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
                                    ),
                                    Text(
                                      exercise.duration != null ? "00:${exercise.duration}" : "x${exercise.repetition}",
                                      style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.primary),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30, top: 10),
              child: CardLargeButton(
                onTap: () async {
                  if (widget.homeSport.exercises.isNotEmpty) {
                    HapticFeedback.lightImpact();
                    Navigator.push(context, SlideTopRoute(page: HomeSportActivityScreen(exercises: widget.homeSport.exercises)));
                  }
                },
                text: "Démarrer",
                uppercase: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
