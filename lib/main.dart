// import 'package:ap_lib/root.dart';
import 'package:ap_lib/authenticate/authentication_handler.dart';
import 'package:ap_lib/authenticate/login_page.dart';
import 'package:ap_lib/dashboard/dashboard_page.dart';
import 'package:ap_lib/constants.dart';
import 'package:flutter/material.dart';
import 'package:flare_splash_screen/flare_splash_screen.dart';
import 'package:ap_lib/firebase/push_notification_service_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// import 'package:dcdg/dcdg.dart';


void configLoading() {
  EasyLoading.instance
    // ..animationDuration = Duration(milliseconds: 800)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.light
    ..indicatorSize = 45.0
    // ..indicatorSize = 25.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

/// Create a [AndroidNotificationChannel] for heads up notifications
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.max,
  playSound: true,
);

/// Initialize the [FlutterLocalNotificationsPlugin] package.
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AuthenticationHandler _authenticationHandler = new AuthenticationHandler();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  // await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
  //   alert: true,
  //   badge: true,
  //   sound: true,
  // );


  final NotificationAppLaunchDetails notificationAppLaunchDetails =
  await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('app_icon');

  final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);


  _authenticationHandler.getToken().then((token) => {
    runApp(MyApp(token)),
    configLoading(),
  });
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final String authenticationToken;

  MyApp(this.authenticationToken);

  @override
  Widget build(BuildContext context) {
    PushNotificationServiceProvider test = new PushNotificationServiceProvider();
    // test.testPrint();

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Constants.colorBlueSecondarySwatch,
      ),
      home: SplashScreen.navigate(
        name: "assets/app_splash.flr",
        next: (context) => authenticationToken == '' ? LoginPage() : DashboardPage(),
        until: () => Future.delayed(Duration(seconds: 4)),
        startAnimation: 'splash-screen',
        fit: BoxFit.cover,
        backgroundColor: Colors.white,
        // backgroundColor: Color(0xFF36393F),
      ),
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
    );
  }
}



