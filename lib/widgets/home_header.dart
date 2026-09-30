import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';

class HomeHeader extends StatelessWidget {
  final bool notificationEnabled;
  final VoidCallback onNotificationTap;

  const HomeHeader({super.key, required this.notificationEnabled, required this.onNotificationTap});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 45,
          child: Align(
            alignment: Alignment.center,
            child: Text(
              "Sporty",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 25,
                fontWeight: FontWeight.bold,
                fontFamily: GoogleFonts.kanit().fontFamily,
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              onNotificationTap();
            },
            child: Card(
              color: Theme.of(context).colorScheme.secondary,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  notificationEnabled ? Ionicons.notifications : Ionicons.notificationsOutline,
                  color: Theme.of(context).colorScheme.primary,
                  size: 22,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
