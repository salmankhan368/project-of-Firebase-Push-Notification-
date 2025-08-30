import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:project_push_noti/Services/notification_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  NotificationServices notificationServices = NotificationServices();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notificationServices.requestNotificationPermission();
    // notificationServices.isTokenRefresh();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
    notificationServices.initLocalNotification(context, RemoteMessage());
    notificationServices
        .getDeviceToken()
        .then((value) {
          print("Device Token: $value");
        })
        .onError((error, stackTrace) {
          print("Error:$error");
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Center(
          child: Text(
            "Flutter push notification",
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
        ),
      ),
    );
  }
}
