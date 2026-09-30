import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:sport_manager/animations/fade_route.dart';
import 'package:sport_manager/animations/swipe_back.dart';
import 'package:sport_manager/dialog/instruction_bottom_dialog.dart';
import 'package:sport_manager/models/home_exercise.dart';
import 'package:sport_manager/screens/home_sport_rest_screen.dart';
import 'package:sport_manager/screens/home_sport_success_screen.dart';
import 'package:sport_manager/services/app_service.dart';
import 'package:sport_manager/widgets/card_button.dart';
import 'package:sport_manager/widgets/card_large_button.dart';
import 'package:sport_manager/widgets/step_progress_indicator.dart';
import 'package:sport_manager/widgets/timer_card.dart';

class HomeSportActivityScreen extends StatefulWidget {
  final List<HomeExercise> exercises;
  final int? index;
  const HomeSportActivityScreen({super.key, required this.exercises, this.index});

  @override
  State<HomeSportActivityScreen> createState() => _HomeSportActivityScreenState();
}

class _HomeSportActivityScreenState extends State<HomeSportActivityScreen> {
  int? time = 0;
  Timer? timer;
  // final AudioPlayer audioPlayer = AudioPlayer(playerId: "audioPlayer_home_sport_activity");

  @override
  void initState() {
    super.initState();
    time = widget.exercises[widget.index ?? 0].duration;
    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    // audioPlayer.dispose();
    super.dispose();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (time == 1) {
        stopTimer();
        // audioPlayer.play(AssetSource("audio/rest.m4a"));
        pushToNextExercise();
      }

      setState(() {
        if (time != null) {
          time = time! - 1;
        }
      });
    });
  }

  void stopTimer({bool reset = true}) {
    if (timer != null) {
      timer!.cancel();
    }
  }

  void pushToNextExercise() {
    Navigator.pushReplacement(
      context,
      FadeRoute(page: HomeSportRestScreen(exercises: widget.exercises, index: widget.index != null ? widget.index! + 1 : 1)),
    );
  }

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
            "Exercice ${widget.index != null ? widget.index! + 1 : 1}/${widget.exercises.length}",
            style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          leading: Padding(
            padding: const EdgeInsets.only(left: 10, top: 5, bottom: 5),
            child: CardButton(
              onTap: () {
                HapticFeedback.lightImpact();
                appService.streamHomeSportExerciceTotalTimer.add(0);
                Navigator.pop(context);
              },
              icon: Ionicons.close,
            ),
          ),
          actions: [Padding(padding: const EdgeInsets.only(right: 10, top: 5, bottom: 5), child: TimerCard())],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: StepProgressIndicator(
                  index: widget.index != null ? widget.index! + 1 : 1,
                  total: widget.exercises.length,
                  progressColor: Theme.of(context).colorScheme.primary,
                  unprogressColor: Theme.of(context).colorScheme.secondary,
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    showModalBottomSheet<String>(
                      context: context,
                      backgroundColor: Colors.transparent,
                      useRootNavigator: true,
                      builder: (BuildContext context) => InstructionBottomDialog(instruction: widget.exercises[widget.index ?? 0].instruction),
                    );
                  },
                  child: Container(
                    color: Theme.of(context).colorScheme.surface,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 50),
                            child: Text(
                              widget.exercises[widget.index ?? 0].title,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            time != null
                                ? appService.showTimer(seconde: time!, showHours: false)
                                : "x${widget.exercises[widget.index ?? 0].repetition}",
                            style: TextStyle(fontSize: 80, fontWeight: FontWeight.bold, fontFamily: GoogleFonts.fugazOne().fontFamily),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CardLargeButton(text: "Start", onTap: () async {}),
                    CardLargeButton(
                      onTap: () async {
                        HapticFeedback.lightImpact();
                        if (widget.index == null || widget.index! + 1 < widget.exercises.length) {
                          pushToNextExercise();
                        } else {
                          log("End");
                          Navigator.pushReplacement(context, FadeRoute(page: HomeSportSuccessScreen()));
                        }
                      },
                      text: "Next",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
