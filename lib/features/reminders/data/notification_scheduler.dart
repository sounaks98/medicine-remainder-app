import 'package:flutter/foundation.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:timezone/timezone.dart' as tz;



/// Schedules local notifications from confirmed medicines.

class NotificationScheduler {

  NotificationScheduler({FlutterLocalNotificationsPlugin? plugin})

      : _plugin = plugin ?? FlutterLocalNotificationsPlugin();



  final FlutterLocalNotificationsPlugin _plugin;



  static const _androidChannelId = 'medicine_reminders_alarm_v1';

  static const _androidChannelName = 'Medicine reminders';



  static Future<NotificationScheduler> create() async {

    final scheduler = NotificationScheduler();

    await scheduler._initialize();

    return scheduler;

  }



  Future<void> _initialize() async {

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    const settings = InitializationSettings(android: androidSettings);

    await _plugin.initialize(settings);



    final android = _android;

    await android?.createNotificationChannel(

      const AndroidNotificationChannel(

        _androidChannelId,

        _androidChannelName,

        description: 'Audible reminders for confirmed medicines',

        importance: Importance.max,

        playSound: true,

        enableVibration: true,

        audioAttributesUsage: AudioAttributesUsage.alarm,

      ),

    );

  }



  AndroidFlutterLocalNotificationsPlugin? get _android =>

      _plugin.resolvePlatformSpecificImplementation<

          AndroidFlutterLocalNotificationsPlugin>();



  Future<bool> requestPermissionIfNeeded() async {

    if (defaultTargetPlatform != TargetPlatform.android) {

      return true;

    }

    final granted = await _android?.requestNotificationsPermission();

    return granted ?? true;

  }



  /// Notifications + exact-alarm permission before scheduling medicine reminders.

  Future<void> ensureAndroidAlarmSchedulingReady() async {

    if (defaultTargetPlatform != TargetPlatform.android) {

      return;

    }

    await requestPermissionIfNeeded();

    final canExact = await _android?.canScheduleExactNotifications();

    if (canExact != true) {

      await _android?.requestExactAlarmsPermission();

    }

  }



  Future<void> schedule({

    required int notificationId,

    required DateTime fireAtLocal,

    required String title,

    required String body,

    String? payload,

  }) async {

    final scheduled = tz.TZDateTime(

      tz.local,

      fireAtLocal.year,

      fireAtLocal.month,

      fireAtLocal.day,

      fireAtLocal.hour,

      fireAtLocal.minute,

      fireAtLocal.second,

      fireAtLocal.millisecond,

      fireAtLocal.microsecond,

    );

    if (scheduled.isBefore(tz.TZDateTime.now(tz.local))) {

      return;

    }



    final scheduleMode = await _resolveAndroidScheduleMode();



    const details = NotificationDetails(

      android: AndroidNotificationDetails(

        _androidChannelId,

        _androidChannelName,

        channelDescription: 'Audible reminders for confirmed medicines',

        importance: Importance.max,

        priority: Priority.max,

        playSound: true,

        enableVibration: true,

        category: AndroidNotificationCategory.alarm,

        audioAttributesUsage: AudioAttributesUsage.alarm,

        visibility: NotificationVisibility.public,

      ),

    );



    await _plugin.zonedSchedule(

      notificationId,

      title,

      body,

      scheduled,

      details,

      androidScheduleMode: scheduleMode,

      payload: payload,

    );

  }



  Future<AndroidScheduleMode> _resolveAndroidScheduleMode() async {

    if (defaultTargetPlatform != TargetPlatform.android) {

      return AndroidScheduleMode.inexactAllowWhileIdle;

    }

    final canExact = await _android?.canScheduleExactNotifications();

    if (canExact == true) {

      return AndroidScheduleMode.exactAllowWhileIdle;

    }

    return AndroidScheduleMode.alarmClock;

  }



  Future<void> cancel(int notificationId) async {

    await _plugin.cancel(notificationId);

  }

}


