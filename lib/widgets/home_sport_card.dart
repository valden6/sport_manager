import 'package:flutter/material.dart';

class HomeSportCard extends StatelessWidget {
  final String text;
  final String subText;
  final String img;
  final VoidCallback? onTap;

  const HomeSportCard({super.key, required this.text, required this.img, this.onTap, required this.subText});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 0,
        color: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Row(
          children: [
            ClipRRect(borderRadius: BorderRadius.circular(15), child: Image.asset(img, fit: BoxFit.cover, width: 100, height: 100)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(text, style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 20, fontWeight: FontWeight.bold)),
                Text(subText, style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 15)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
