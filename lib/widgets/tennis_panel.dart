import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sport_manager/enumerations/tennis_activity_type.dart';
import 'package:sport_manager/widgets/date_time_card.dart';

class TennisPanel extends StatelessWidget {
  final bool notTennisLesson;
  final ValueChanged<bool> onNotTennisLessonChanged;
  final DateTime? beginningSession;
  final DateTime? endSession;
  final void Function(bool, DateTime?) getDate;
  final List<TennisActivityType> tennisActivityTypes;
  final ValueChanged<TennisActivityType> onActivityTap;

  const TennisPanel({
    super.key,
    required this.notTennisLesson,
    required this.onNotTennisLessonChanged,
    required this.beginningSession,
    required this.endSession,
    required this.getDate,
    required this.tennisActivityTypes,
    required this.onActivityTap,
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
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Card(
                  elevation: 0,
                  color: Theme.of(context).colorScheme.surface,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Text(
                          "Hors cours ?",
                          style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        CupertinoSwitch(
                          value: notTennisLesson,
                          thumbColor: Theme.of(context).colorScheme.primary,
                          inactiveTrackColor: Theme.of(context).primaryColor,
                          activeTrackColor: Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.5),
                          onChanged: onNotTennisLessonChanged,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (notTennisLesson) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  child: DateTimeCard(endDate: false, getDate: getDate),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: DateTimeCard(endDate: true, startDateChoosen: beginningSession, getDate: getDate),
                ),
              ],
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 10),
                child: SizedBox(
                  height: 50,
                  child: ListView.builder(
                    itemCount: tennisActivityTypes.length,
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      final TennisActivityType tennisActivityType = tennisActivityTypes[index];

                      return GestureDetector(
                        onTap: () => onActivityTap(tennisActivityType),
                        child: Card(
                          elevation: 0,
                          color: Theme.of(context).colorScheme.surface,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              tennisActivityType.name,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
