import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class WeightInputRow extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSave;

  const WeightInputRow({super.key, required this.controller, required this.onSave});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30, bottom: 10),
      child: Row(
        children: [
          Text(
            "Poid actuel:",
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 25,
              fontWeight: FontWeight.bold,
              fontFamily: GoogleFonts.kanit().fontFamily,
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 5),
            child: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Theme.of(context).primaryColor),
              width: 80,
              height: 45,
              child: TextField(
                onSubmitted: onSave,
                textAlign: TextAlign.end,
                textInputAction: TextInputAction.done,
                cursorColor: Theme.of(context).colorScheme.primary,
                controller: controller,
                keyboardType: TextInputType.number,
                onTapOutside: (event) {
                  HapticFeedback.lightImpact();
                  FocusScope.of(context).unfocus();
                  onSave(controller.text);
                },
                onChanged: (value) {
                  HapticFeedback.lightImpact();
                  onSave(value);
                },
                textCapitalization: TextCapitalization.sentences,
                style: TextStyle(fontSize: 25, color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(left: 10, right: 10),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: BorderSide.none),
                  hintStyle: TextStyle(fontSize: 20, color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w400),
                ),
              ),
            ),
          ),
          Text(
            "kg",
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 25,
              fontWeight: FontWeight.bold,
              fontFamily: GoogleFonts.kanit().fontFamily,
            ),
          ),
        ],
      ),
    );
  }
}
