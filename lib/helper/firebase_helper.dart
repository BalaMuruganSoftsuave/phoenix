import 'dart:collection';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:phoenix/firebase_options.dart';
import 'package:phoenix/helper/nav_helper.dart';
import 'package:phoenix/helper/preference_helper.dart';
import 'package:phoenix/screens/dashboard.dart';

import 'nav_observer.dart';

// Background message handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint("Handling background message: ${message.messageId}");
}

class FirebaseHelper {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static Future<void> initializeFirebase() async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    // Request Notification Permission (iOS only)
    await requestPermission();
    // Wait for APNs token to be set (iOS only)
    if (Platform.isIOS) {
      String? apnsToken;
      int retry = 0;
      // Try for up to 2 seconds (20 x 100ms)
      while (apnsToken == null && retry < 20) {
        apnsToken = await FirebaseMessaging.instance.getAPNSToken();
        if (apnsToken == null) {
          await Future.delayed(Duration(milliseconds: 100));
          retry++;
        }
      }
      debugPrint('APNs Token: $apnsToken');
    }

    // Initialize Local Notifications
    _initLocalNotifications();

    // Handle Foreground Messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint("Received message in foreground: ${message.notification?.title}");
      _showNotification(message);
    });

    // Handle Notification Taps when App is Terminated
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        _handleNotificationTap(message);
      }
    });

    // Handle Notification Taps when App is in Background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotificationTap(message);
    });

    // Background Message Handling
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  // Request Permission (For iOS)
  static Future<void> requestPermission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted permission');
    } else {
      debugPrint('User denied permission');
    }
  }

  // Get FCM Token
  static Future<String?> getFCMToken() async {
    String? token = await _firebaseMessaging.getToken();
    PreferenceHelper.saveFcm(token??"");
    debugPrint("FCM Token: $token");
    return token;
  }

  // Initialize Local Notifications
  static void _initLocalNotifications() {
    const AndroidInitializationSettings androidInitializationSettings =
    AndroidInitializationSettings('@drawable/notification_icon');

    final InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,iOS: DarwinInitializationSettings()
    );

    _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Show Local Notification when received in Foreground
  static void _showNotification(RemoteMessage message) async {
    if (message.notification == null) return;

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      icon: "@drawable/notification_icon",
      sound: RawResourceAndroidNotificationSound("notification"),
      largeIcon: DrawableResourceAndroidBitmap('ic_launcher'), //
    );

    const iOSNotificationDetails=DarwinNotificationDetails(sound: "notification.caf");
    const NotificationDetails details = NotificationDetails(android: androidDetails,iOS: iOSNotificationDetails);

    await _flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      message.notification!.title,
      message.notification!.body,
      details,
    );
  }

  // Handle Notification Tap
  static void _handleNotificationTap(RemoteMessage message) {
    debugPrint("User tapped on notification: ${message.notification?.title}");
    var initialLogin= PreferenceHelper.getInitialLogin();
    if(initialLogin) {
      NavObserver.navKey.currentState?.pushReplacement(
        MaterialPageRoute(
            builder: (_) => Dashboard(LinkedHashMap.from({"tab": 1}))),
      );
    }
    // Navigate to a specific screen or perform an action
  }
}
