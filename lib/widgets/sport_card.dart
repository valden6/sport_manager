import 'package:flutter/material.dart';

class SportCard extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color iconColor;

  const SportCard({super.key, required this.text, required this.icon, required this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: Card(
                elevation: 0,
                color: iconColor.withOpacity(0.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Icon(icon, size: 50, color: iconColor),
                ),
              ),
            ),
            Expanded(child: Text(text, style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 20, fontWeight: FontWeight.bold))),
          ],
        ),
      ),
    );
  }
}
