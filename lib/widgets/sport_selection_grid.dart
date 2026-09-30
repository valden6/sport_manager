import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';
import 'package:sport_manager/widgets/jump_rope_card.dart';
import 'package:sport_manager/widgets/sport_card.dart';

class SportSelectionGrid extends StatelessWidget {
  final int? selectedIndex;
  final VoidCallback onTennisTap;
  final VoidCallback onDanceTap;
  final VoidCallback onRunTap;
  final VoidCallback onJumpRopeTap;
  final VoidCallback onSportTap;

  const SportSelectionGrid({
    super.key,
    required this.selectedIndex,
    required this.onTennisTap,
    required this.onDanceTap,
    required this.onRunTap,
    required this.onJumpRopeTap,
    required this.onSportTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  onTennisTap();
                },
                child: SportCard(
                  text: "Tennis",
                  icon: Ionicons.tennisballOutline,
                  iconColor: const Color.fromARGB(255, 131, 215, 253),
                  selected: selectedIndex == 0,
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  onDanceTap();
                },
                child: const SportCard(
                  text: "Danse",
                  icon: Ionicons.musicalNoteOutline,
                  iconColor: Color.fromARGB(255, 155, 131, 253),
                  selected: false,
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  onRunTap();
                },
                child: SportCard(
                  text: "Course",
                  icon: Ionicons.stopwatchOutline,
                  iconColor: const Color.fromARGB(255, 226, 102, 162),
                  selected: selectedIndex == 2,
                ),
              ),
            ),
            Expanded(
              child: JumpRopeCard(selected: selectedIndex == 3, onTap: onJumpRopeTap),
            ),
            // Expanded(
            //   child: GestureDetector(
            //     onTap: () {
            //       HapticFeedback.lightImpact();
            //       onSportTap();
            //     },
            //     child: const SportCard(
            //       text: "Sport",
            //       icon: Ionicons.barbellOutline,
            //       iconColor: Color.fromARGB(255, 134, 203, 114),
            //       selected: false,
            //     ),
            //   ),
            // ),
          ],
        ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     Expanded(
        //       child: JumpRopeCard(selected: selectedIndex == 3, onTap: onJumpRopeTap),
        //     ),
        //     const Expanded(child: SizedBox()),
        //   ],
        // ),
      ],
    );
  }
}
