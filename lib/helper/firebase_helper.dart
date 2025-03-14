import 'dart:collection';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:phoenix/firebase_options.dart';
import 'package:phoenix/helper/nav_helper.dart';
import 'package:phoenix/helper/preference_helper.dart';

// Background message handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling background message: ${message.messageId}");
}

class FirebaseHelper {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static Future<void> initializeFirebase() async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    // Request Notification Permission (iOS only)
    await requestPermission();

    // Initialize Local Notifications
    _initLocalNotifications();

    // Handle Foreground Messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Received message in foreground: ${message.notification?.title}");
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
      print('User granted permission');
    } else {
      print('User denied permission');
    }
  }

  // Get FCM Token
  static Future<String?> getFCMToken() async {
    String? token = await _firebaseMessaging.getToken();
    PreferenceHelper.saveFcm(token??"");
    print("FCM Token: $token");
    return token;
  }

  // Initialize Local Notifications
  static void _initLocalNotifications() {
    const AndroidInitializationSettings androidInitializationSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
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
      sound: RawResourceAndroidNotificationSound("notification")
    );

    const NotificationDetails details = NotificationDetails(android: androidDetails);

    await _flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      message.notification!.title,
      message.notification!.body,
      details,
    );
  }

  // Handle Notification Tap
  static void _handleNotificationTap(RemoteMessage message) {
    print("User tapped on notification: ${message.notification?.title}");
    openScreen(dashboardScreen,args: LinkedHashMap.from({"tab":1}),requiresAsInitial: true);
    // Navigate to a specific screen or perform an action
  }
}
