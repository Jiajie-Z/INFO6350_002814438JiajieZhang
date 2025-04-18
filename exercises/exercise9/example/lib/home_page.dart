// home_page.dart
import 'dart:async';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FlutterLocalNotificationsPlugin _notifier =
  FlutterLocalNotificationsPlugin();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _initNotifications();
    _configureRemoteConfig();
  }

  Future<void> _initNotifications() async {
    // Android setup
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    // iOS setup
    const iOS = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const settings = InitializationSettings(android: android, iOS: iOS);

    await _notifier.initialize(settings);
  }

  Future<void> _configureRemoteConfig() async {
    final rc = FirebaseRemoteConfig.instance;
    // Set a default in case fetch fails
    await rc.setDefaults(<String, dynamic>{
      'periodic_local_notification': 60, // default to 60 seconds
    });
    try {
      await rc.fetchAndActivate();
    } catch (e) {
      debugPrint('Remote Config fetch failed: $e');
    }

    final interval = rc.getInt('periodic_local_notification');
    _startPeriodicNotifications(interval);
  }

  void _startPeriodicNotifications(int seconds) {
    // Cancel any existing timer
    _timer?.cancel();

    _timer = Timer.periodic(Duration(seconds: seconds), (_) {
      _showNotification();
    });
  }

  Future<void> _showNotification() async {
    const androidDetails = AndroidNotificationDetails(
      'periodic_channel',
      'Periodic Notifications',
      channelDescription: 'Fires every configured interval',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );
    const iOSDetails = IOSNotificationDetails();
    const platformDetails =
    NotificationDetails(android: androidDetails, iOS: iOSDetails);

    await _notifier.show(
      0,
      'Hey there!',
      'This notification fires every update cycle.',
      platformDetails,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Remote Config & Notifications')),
      body: const Center(child: Text('Waiting for notifications…')),
    );
  }
}
