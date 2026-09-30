import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sport_manager/services/app_service.dart';

class TimerCard extends StatefulWidget {
  const TimerCard({super.key});

  @override
  State<TimerCard> createState() => _TimerCardState();
}

class _TimerCardState extends State<TimerCard> {
  late int time;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    time = appService.streamHomeSportExerciceTotalTimer.value;
    startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        time++;
        appService.streamHomeSportExerciceTotalTimer.add(time);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.secondary,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        child: Text(
          appService.showTimer(seconde: time, showHours: false),
          style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 18),
        ),
      ),
    );
  }
}
