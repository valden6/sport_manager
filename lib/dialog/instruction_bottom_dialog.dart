import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';
import 'package:sport_manager/widgets/card_button.dart';

class InstructionBottomDialog extends StatefulWidget {
  final String instruction;
  const InstructionBottomDialog({super.key, required this.instruction});

  @override
  State<InstructionBottomDialog> createState() => _InstructionBottomDialogState();
}

class _InstructionBottomDialogState extends State<InstructionBottomDialog> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: const BorderRadius.vertical(top: Radius.circular(30))),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 15),
            child: Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    Navigator.pop(context);
                  },
                  child: CardButton(icon: Ionicons.close),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      "Instructions",
                      style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: SizedBox(
                    height: 340,
                    child: SingleChildScrollView(
                      child: Text(
                        widget.instruction,
                        textAlign: TextAlign.start,
                        style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
