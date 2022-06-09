import 'dart:async';
import 'dart:convert';

import 'package:asset_flutter/static/colors.dart';
import 'package:asset_flutter/static/purchase_api.dart';
import 'package:asset_flutter/static/routes.dart';
import 'package:asset_flutter/static/token.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

Future<void> onBackgroundMessage(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("OnBGMEssage $message");

  if (message.data.containsKey('data')) {
    // Handle data message
    final data = message.data['data'];
  }

  if (message.data.containsKey('notification')) {
    // Handle notification message
    final notification = message.data['notification'];
  }
}

class FCM {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final _notifications = FlutterLocalNotificationsPlugin();
  final AndroidNotificationChannel channel = const  AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description: 'This channel is used for important notifications.', // description
    importance: Importance.max,
  );

  init() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    
    _notifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);
    const android = AndroidInitializationSettings("@drawable/ic_stat_p");
    const ios = IOSInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: ios);

    _notifications.initialize(
      settings
    );
  }

  void setNotifications() {
    FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);

    foregroundNotification();
    backgroundNotification();
    terminateNotification();

    _firebaseMessaging.getToken().then((value) async {
      if (PurchaseApi().userInfo != null && PurchaseApi().userInfo!.fcmToken != value) {
        await http.put(
          Uri.parse(APIRoutes().userRoutes.updateFCMToken),
          headers: UserToken().getBearerToken(),
          body: json.encode({
            "fcm_token": value,
          })
        );
      }
    });
  }

  void foregroundNotification() { // App foreground state
    FirebaseMessaging.onMessage.listen(
      (message) async {
        final notification = message.notification;
        final android = message.notification?.android;
        
        if (notification != null && android != null) {
          _notifications.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                icon: android.smallIcon,
                color: AppColors().primaryColor
              ),
            )
          );
        }

        if (message.data.containsKey('data')) {
          // Handle data message
        }
        if (message.data.containsKey('notification')) {
          // Handle notification message
        }
      },
    );
  }

  void backgroundNotification() { // App background state
    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) async {
        print("BG Received $message");
        if (message.data.containsKey('data')) {
          // Handle data message
        }
        if (message.data.containsKey('notification')) {
          // Handle notification message
        }
      },
    );
  }

  void terminateNotification() async { // App Closed state
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      print("Initial message $initialMessage");
      if (initialMessage.data.containsKey('data')) {
        // Handle data message
      }
      if (initialMessage.data.containsKey('notification')) {
        // Handle notification message
      }
    }
  }
}
