import 'package:flutter/material.dart';

class SwipeBack {
  void onHorizontalDragLeft(BuildContext context, DragUpdateDetails details) {
    const int sensitivity = 8;

    if (details.delta.dx > sensitivity) {
      Navigator.pop(context);
    }
  }

  void onVerticalDragDown(BuildContext context, DragUpdateDetails details) {
    const int sensitivity = 8;

    if (details.delta.dy > sensitivity) {
      Navigator.pop(context);
    }
  }
}
