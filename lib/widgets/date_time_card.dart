import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:sport_manager/widgets/dialog/date_time_bottom_dialog.dart';

class DateTimeCard extends StatefulWidget {
  final DateTime? dateAlreadyChoose;
  final bool endDate;
  final DateTime? startDateChoosen;
  final void Function(bool, DateTime?) getDate;

  const DateTimeCard({super.key, required this.endDate, required this.getDate, this.dateAlreadyChoose, this.startDateChoosen});

  @override
  State<DateTimeCard> createState() => _DateTimeCardState();
}

class _DateTimeCardState extends State<DateTimeCard> {
  DateTime? date;

  @override
  void initState() {
    super.initState();
    date = widget.dateAlreadyChoose;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Text(!widget.endDate ? "Début:" : "Fin:", style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 20, fontWeight: FontWeight.bold)),
            const Spacer(),
            GestureDetector(
              // Display a CupertinoDatePicker in dateTime picker mode.
              onTap: () async {
                HapticFeedback.lightImpact();
                final DateTime? dateChoose = await DateTimeBottomDialog().settingModalBottomSheet(context: context, minimumDate: widget.startDateChoosen);
                if (dateChoose != null && dateChoose != DateTime(-1)) {
                  widget.getDate(widget.endDate, dateChoose);
                  setState(() {
                    date = dateChoose;
                  });
                }
              },
              child: Text(date != null ? DateFormat("dd/MM/yy:  HH:mm").format(date!) : "Choisissez une date", style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 18, fontWeight: FontWeight.w500)),
            ),
          ],
        ),
      ),
    );
  }
}
