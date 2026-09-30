import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';
import 'package:sport_manager/widgets/sport_card.dart';

class JumpRopeCard extends StatelessWidget {
  final bool selected;
  final VoidCallback onTap;

  const JumpRopeCard({super.key, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: SportCard(
        text: "Corde à sauté",
        icon: Ionicons.fitnessOutline,
        iconColor: const Color.fromARGB(255, 255, 190, 92),
        selected: selected,
      ),
    );
  }
}