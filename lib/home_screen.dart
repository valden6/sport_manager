import 'dart:async';
import 'dart:developer';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lottie/lottie.dart';
import 'package:sport_manager/enumerations/tennis_activity_type.dart';
import 'package:sport_manager/services/dance_service.dart';
import 'package:sport_manager/services/location_service.dart';
import 'package:sport_manager/services/notification_service.dart';
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
  final AudioPlayer audioPlayer = AudioPlayer(playerId: "audioPlayer");

  final List<TennisActivityType> tennisActivityTypes = [TennisActivityType.lessons, TennisActivityType.simple, TennisActivityType.double];
  bool notTennisLesson = false;

  DateTime? beginningSession;
  DateTime? endSession;

  double? weight;

  int? indexSports;

  bool showLottieSuccess = false;

  bool rest = false;
  int totalTime = 0;
  int time = 0;
  Timer? timer;

  final List<Position> locations = [];
  final List<Position> oneRunlocations = [];
  double averageSpeed = 0;
  FlutterTts textTospeech = FlutterTts();

  bool notificationEnabled = false;

  @override
  void initState() {
    super.initState();
    lottieController = AnimationController(vsync: this, duration: const Duration(seconds: 3));
    lottieController.addListener(() {
      if (lottieController.isCompleted) {
        setState(() {
          showLottieSuccess = false;
        });
        lottieController.reset();
      }
    });
    getWeightInStorage();
    initializeTextToSpeech();
    _initNotificationSettings();
  }

  @override
  void dispose() {
    lottieController.dispose();
    weightController.dispose();
    audioPlayer.dispose();
    timer?.cancel();
    super.dispose();
  }

  Future<void> getWeightInStorage() async {
    final double? weightInStorage = await weightStorage.getWeight();
    setState(() {
      weight = weightInStorage;
      weightController.text = weight?.toString() ?? "";
    });
  }

  Future<void> initializeTextToSpeech() async {
    await textTospeech.setIosAudioCategory(
      IosTextToSpeechAudioCategory.ambient,
      [
        IosTextToSpeechAudioCategoryOptions.allowBluetooth,
        IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
        IosTextToSpeechAudioCategoryOptions.mixWithOthers,
      ],
      IosTextToSpeechAudioMode.voicePrompt,
    );
    if (await textTospeech.isLanguageAvailable("fr-FR") == true) {
      await textTospeech.setLanguage("fr-FR");
    }
  }

  Future<void> _initNotificationSettings() async {
    final String? notificationSettingStorage = await notificationSetting.getNotificationSetting();
    if (notificationSettingStorage != null && notificationSettingStorage == "true") {
      notificationEnabled = true;
    } else {
      notificationEnabled = false;
    }
  }

  void setDateTimeSession(bool endDate, DateTime? dateChoose) {
    if (endDate) {
      setState(() {
        endSession = dateChoose;
      });
    } else {
      setState(() {
        beginningSession = dateChoose;
      });
    }
  }

  Future<void> recordLocation() async {
    final Position newLocation = await locationService.getPosition();
    locations.add(newLocation);
    oneRunlocations.add(newLocation);
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (rest && time == 60) {
        audioPlayer.play(AssetSource("audio/run.m4a"));
        oneRunlocations.clear();
        time = 0;
        rest = false;
      } else if (!rest && time == 4 * 60) {
        audioPlayer.play(AssetSource("audio/rest.m4a"));
        double averageSpeed = 0;
        for (final Position oneRunLocation in oneRunlocations) {
          averageSpeed += oneRunLocation.speed;
        }
        averageSpeed = averageSpeed / oneRunlocations.length;
        if (locations.isNotEmpty && averageSpeed != 0) {
          textTospeech.speak("${(averageSpeed * 3.6).toStringAsFixed(2)} kilomètre heure");
        }
        time = 0;
        rest = true;
      }

      if (totalTime % 10 == 0) {
        recordLocation();
      }

      setState(() {
        totalTime++;
        time++;
      });
    });
  }

  void stopTimer({bool reset = true}) {
    if (timer != null) {
      timer!.cancel();
    }
    if (reset) {
      setState(() {
        totalTime = 0;
        time = 0;
        timer = null;
        locations.clear();
      });
    }
  }

  String twoDigits(int n) => n.toString().padLeft(2, "0");

  String showTimer({required int seconde, bool showHours = true}) {
    String twoDigitHours = twoDigits(seconde ~/ 3600);
    String twoDigitMinutes = twoDigits((seconde ~/ 60) % 60);
    String twoDigitSeconde = twoDigits(seconde % 60);

    if (showHours) {
      return "$twoDigitHours:$twoDigitMinutes:$twoDigitSeconde";
    } else {
      return "$twoDigitMinutes:$twoDigitSeconde";
    }
  }

  Future<void> setNotificationTime() async {
    await NotificationService.showScheduledNotification(
      title: "C'est l'heure !",
      body: "Ajoute ton cours de danse 🕺",
      time: const TimeOfDay(hour: 21, minute: 45),
      day: DateTime.wednesday,
    );
    await NotificationService.showScheduledNotification(
      id: 1,
      title: "C'est l'heure !",
      body: "Ajoute ton cours de tennis 🎾",
      time: const TimeOfDay(hour: 22, minute: 45),
      day: DateTime.thursday,
    );
    await notificationSetting.setNotificationSetting(activated: true);
    if (mounted) {
      setState(() {
        notificationEnabled = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
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
                    padding: const EdgeInsets.only(top: 30),
                    child: Stack(
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 45,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text("Sporty", style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 25, fontWeight: FontWeight.bold, fontFamily: GoogleFonts.kanit().fontFamily)),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () async {
                              HapticFeedback.lightImpact();
                              if (!notificationEnabled) {
                                setNotificationTime();
                              } else {
                                NotificationService.cancelAll();
                                notificationSetting.setNotificationSetting(activated: false);
                                setState(() {
                                  notificationEnabled = false;
                                });
                              }
                            },
                            child: Card(
                              color: Theme.of(context).colorScheme.secondary,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(notificationEnabled ? IconlyBold.notification : IconlyLight.notification, color: Theme.of(context).colorScheme.primary, size: 22),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30, bottom: 10),
                    child: Row(
                      children: [
                        Text("Poid actuel:", style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 25, fontWeight: FontWeight.bold, fontFamily: GoogleFonts.kanit().fontFamily)),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(left: 15, right: 5),
                          child: Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Theme.of(context).primaryColor),
                            width: 70,
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
                              style: TextStyle(fontSize: 25, color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(left: 10, right: 10),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide: BorderSide.none,
                                ),
                                hintStyle: TextStyle(fontSize: 20, color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w400),
                              ),
                            ),
                          ),
                        ),
                        Text("kg", style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 25, fontWeight: FontWeight.bold, fontFamily: GoogleFonts.kanit().fontFamily)),
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
                            if (success) {
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            setState(() {
                              indexSports = 2;
                            });
                          },
                          child: const SportCard(
                            text: "Course",
                            icon: Ionicons.stopwatch_outline,
                            iconColor: Color.fromARGB(255, 226, 102, 162),
                          ),
                        ),
                      ),
                      Expanded(child: Container())
                    ],
                  ),
                  if (indexSports != null && indexSports == 0) ...[
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
                                  color: Theme.of(context).colorScheme.background,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Row(
                                      children: [
                                        Text("Hors cours ?", style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 20, fontWeight: FontWeight.bold)),
                                        const Spacer(),
                                        CupertinoSwitch(
                                          value: notTennisLesson,
                                          thumbColor: Theme.of(context).colorScheme.primary,
                                          trackColor: Theme.of(context).primaryColor,
                                          activeColor: Theme.of(context).colorScheme.tertiary.withOpacity(0.5),
                                          onChanged: (bool? newValue) {
                                            setState(() {
                                              notTennisLesson = newValue ?? false;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              if (notTennisLesson) ...[
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                                  child: DateTimeCard(endDate: false, getDate: setDateTimeSession),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15),
                                  child: DateTimeCard(endDate: true, startDateChoosen: beginningSession, getDate: setDateTimeSession),
                                ),
                              ],
                              Padding(
                                padding: const EdgeInsets.only(top: 20, bottom: 10),
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
                                            if ((beginningSession != null && endSession == null) || (endSession != null && beginningSession == null)) {
                                              log("ERROR date manquante");
                                            } else {
                                              HapticFeedback.lightImpact();
                                              final bool success = await tennisService.addTennisData(tennisActivityType: tennisActivityType, match: notTennisLesson, beginningSession: beginningSession, endSession: endSession);
                                              if (success) {
                                                setState(() {
                                                  showLottieSuccess = true;
                                                });
                                                lottieController.forward();
                                              }
                                            }
                                          },
                                          child: Card(
                                            elevation: 0,
                                            color: Theme.of(context).colorScheme.background,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(15),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(8),
                                              child: Text(tennisActivityType.name, style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 20, fontWeight: FontWeight.bold)),
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                  if (indexSports != null && indexSports == 2) ...[
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
                                padding: const EdgeInsets.only(left: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Icon(Ionicons.stopwatch_outline, size: 80, color: Color.fromARGB(255, 226, 102, 162)),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Column(
                                        children: [
                                          Text(locations.isNotEmpty ? "${locations.last.speed} m/s" : "-- m/s", style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 20, fontWeight: FontWeight.bold)),
                                          Text(showTimer(seconde: time, showHours: false), style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 50, fontWeight: FontWeight.bold)),
                                          Text(showTimer(seconde: totalTime), style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 20, fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (timer == null) ...[
                                      GestureDetector(
                                        onTap: () {
                                          startTimer();
                                        },
                                        child: Card(
                                          elevation: 0,
                                          color: Theme.of(context).colorScheme.background,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          child: const Padding(
                                            padding: EdgeInsets.all(8),
                                            child: Icon(Ionicons.play, size: 60, color: Colors.black),
                                          ),
                                        ),
                                      ),
                                    ],
                                    if (timer != null) ...[
                                      GestureDetector(
                                        onTap: () {
                                          if (timer!.isActive) {
                                            stopTimer(reset: false);
                                          } else {
                                            startTimer();
                                          }
                                        },
                                        child: Card(
                                          elevation: 0,
                                          color: Theme.of(context).colorScheme.background,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          child: Padding(padding: const EdgeInsets.all(8), child: Icon(timer!.isActive ? Ionicons.pause : Ionicons.play, size: 60, color: Colors.black)),
                                        ),
                                      ),
                                      const Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
                                      GestureDetector(
                                        onTap: () {
                                          stopTimer();
                                        },
                                        child: Card(
                                          elevation: 0,
                                          color: Theme.of(context).colorScheme.background,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          child: const Padding(
                                            padding: EdgeInsets.all(8),
                                            child: Icon(Ionicons.stop, size: 60, color: Colors.black),
                                          ),
                                        ),
                                      ),
                                    ]
                                  ],
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
          if (showLottieSuccess) ...[
            Container(
              color: Theme.of(context).primaryColor,
              child: Center(
                child: Lottie.network("https://assets1.lottiefiles.com/packages/lf20_uktq0eKz9C.json", repeat: false, controller: lottieController),
              ),
            )
          ]
        ],
      ),
    );
  }
}
