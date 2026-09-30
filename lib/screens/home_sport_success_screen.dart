import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:sport_manager/animations/swipe_back.dart';
import 'package:sport_manager/services/app_service.dart';
import 'package:sport_manager/widgets/card_button.dart';
import 'package:sport_manager/widgets/card_large_button.dart';
import 'package:sport_manager/widgets/timer_card.dart';

class HomeSportSuccessScreen extends StatefulWidget {
  const HomeSportSuccessScreen({super.key});

  @override
  State<HomeSportSuccessScreen> createState() => _HomeSportSuccessScreenState();
}

class _HomeSportSuccessScreenState extends State<HomeSportSuccessScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
          title: Text("Bravo !", style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 20, fontWeight: FontWeight.bold)),
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
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.surface,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: Text(
                            "Bravo".toUpperCase(),
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, fontFamily: GoogleFonts.poppins().fontFamily),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: CardLargeButton(
                  onTap: () async {
                    HapticFeedback.lightImpact();
                    log("End");
                    Navigator.pop(context);
                  },
                  text: "Next",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
