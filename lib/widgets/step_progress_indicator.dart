import 'package:flutter/material.dart';

class StepProgressIndicator extends StatelessWidget {
  final int index;
  final Color progressColor;
  final Color unprogressColor;
  final int total;
  final double? spacing;

  const StepProgressIndicator({
    super.key,
    required this.index,
    required this.progressColor,
    required this.unprogressColor,
    required this.total,
    this.spacing = 0,
  });

  @override
  Widget build(BuildContext context) {
    final double height = 8;
    final double radius = 3;

    return Row(
      children: List.generate(total, (int i) {
        final isCompleted = i < index;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: i == 0 ? 0 : spacing!), // un petit espacement
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
              color: isCompleted ? progressColor : unprogressColor,
              child: Container(height: height),
            ),
          ),
        );
      }),
    );
  }
}
