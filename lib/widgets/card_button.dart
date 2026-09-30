import 'package:flutter/material.dart';

class CardButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final Color? iconColor;

  const CardButton({super.key, required this.icon, this.onTap, this.backgroundColor, this.iconColor});

  @override
  Widget build(BuildContext context) {
    Color colorBackground = Theme.of(context).primaryColor;
    Color colorIcon = Theme.of(context).colorScheme.primary;

    if (backgroundColor != null) {
      colorBackground = backgroundColor!;
    }
    if (iconColor != null) {
      colorIcon = iconColor!;
    }

    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: colorBackground,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
        child: Padding(padding: const EdgeInsets.all(8.0), child: Icon(icon, color: colorIcon, size: 22)),
      ),
    );
  }
}
