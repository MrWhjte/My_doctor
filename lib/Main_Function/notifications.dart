import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationHelper {
  static final FlutterLocalNotificationsPlugin _notification = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _notification.initialize(initializationSettings);
    tz.initializeTimeZones();
  }

  static Future<void> scheduleNotifications(List<String> days, String timeStrings)
  async {
    String title = 'Thông báo';
    String body = 'Đã đến giờ uống thuốc';
    if(days.isNotEmpty && timeStrings!=''){
      List<TimeOfDay> times = _parseTimeString(timeStrings);
      DateTime now = DateTime.now();

      for (String day in days) {
        int dayInt = int.parse(day);
        for (TimeOfDay time in times) {
          DateTime scheduledDate = DateTime(
              now.year, now.month, dayInt, time.hour, time.minute);
          await _scheduleNotification(scheduledDate, title, body);
        }
      }
    }
  }
  static List<TimeOfDay> _parseTimeString(String timeString) {
    final timeList = timeString.replaceAll('[', '').replaceAll(']', '').split(', ');
    return timeList.map((time) {
      final parts = time.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      return TimeOfDay(hour: hour, minute: minute);
    }).toList();

  }

  static Future<void> _scheduleNotification(DateTime scheduledDate, String title, String body) async {
    var androidDetails = const AndroidNotificationDetails(
      'channelId',
      'channelName',
      importance: Importance.max,
      priority: Priority.high,
    );

    var notificationDetails = NotificationDetails(android: androidDetails);

    await _notification.zonedSchedule(
      scheduledDate.hashCode, // or  0
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      notificationDetails,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfMonthAndTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }
}
