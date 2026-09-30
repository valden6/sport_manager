import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SuccessOverlay extends StatelessWidget {
  final AnimationController controller;

  const SuccessOverlay({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Center(child: Lottie.asset("assets/lottie/victory.json", repeat: false, controller: controller)),
    );
  }
}
