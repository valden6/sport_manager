import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:sport_manager/services/app_service.dart';

class JumpRopePanel extends StatelessWidget {
  final int remainingTime;
  final int totalTime;
  final bool isRest;
  final int cycles;
  final bool hasTimer;
  final bool timerActive;
  final VoidCallback onStart;
  final VoidCallback onToggle;
  final VoidCallback onStop;

  const JumpRopePanel({
    super.key,
    required this.remainingTime,
    required this.totalTime,
    required this.isRest,
    required this.cycles,
    required this.hasTimer,
    required this.timerActive,
    required this.onStart,
    required this.onToggle,
    required this.onStop,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Card(
        elevation: 0,
        color: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Ionicons.fitnessOutline, size: 80, color: Color.fromARGB(255, 255, 190, 92)),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          appService.showTimer(seconde: remainingTime < 0 ? 0 : remainingTime, showHours: false),
                          style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 50, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          appService.showTimer(seconde: totalTime),
                          style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Tour ${cycles + 1}",
                          style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!hasTimer) ...[
                    GestureDetector(
                      onTap: onStart,
                      child: Card(
                        elevation: 0,
                        color: Theme.of(context).colorScheme.surface,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        child: const Padding(
                          padding: EdgeInsets.all(8),
                          child: Icon(Ionicons.play, size: 60, color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                  if (hasTimer) ...[
                    GestureDetector(
                      onTap: onToggle,
                      child: Card(
                        elevation: 0,
                        color: Theme.of(context).colorScheme.surface,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Icon(timerActive ? Ionicons.pause : Ionicons.play, size: 60, color: Colors.black),
                        ),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                    GestureDetector(
                      onTap: onStop,
                      child: Card(
                        elevation: 0,
                        color: Theme.of(context).colorScheme.surface,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        child: const Padding(
                          padding: EdgeInsets.all(8),
                          child: Icon(Ionicons.stop, size: 60, color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
