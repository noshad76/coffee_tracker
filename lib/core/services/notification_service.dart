import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'package:flutter_timezone/flutter_timezone.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static final ValueNotifier<int> openLogDrinkTrigger = ValueNotifier<int>(0);

  static void triggerOpenLogDrink() {
    openLogDrinkTrigger.value++;
  }

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    tz.initializeTimeZones();
    try {
      final timezoneInfo = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timezoneInfo.identifier));
    } catch (_) {
      // Fallback if local timezone lookup fails
    }

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        );
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) {
        triggerOpenLogDrink();
      },
    );
    if (Platform.isAndroid) {
      final androidPlugin = flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      await androidPlugin?.createNotificationChannel(
        const AndroidNotificationChannel(
          'coffeeaholic_reminders',
          'Reminders',
          description: 'Daily reminders to log your coffee',
          importance: Importance.max,
        ),
      );
    }
    _initialized = true;

    try {
      final launchDetails = await flutterLocalNotificationsPlugin
          .getNotificationAppLaunchDetails();
      if (launchDetails?.didNotificationLaunchApp == true ||
          launchDetails?.notificationResponse != null) {
        triggerOpenLogDrink();
      }
    } catch (_) {}

    try {
      await scheduleDefaultDailyCheckIn();
    } catch (_) {}
  }

  Future<bool> requestPermissions() async {
    if (!_initialized) {
      await init();
    }
    bool? granted;
    if (Platform.isIOS) {
      granted = await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    } else if (Platform.isAndroid) {
      final androidPlugin = flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      granted = await androidPlugin?.requestNotificationsPermission();
      try {
        await androidPlugin?.requestExactAlarmsPermission();
      } catch (_) {}
    }
    return granted ?? false;
  }

  Future<bool> areNotificationsEnabled() async {
    if (Platform.isAndroid) {
      final androidPlugin = flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      return (await androidPlugin?.areNotificationsEnabled()) ?? false;
    }
    return true;
  }

  Future<void> scheduleDailyReminder(
    int id,
    int hour,
    int minute,
    String title,
    String body,
  ) async {
    final now = tz.TZDateTime.now(tz.local);
    var tzDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (tzDate.isBefore(now)) {
      tzDate = tzDate.add(const Duration(days: 1));
    }

    var scheduleMode = AndroidScheduleMode.inexactAllowWhileIdle;
    if (Platform.isAndroid) {
      try {
        final androidPlugin = flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
        final canExact = await androidPlugin?.canScheduleExactNotifications();
        if (canExact == true) {
          scheduleMode = AndroidScheduleMode.exactAllowWhileIdle;
        }
      } catch (_) {}
    }

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: tzDate,
      payload: 'log_drink',
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'coffeeaholic_reminders',
          'Reminders',
          channelDescription: 'Daily reminders to log your coffee',
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
          color: Color(0xFFA6663E),
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      androidScheduleMode: scheduleMode,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> showTestNotification() async {
    if (!_initialized) {
      await init();
    }
    await requestPermissions();

    await flutterLocalNotificationsPlugin.show(
      id: 8888,
      title: '☕ Coffee Break Test',
      body: 'Notifications are working! Tap this notification to log a brew.',
      payload: 'log_drink',
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'coffeeaholic_reminders',
          'Reminders',
          channelDescription: 'Daily reminders to log your coffee',
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
          color: Color(0xFFA6663E),
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
    );
  }

  static const int dailyCheckInNotificationId = 9999;

  Future<void> scheduleDefaultDailyCheckIn() async {
    await init();
    await scheduleDailyReminder(
      dailyCheckInNotificationId,
      21,
      0,
      '☕ Daily Coffee Check-in',
      'Did you have a brew today? Tap to log your cups and keep your stats accurate!',
    );
  }

  Future<void> cancelReminder(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id: id);
  }

  Future<void> cancelAllReminders() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
