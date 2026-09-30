import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';
import 'package:sport_manager/animations/slide_left_route.dart';
import 'package:sport_manager/animations/swipe_back.dart';
import 'package:sport_manager/enumerations/difficulty.dart';
import 'package:sport_manager/enumerations/home_sport_target.dart';
import 'package:sport_manager/models/home_sport.dart';
import 'package:sport_manager/screens/home_sport_detail_screen.dart';
import 'package:sport_manager/widgets/card_button.dart';
import 'package:sport_manager/widgets/home_sport_card.dart';

class HomeSportScreen extends StatefulWidget {
  const HomeSportScreen({super.key});

  @override
  State<HomeSportScreen> createState() => _HomeSportScreenState();
}

class _HomeSportScreenState extends State<HomeSportScreen> {
  final HomeSport homeSportBeginnner = HomeSport.beginnerChest();
  final HomeSport homeSportIntermediate = HomeSport.intermediateChest();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (DragUpdateDetails details) => SwipeBack().onHorizontalDragLeft(context, details),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: Text(
            "Sport à la maison",
            style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          leading: Padding(
            padding: const EdgeInsets.only(left: 10, top: 5, bottom: 5),
            child: CardButton(
              onTap: () {
                HapticFeedback.lightImpact();
                Navigator.pop(context);
              },
              icon: Ionicons.chevronBackOutline,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              HomeSportCard(
                onTap: () {
                  HapticFeedback.lightImpact();
                  Navigator.push(context, SlideLeftRoute(page: HomeSportDetailScreen(homeSport: homeSportBeginnner)));
                },
                text: "${homeSportBeginnner.target.text} - ${homeSportBeginnner.difficulty.text}",
                img: homeSportBeginnner.img,
                subText: "${homeSportBeginnner.duration} minutes",
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: HomeSportCard(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    Navigator.push(context, SlideLeftRoute(page: HomeSportDetailScreen(homeSport: homeSportIntermediate)));
                  },
                  text: "${homeSportIntermediate.target.text} - ${homeSportIntermediate.difficulty.text}",
                  img: homeSportIntermediate.img,
                  subText: "${homeSportIntermediate.duration} minutes",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
