import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;

// ignore: avoid_classes_with_only_static_members
class NotificationService {
  static final _notifications = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>();

  static Future<NotificationDetails> _notificationDetails() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id',
        'channel name',
        channelDescription: 'channel description',
        importance: Importance.max,
        color: Color.fromARGB(255, 255, 146, 123),
      ),
      iOS: DarwinNotificationDetails(badgeNumber: 1),
    );
  }

  static Future init({bool initShcheduled = false}) async {
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_notification');
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings();
    const InitializationSettings settings = InitializationSettings(android: androidSettings, iOS: iosSettings);

    // When app is closed
    final NotificationAppLaunchDetails? details = await _notifications.getNotificationAppLaunchDetails();
    if (details != null && details.didNotificationLaunchApp) {
      onNotifications.add(details.notificationResponse?.payload);
    }

    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {
        onNotifications.add(notificationResponse.payload);
      },
    );

    if (initShcheduled) {
      final String locationName = await FlutterNativeTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(locationName));
    }
  }

  static Future<void> showNotification({int id = 0, String? title, String? body, String? payload}) async {
    _notifications.show(id, title, body, await _notificationDetails(), payload: payload);
  }

  static Future<void> showScheduledNotification({int id = 0, String? title, String? body, String? payload, required TimeOfDay time, required int day}) async {
    final tz.TZDateTime scheduledDate = _scheduleWeekly(time: time, day: day);

    _notifications.zonedSchedule(
      id, // choose for each notification an index that is unique
      title,
      body,
      scheduledDate,
      await _notificationDetails(),
      payload: payload,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }

  static tz.TZDateTime _scheduleWeekly({required TimeOfDay time, required int day}) {
    tz.TZDateTime scheduledDate = _scheduleDaily(time: time);

    while (day != scheduledDate.weekday) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  static tz.TZDateTime _scheduleDaily({required TimeOfDay time}) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    final tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, time.hour, time.minute);

    return scheduledDate.isBefore(now) ? scheduledDate.add(const Duration(days: 1)) : scheduledDate;
  }

  static void cancel({required int id}) => _notifications.cancel(id);

  static void cancelAll() => _notifications.cancelAll();

  static final NotificationService _notificationService = NotificationService._internal();
  factory NotificationService() {
    return _notificationService;
  }
  NotificationService._internal();
}

final NotificationService notificationService = NotificationService();
