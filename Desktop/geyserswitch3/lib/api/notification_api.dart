import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

class NotificationApi {
  static final _notifications = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>();

  static Future _notificationDetails() async {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id',
        'channel name',
        //'channel description',
        importance: Importance.max,
      ),
      iOS: IOSNotificationDetails(),
    );
  }

  static Future init({bool initScheduled = false}) async {
    final android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final iOS = IOSInitializationSettings();
    final settings = InitializationSettings(android: android, iOS: iOS);

    await _notifications.initialize(
      settings,
      onSelectNotification: (payload) async {
        onNotifications.add(payload);
      },
    );

    if (initScheduled) {
      tz.initializeTimeZones();
      final locationName = await FlutterNativeTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(locationName));
    }
  }

  /// Direct Notification
  static Future showNotification({
    int id = 5,
    String? title,
    String? body,
    String? payload,
  }) async =>
      _notifications.show(
        id,
        title,
        body,
        await _notificationDetails(),
        payload: payload,
      );


  /// Daily Notification at 4 am
  static void showScheduledNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async =>
      _notifications.zonedSchedule(
        id,
        title,
        body,
        _scheduleDaily(Time(4, 00)),
        await _notificationDetails(),
        payload: payload,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );

  /// Weekly Notification on Monday and Tuesday at 8 am
  // static void showScheduledNotification({
  //   int id = 0,
  //   String? title,
  //   String? body,
  //   String? payload,
  // }) async {
  //   final scheduledDates =
  //       _scheduleWeekly(Time(9, 24), days: [DateTime.monday, DateTime.tuesday]);

  //   for (int i = 0; i < scheduledDates.length; i++) {
  //     final scheduledDate = scheduledDates[i];

  //     _notifications.zonedSchedule(
  //       id + i,
  //       title,
  //       body,
  //       scheduledDate,
  //       await _notificationDetails(),
  //       payload: payload,
  //       androidAllowWhileIdle: true,
  //       uiLocalNotificationDateInterpretation:
  //           UILocalNotificationDateInterpretation.absoluteTime,
  //       matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
  //     );
  //   }
  // }

  static tz.TZDateTime _scheduleDaily(Time time) {
    final now = tz.TZDateTime.now(tz.local);
    final scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day,
        time.hour, time.minute, time.second);

    return scheduledDate.isBefore(now)
        ? scheduledDate.add(Duration(days: 1))
        : scheduledDate;
  }

  static List<tz.TZDateTime> _scheduleWeekly(Time time,
      {required List<int> days}) {
    return days.map((day) {
      tz.TZDateTime scheduledDate = _scheduleDaily(time);

      while (day != scheduledDate.weekday) {
        scheduledDate = scheduledDate.add(Duration(days: 1));
      }
      return scheduledDate;
    }).toList();
  }
}
