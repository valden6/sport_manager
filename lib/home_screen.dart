import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lottie/lottie.dart';
import 'package:sport_manager/enumerations/tennis_activity_type.dart';
import 'package:sport_manager/services/dance_service.dart';
import 'package:sport_manager/services/tennis_service.dart';
import 'package:sport_manager/settings/global_storage.dart';
import 'package:sport_manager/widgets/date_time_card.dart';
import 'package:sport_manager/widgets/sport_card.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {

  late final AnimationController lottieController;
  final TextEditingController weightController = TextEditingController();

  final List<TennisActivityType> tennisActivityTypes = [TennisActivityType.lessons,TennisActivityType.simple,TennisActivityType.double];
  bool notTennisLesson = false;

  DateTime? beginningSession;
  DateTime? endSession;

  double? weight;
  
  int? indexSports;

  bool showLottieSuccess = false;

  @override
  void initState() {
    super.initState();
    lottieController = AnimationController(vsync: this,duration: const Duration(seconds: 3));
    lottieController.addListener(() {
      if(lottieController.isCompleted){
        setState(() {
          showLottieSuccess = false;
        });
        lottieController.reset();
      }
    });
    getWeightInStorage();
  }

  @override
  void dispose() {
    lottieController.dispose();
    weightController.dispose();
    super.dispose();
  }

  Future<void> getWeightInStorage() async {
    final double? weightInStorage = await weightStorage.getWeight();
    setState(() {
      weight = weightInStorage;
      weightController.text = weight?.toString()?? "";
    });
  }

  void setDateTimeSession(bool endDate, DateTime? dateChoose){
    if(endDate){
      setState(() {
        endSession = dateChoose;
      });
    } else {
      setState(() {
        beginningSession = dateChoose;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Stack(
        children: [
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,            
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 30,bottom: 10),
                    child: Text("Sporty",style: TextStyle(color: Theme.of(context).colorScheme.primary,fontSize: 25,fontWeight: FontWeight.bold,fontFamily: GoogleFonts.kanit().fontFamily)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30,bottom: 10),
                    child: Row(
                      children: [
                        Text("Poid actuel:",style: TextStyle(color: Theme.of(context).colorScheme.primary,fontSize: 25,fontWeight: FontWeight.bold,fontFamily: GoogleFonts.kanit().fontFamily)),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(left: 15,right: 5),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Theme.of(context).primaryColor
                            ),
                            width: 50,
                            height: 45,
                            child: TextField(
                              onSubmitted: (String newWeight) {
                                final double finalWeight = double.parse(newWeight);
                                setState(() {
                                  weight = finalWeight;
                                });
                                weightStorage.setWeight(finalWeight);
                              },
                              textAlign: TextAlign.end,
                              textInputAction: TextInputAction.done,
                              cursorColor: Theme.of(context).colorScheme.primary,
                              controller: weightController,
                              keyboardType: TextInputType.emailAddress,
                              textCapitalization: TextCapitalization.sentences,
                              style: TextStyle(fontSize: 25,color: Theme.of(context).colorScheme.primary,fontWeight: FontWeight.bold),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(left: 10,right: 10),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide: BorderSide.none,
                                ),
                                hintText: "- -",
                                hintStyle: TextStyle(fontSize: 20,color: Theme.of(context).colorScheme.primary,fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                        ),
                        Text("kg",style: TextStyle(color: Theme.of(context).colorScheme.primary,fontSize: 25,fontWeight: FontWeight.bold,fontFamily: GoogleFonts.kanit().fontFamily)),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            setState(() {
                              indexSports = 0;
                            });
                          },
                          child: const SportCard(
                            text: "Tennis",
                            icon: Ionicons.tennisball_outline,
                            iconColor: Color.fromARGB(255, 131, 215, 253),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            HapticFeedback.lightImpact();
                            setState(() {
                              indexSports = 1;
                            });
                            HapticFeedback.lightImpact();
                            final bool success = await danceService.addDanceData();
                            if(success) {
                              setState(() {
                                showLottieSuccess = true;
                              });
                              lottieController.forward();
                            }
                          },
                          child: const SportCard(
                            text: "Danse",
                            icon: Ionicons.musical_notes_outline,
                            iconColor: Color.fromARGB(255, 155, 131, 253),
                          ),
                        ),
                      )
                    ],
                  ),
                  if(indexSports != null && indexSports == 0) ...[
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Card(
                        elevation: 0,
                        color: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                child: Card(
                                  elevation: 0,
                                  color: Theme.of(context).backgroundColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Row(
                                      children: [
                                        Text("Hors cours ?",style: TextStyle(color: Theme.of(context).colorScheme.primary,fontSize: 20,fontWeight: FontWeight.bold)),
                                        const Spacer(),
                                        CupertinoSwitch(
                                          value: notTennisLesson,
                                          thumbColor: Theme.of(context).colorScheme.primary,
                                          trackColor: Theme.of(context).primaryColor,
                                          activeColor: Theme.of(context).colorScheme.tertiary.withOpacity(0.5),
                                          onChanged: (bool? newValue) {
                                            setState(() {
                                              notTennisLesson = newValue?? false;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              if(notTennisLesson) ...[
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                                  child: DateTimeCard(endDate: false, getDate: setDateTimeSession),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15),
                                  child: DateTimeCard(endDate: true,startDateChoosen: beginningSession, getDate: setDateTimeSession),
                                ),
                              ],
                              Padding(
                                padding: const EdgeInsets.only(top: 20,bottom: 10),
                                child: SizedBox(
                                  height: 50,
                                  child: ListView.builder(
                                    itemCount: tennisActivityTypes.length,
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemBuilder: (BuildContext context, int index) {
              
                                      final TennisActivityType tennisActivityType = tennisActivityTypes[index];
              
                                      return GestureDetector(
                                        onTap: () async {
                                          if((beginningSession != null && endSession == null) || (endSession != null && beginningSession == null)){
                                            log("ERROR date manquante");
                                          } else {
                                            HapticFeedback.lightImpact();
                                            final bool success = await tennisService.addTennisData(tennisActivityType: tennisActivityType,match: notTennisLesson,beginningSession: beginningSession,endSession: endSession);
                                            if(success) {
                                              setState(() {
                                                showLottieSuccess = true;
                                              });
                                              lottieController.forward();
                                            }
                                          }
                                        },
                                        child: Card(
                                          elevation: 0,
                                          color: Theme.of(context).backgroundColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: Text(tennisActivityType.name,style: TextStyle(color: Theme.of(context).colorScheme.primary,fontSize: 20,fontWeight: FontWeight.bold)),
                                          ),
                                        ),
                                      );
                                    }
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          if(showLottieSuccess) ...[
            Container(
              color: Theme.of(context).primaryColor,
              child: Center(
                child: Lottie.network(
                  "https://assets1.lottiefiles.com/packages/lf20_uktq0eKz9C.json",
                  repeat: false,
                  controller: lottieController
                ),
              ),
            )
          ]
        ],
      ),
    );
  }
}
