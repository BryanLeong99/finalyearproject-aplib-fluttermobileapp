import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationServiceProvider {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future initialize() async {
    RemoteMessage initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    // irebaseMessaging.configure()
    // _firebaseMessaging.configure()
  }

  Future<String> getDeviceToken() async {
    String deviceToken = await _firebaseMessaging.getToken();
    print(deviceToken);

    return deviceToken;
  }
}