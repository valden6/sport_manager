# Sporty
This is an application that allows you to add sports data in the Health application for tennis, dance, jump rope and home workouts (Test only on iOS)

Available activities:
- **Tennis** (lessons, single, double)
- **Dance**
- **Jump rope** (interval timer with effort/rest cycles)
- **Home workouts** (programs by muscle group: chest, legs, back, arms and difficulty: beginner, intermediate, advanced)

The app estimates calories burned (MET + your saved weight), steps and distance, then writes everything to Apple Health.

If you have ideas to improves the app, feel free to make a request.

## Environment
    - Flutter (Channel stable, 3.47.5, on macOS 26.7.1 25G241 darwin-x64, locale fr-FR)
        • Flutter version 3.47.5 on channel stable
        • Framework revision 6a19cca564 (13 days ago), 2026-09-17 14:13:22 -0400
        • Engine revision af7e796e16
        • Dart version 3.13.4
        • DevTools version 2.60.0
    - Xcode - develop for iOS and macOS (Xcode 26.5, Build version 17F42)
        • CocoaPods version 1.16.2
    - Android toolchain - develop for Android devices (Android SDK version 35.0.0)
        • Platform android-36.1, build-tools 35.0.0
        • Java version OpenJDK Runtime Environment (build 23.0.2)

## Version
## [1.5.0] 
### New features
- Adding **home workouts** ("Sport à la maison"): full new flow (program list → detail → activity → rest → success screen) with exercises by repetition or duration, instructions bottom dialog, step progress indicator and a "Bravo" success screen with a Lottie victory animation
- Adding **jump rope** activity with an interval timer (effort/rest cycles, tour counter, total/remaining time) and sync to Apple Health (steps, active energy, JUMP_ROPE workout)
- Adding **weight input** saved in SharedPreferences and reused between sessions to compute calories
- Adding **CalorieService**: kcal/min from MET and weight (MET × weight × 3.5 / 200), total kcal, total steps and distance (0.762 m per stride)
- Adding **SportType** enum centralizing MET, steps per minute and Health workout type for jump rope, tennis and dance
- Adding success overlay with Lottie animation (assets/lottie/victory.json)

### UI / UX
- New home screen with header, sport selection grid and dedicated panels (tennis, running, jump rope)
- New reusable widgets: card buttons, large button, timer card, step progress indicator, weight input row, home sport cards
- New navigation animations (fade, slide left/top, swipe back) and restructured dialogs

### Upgrade
- Upgrading project to the last version of Flutter (3.22.3 → 3.47.5, Dart 3.4.4 → 3.13.4, SDK constraint >= 3.13.0)
- Upgrading all dependencies (health 10 → 13, google_fonts 9, flutter_local_notifications 22, geolocator 14, shared_preferences 2.5, flutter_lints 6, flutter_launcher_icons 0.14.4, ...)
- Migrating to health plugin v13 and flutter_local_notifications v22 (named parameters)
- Replacing flutter_native_timezone_updated_gradle by flutter_timezone
- Removing flutter_app_badger (no longer maintained) and flutter_iconly
- iOS: migration to FlutterScene (UIApplicationSceneManifest), Xcode project and Pods update
- Code restructure: lib/home_screen.dart → lib/screens/, dialogs → lib/dialog/, new lib/models/, lib/animations/ and lib/settings/global_storage.dart
- Adding unit/widget tests (weight storage, weight input, home screen)

## [1.4.0] 
### Upgrade
- Upgrading project to the last version of Flutter
- Upgrading all dependencies

## [1.3.0] 
### New features
- Adding push notifications

## [1.2.2] 
### Fix
- Fix dance hours

## [1.2.1] 
### New features
- Adding average speed

### Fix
- Fixing speed text to speech

### Upgrade
- Upgrading all dependencies

## [1.2.0] 
### New features
- Adding audio when app is in background
- Adding user speed in stopwatch
- Adding speed text to speech in stopwatch

## [1.1.0] 
### New features
- Adding split-running timer

### Upgrade
- Upgrading project to the last version of Flutter

## [1.0.2] 
### Upgrade
- Upgrading project to the last version of Flutter

## [1.0.1] 
### Changes
- Rename app
- Adding custom launch icon

## [1.0.0] 
### New features
- Initialization of the repository + base app
