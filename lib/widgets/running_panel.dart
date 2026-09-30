import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:sport_manager/services/app_service.dart';

class RunningPanel extends StatelessWidget {
  final double? lastSpeed;
  final int time;
  final int totalTime;
  final bool hasTimer;
  final bool timerActive;
  final VoidCallback onStart;
  final VoidCallback onToggle;
  final VoidCallback onStop;

  const RunningPanel({
    super.key,
    required this.lastSpeed,
    required this.time,
    required this.totalTime,
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
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(Ionicons.stopwatchOutline, size: 80, color: Color.fromARGB(255, 226, 102, 162)),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Column(
                        children: [
                          Text(
                            lastSpeed != null ? "$lastSpeed m/s" : "-- m/s",
                            style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            appService.showTimer(seconde: time, showHours: false),
                            style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 50, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            appService.showTimer(seconde: totalTime),
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
      ),
    );
  }
}
