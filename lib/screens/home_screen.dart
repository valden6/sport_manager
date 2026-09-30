import 'dart:async';
import 'dart:developer';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sport_manager/animations/slide_left_route.dart';
import 'package:sport_manager/enumerations/tennis_activity_type.dart';
import 'package:sport_manager/screens/home_sport_screen.dart';
import 'package:sport_manager/services/dance_service.dart';
import 'package:sport_manager/services/jump_rope_service.dart';
import 'package:sport_manager/services/location_service.dart';
import 'package:sport_manager/services/notification_service.dart';
import 'package:sport_manager/services/tennis_service.dart';
import 'package:sport_manager/settings/global_storage.dart';
import 'package:sport_manager/widgets/home_header.dart';
import 'package:sport_manager/widgets/jump_rope_panel.dart';
import 'package:sport_manager/widgets/running_panel.dart';
import 'package:sport_manager/widgets/sport_selection_grid.dart';
import 'package:sport_manager/widgets/success_overlay.dart';
import 'package:sport_manager/widgets/tennis_panel.dart';
import 'package:sport_manager/widgets/weight_input_row.dart';

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

  bool jumpRopeRest = false;
  int jumpRopeTime = 0;
  int jumpRopeTotalTime = 0;
  int jumpRopeEffortSeconds = 0;
  int jumpRopeCycles = 0;
  Timer? jumpRopeTimer;
  DateTime? jumpRopeBeginningSession;

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
    jumpRopeTimer?.cancel();
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
    await textTospeech.setIosAudioCategory(IosTextToSpeechAudioCategory.ambient, [
      IosTextToSpeechAudioCategoryOptions.allowBluetooth,
      IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
      IosTextToSpeechAudioCategoryOptions.mixWithOthers,
    ], IosTextToSpeechAudioMode.voicePrompt);
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
    timer?.cancel();
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
    setState(() {});
  }

  void stopTimer({bool reset = true}) {
    timer?.cancel();
    setState(() {
      if (reset) {
        totalTime = 0;
        time = 0;
        timer = null;
        locations.clear();
      }
    });
  }

  void startJumpRopeTimer() {
    jumpRopeTimer?.cancel();
    jumpRopeBeginningSession ??= DateTime.now();
    jumpRopeTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      final bool wasRest = jumpRopeRest;
      if (!jumpRopeRest && jumpRopeTime == 5 * 60) {
        audioPlayer.play(AssetSource("audio/rest.m4a"));
        jumpRopeRest = true;
        jumpRopeTime = 0;
      } else if (jumpRopeRest && jumpRopeTime == 60) {
        audioPlayer.play(AssetSource("audio/run.m4a"));
        jumpRopeRest = false;
        jumpRopeTime = 0;
        jumpRopeCycles++;
      }

      setState(() {
        if (!wasRest) {
          jumpRopeEffortSeconds++;
        }
        jumpRopeTotalTime++;
        jumpRopeTime++;
      });
    });
    setState(() {});
  }

  void pauseJumpRopeTimer() {
    jumpRopeTimer?.cancel();
    setState(() {});
  }

  Future<void> stopJumpRopeTimer() async {
    jumpRopeTimer?.cancel();
    final int totalJumpRopeTime = jumpRopeTotalTime;
    final int totalJumpRopeEffort = jumpRopeEffortSeconds;
    final DateTime? beginningJumpRopeSession = jumpRopeBeginningSession;
    setState(() {
      jumpRopeTimer = null;
      jumpRopeBeginningSession = null;
      jumpRopeRest = false;
      jumpRopeTime = 0;
      jumpRopeTotalTime = 0;
      jumpRopeEffortSeconds = 0;
      jumpRopeCycles = 0;
    });
    if (totalJumpRopeTime > 0 && beginningJumpRopeSession != null) {
      HapticFeedback.lightImpact();
      final bool success = await jumpRopeService.addJumpRopeData(
        beginningSession: beginningJumpRopeSession,
        endSession: DateTime.now(),
        effortSeconds: totalJumpRopeEffort,
      );
      if (success && mounted) {
        setState(() {
          showLottieSuccess = true;
        });
        lottieController.forward();
      }
    }
  }

  Future<void> setNotificationTime() async {
    // await NotificationService.showScheduledNotification(
    //   title: "C'est l'heure !",
    //   body: "Ajoute ton cours de danse 🕺",
    //   time: const TimeOfDay(hour: 21, minute: 45),
    //   day: DateTime.wednesday,
    // );
    await NotificationService.showScheduledNotification(
      id: 1,
      title: "C'est l'heure !",
      body: "Ajoute ton cours de tennis 🎾",
      time: const TimeOfDay(hour: 20, minute: 45),
      day: DateTime.friday,
    );
    await notificationSetting.setNotificationSetting(activated: true);
    if (mounted) {
      setState(() {
        notificationEnabled = true;
      });
    }
  }

  Future<void> _toggleNotification() async {
    if (!notificationEnabled) {
      await setNotificationTime();
    } else {
      NotificationService.cancelAll();
      notificationSetting.setNotificationSetting(activated: false);
      setState(() {
        notificationEnabled = false;
      });
    }
  }

  void _onWeightSaved(String newWeight) {
    final double? finalWeight = double.tryParse(newWeight.trim());
    if (finalWeight == null) {
      return;
    }
    setState(() {
      weight = finalWeight;
    });
    weightStorage.setWeight(finalWeight);
  }

  Future<void> _onDanceTap() async {
    setState(() {
      indexSports = 1;
    });
    final bool success = await danceService.addDanceData();
    if (success) {
      setState(() {
        showLottieSuccess = true;
      });
      lottieController.forward();
    }
  }

  void _onSportTap() {
    Navigator.push(context, SlideLeftRoute(page: const HomeSportScreen()));
  }

  Future<void> _onTennisActivityTap(TennisActivityType tennisActivityType) async {
    if ((beginningSession != null && endSession == null) || (endSession != null && beginningSession == null)) {
      log("ERROR date manquante");
    } else {
      HapticFeedback.lightImpact();
      final bool success = await tennisService.addTennisData(
        tennisActivityType: tennisActivityType,
        match: notTennisLesson,
        beginningSession: beginningSession,
        endSession: endSession,
      );
      if (success) {
        setState(() {
          showLottieSuccess = true;
        });
        lottieController.forward();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Stack(
        children: [
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  HomeHeader(notificationEnabled: notificationEnabled, onNotificationTap: _toggleNotification),
                  WeightInputRow(controller: weightController, onSave: _onWeightSaved),
                  SportSelectionGrid(
                    selectedIndex: indexSports,
                    onTennisTap: () {
                      setState(() {
                        indexSports = 0;
                      });
                    },
                    onDanceTap: _onDanceTap,
                    onRunTap: () {
                      setState(() {
                        indexSports = 2;
                      });
                    },
                    onJumpRopeTap: () {
                      setState(() {
                        indexSports = 3;
                      });
                    },
                    onSportTap: _onSportTap,
                  ),
                  if (indexSports != null && indexSports == 0) ...[
                    TennisPanel(
                      notTennisLesson: notTennisLesson,
                      onNotTennisLessonChanged: (bool newValue) {
                        setState(() {
                          notTennisLesson = newValue;
                        });
                      },
                      beginningSession: beginningSession,
                      endSession: endSession,
                      getDate: setDateTimeSession,
                      tennisActivityTypes: tennisActivityTypes,
                      onActivityTap: _onTennisActivityTap,
                    ),
                  ],
                  if (indexSports != null && indexSports == 2) ...[
                    RunningPanel(
                      lastSpeed: locations.isNotEmpty ? locations.last.speed : null,
                      time: time,
                      totalTime: totalTime,
                      hasTimer: timer != null,
                      timerActive: timer?.isActive ?? false,
                      onStart: startTimer,
                      onToggle: () {
                        if (timer!.isActive) {
                          stopTimer(reset: false);
                        } else {
                          startTimer();
                        }
                      },
                      onStop: () => stopTimer(),
                    ),
                  ],
                  if (indexSports != null && indexSports == 3) ...[
                    JumpRopePanel(
                      remainingTime: (jumpRopeRest ? 60 : 5 * 60) - jumpRopeTime,
                      totalTime: jumpRopeTotalTime,
                      isRest: jumpRopeRest,
                      cycles: jumpRopeCycles,
                      hasTimer: jumpRopeTimer != null,
                      timerActive: jumpRopeTimer?.isActive ?? false,
                      onStart: startJumpRopeTimer,
                      onToggle: () {
                        if (jumpRopeTimer!.isActive) {
                          pauseJumpRopeTimer();
                        } else {
                          startJumpRopeTimer();
                        }
                      },
                      onStop: () => stopJumpRopeTimer(),
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (showLottieSuccess) ...[SuccessOverlay(controller: lottieController)],
        ],
      ),
    );
  }
}
