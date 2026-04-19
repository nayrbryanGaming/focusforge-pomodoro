import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';

class NotificationService {
  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

  static const String _channelId = 'focus_forge_alerts';
  static const String _channelName = 'Focus Alerts';
  static const String _channelDescription = 'Notifications for focus session and break completions';

  Future<void> init() async {
    tz.initializeTimeZones();
    
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await _notifications.initialize(initializationSettings);
    await _createChannel();
  }

  Future<void> _createChannel() async {
    if (Platform.isAndroid) {
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        _channelId,
        _channelName,
        description: _channelDescription,
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
      );

      await _notifications
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }
  }

  Future<bool> checkPermission() async {
    final status = await Permission.notification.isGranted;
    if (Platform.isAndroid && status) {
      // On Android 13+, notification is granted, but exact alarm might need separate checking
      return await Permission.scheduleExactAlarm.isGranted;
    }
    return status;
  }

  Future<bool> requestPermissions() async {
    if (Platform.isAndroid) {
      // 1. Request Notification Permission (Android 13+)
      final status = await Permission.notification.request();
      
      // 2. Request Exact Alarm Permission (Android 12+)
      if (status.isGranted) {
        final exactStatus = await Permission.scheduleExactAlarm.request();
        return exactStatus.isGranted;
      }
      return status.isGranted;
    }
    return true;
  }

  Future<void> showSessionCompleteNotification(String title, String body) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
      playSound: true,
      fullScreenIntent: true,
    );

    const DarwinNotificationDetails darwinDetails = DarwinNotificationDetails();

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
    );

    await _notifications.show(
      0,
      title,
      body,
      platformDetails,
    );
  }

  Future<void> scheduleNotification(int id, String title, String body, DateTime scheduledTime) async {
    if (scheduledTime.isBefore(DateTime.now())) return;

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      category: AndroidNotificationCategory.alarm,
    );

    const DarwinNotificationDetails darwinDetails = DarwinNotificationDetails();

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
    );

    await _notifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      platformDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> cancelAll() async {
    await _notifications.cancelAll();
  }
}

final notificationServiceProvider = Provider<NotificationService>((ref) => NotificationService());
