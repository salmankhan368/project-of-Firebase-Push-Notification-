import 'dart:io';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:project_push_noti/page/message_page.dart';

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  void requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      sound: true,
      announcement: true,
      carPlay: true,
      provisional: true,
      criticalAlert: true,
      badge: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("user granted permission");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('user granted provisonal permision');
    } else {
      print("user deniyed permission");
    }
  }

  void initLocalNotification(
    BuildContext context,
    RemoteMessage message,
  ) async {
    var androidIntializationSettings = AndroidInitializationSettings(
      "@mipmap/ic_launcher",
    );
    var iosIntializationSettings = DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(
      android: androidIntializationSettings,
      iOS: iosIntializationSettings,
    );
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (payload) {
        handleMessage(context, message);
      },
    );
  }

  void firebaseInit(BuildContext context) async {
    FirebaseMessaging.onMessage.listen((message) {
      if (kDebugMode) {
        print(message.notification!.title.toString());
        print(message.notification!.body.toString());
        print(message.data.toString());
        print(message.data['type']);
        print(message.data['id']);
      }
      if (Platform.isAndroid) {
        initLocalNotification(context, message);
        ShowNotification(message);
      } else {
        ShowNotification(message);
      }
    });
  }

  Future<void> ShowNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      Random.secure().nextInt(100).toString(),
      "High Importance notification",
      importance: Importance.max,
    );
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
          channel.id.toString(),
          channel.id.toString(),
          channelDescription: "Your Channel description",
          importance: Importance.high,
          priority: Priority.high,
          ticker: 'ticker',
        );
    DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentBanner: true,
          presentList: true,
          presentSound: true,
        );
    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );
    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
        0,
        message.notification!.title.toString(),
        message.notification!.body.toString(),
        notificationDetails,
      );
    });
  }

  Future<String> getDeviceToken() async {
    String? token = await messaging.getToken();
    return token!;
  }

  void isTokenRefresh() async {
    messaging.onTokenRefresh.listen((event) {
      event.toString();
      print("refresh");
    });
  }

  //when my application is an background and i click on those noti which i direct to my msg screen
  Future<void> setupInteractMessage(BuildContext context) async {
    RemoteMessage? initialMessage = await FirebaseMessaging.instance
        .getInitialMessage();
    if (initialMessage != null) {
      handleMessage(context, initialMessage);
    }
    //when app is on background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      handleMessage(context, message);
    });
  }

  //redirecting to screen
  void handleMessage(BuildContext context, RemoteMessage message) {
    if (message.data['type'] == 'msg') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MessagePage(id: message.data['id']),
        ),
      );
    }
  }
}
