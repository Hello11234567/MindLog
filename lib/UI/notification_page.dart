//알림 화면
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'record_emotion_page.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initNotifications(BuildContext context) async {
  tz.initializeTimeZones(); // 시간대 초기화

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) async {
      // 알림 클릭 시 RecordEmotionPage로 이동
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const RecordEmotionPage()),
      );
    },
  );
}

// 예약 알림 함수
Future<void> scheduleDailyEmotionNotification(TimeOfDay time) async {
  final now = tz.TZDateTime.now(tz.local);
  tz.TZDateTime scheduledDate = tz.TZDateTime(
    tz.local,
    now.year,
    now.month,
    now.day,
    time.hour,
    time.minute,
  );

  // 설정한 시간이 이미 지났으면 다음 날로 설정
  if (scheduledDate.isBefore(now)) {
    scheduledDate = scheduledDate.add(const Duration(days: 1));
  }

  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'daily_emotion_channel',
    'Daily Emotion',
    channelDescription: '오늘 하루 감정 기록 알림',
    importance: Importance.max,
    priority: Priority.high,
  );

  const NotificationDetails notificationDetails =
      NotificationDetails(android: androidDetails);

  await flutterLocalNotificationsPlugin.zonedSchedule(
    0,
    '오늘 하루는 어떠셨나요?',
    '감정을 기록해보세요!',
    scheduledDate,
    notificationDetails,
    androidAllowWhileIdle: true,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
    matchDateTimeComponents: DateTimeComponents.time, // 매일 반복
  );
}
