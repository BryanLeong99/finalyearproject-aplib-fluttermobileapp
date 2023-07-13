import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:ap_lib/authenticate/authentication_handler.dart';
import 'package:ap_lib/authenticate/otp_handler.dart';
import 'package:ap_lib/booking/create_booking_page.dart';
import 'package:ap_lib/constants.dart';
import 'package:ap_lib/dashboard/code_scanner_page.dart';
import 'package:ap_lib/notification/notification_data_provider.dart';
import 'package:ap_lib/notification/notification_model.dart';
import 'package:ap_lib/notification/notification_page.dart';
import 'package:ap_lib/search_catalogue/book_data_fetcher.dart';
import 'package:ap_lib/tag_writing/tag_writing_page.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ap_lib/search_catalogue/search_catalogue_page.dart';
import 'package:ap_lib/booking/booking_page.dart';
import 'package:ap_lib/dashboard/more_option_page.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:badges/badges.dart';
import 'package:photo_view/photo_view.dart';
import 'package:pinch_zoom/pinch_zoom.dart';
import '../main.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ap_lib/firebase/push_notification_service_provider.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:ap_lib/book_loan/scan_result_page.dart';
import 'package:ap_lib/news_announcement/news_announcement_page.dart';
import 'home_page.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DashboardPage extends StatefulWidget {
  final int pageIndex;

  DashboardPage({
    this.pageIndex
  });

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedPageIndex = 2;

  int _numberOfUnreadNotification = 0;

  String _userRole;

  PageController _pageController;
  AuthenticationHandler _authenticationHandler;
  NotificationDataProvider _notificationDataProvider;
  BookDataFetcher _bookDataFetcher;

  List<NotificationModel> _notificationList = [];

  List<String> _roomIdList = [
    'DR001',
    'DR002',
    'DR003',
    'DR004',
    'DR005',
    'DR006',
    'DR007',
    'DR008',
  ];

  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  Future<List<NotificationModel>> _fetchNotificationList() async {
    String userToken = await _authenticationHandler.getToken();
    return _notificationDataProvider.getNotificationList(userToken);
  }

  int _calculateTotalUnreadNotification(List<NotificationModel> _notificationList) {
    int _total = 0;
    _notificationList.forEach((element) {
      if (!element.messageRead) {
        _total++;
      }
    });

    return _total;
  }

  void _searchButtonHandler() {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => SearchCataloguePage()),
    );
  }

  ////////////////////////////////////
  // bool isImageloaded = false;
  // Future<ui.Image> loadImage(List<int> img) async {
  //   final Completer<ui.Image> completer = new Completer();
  //   ui.decodeImageFromList(img, (ui.Image img) {
  //     setState(() {
  //       isImageloaded = true;
  //     });
  //     return completer.complete(img);
  //   });
  //   return completer.future;
  // }
  //
  // Image testImage;
  //
  // void generateMap() async {
  //   var _pictureRecorder = ui.PictureRecorder();
  //   var _canvas = Canvas(_pictureRecorder);
  //   var _paint = Paint();
  //   var _paint2 = Paint();
  //   ByteData data = await rootBundle.load('assets/library-map.png');
  //   ui.Image _image = await loadImage(new Uint8List.view(data.buffer));
  //
  //   _paint.isAntiAlias = true;
  //   _paint.color = Constants.COLOR_RED;
  //   _paint2.isAntiAlias = true;
  //   _paint2.color = Constants.COLOR_BLUE_SECONDARY;
  //
  //   // _canvas.drawRect(Rect.fromLTWH(0.0, 0.0, 100.0, 100.0), _paint);
  //   _canvas.drawImage(_image, new Offset(0.5, 0.5), _paint);
  //   _canvas.drawCircle(new Offset(965, 2310), 40.0, _paint);
  //   _canvas.drawCircle(new Offset(1030, 2310), 40.0, _paint2);
  //   _canvas.drawCircle(new Offset(1100, 2310), 40.0, _paint);
  //   _canvas.drawCircle(new Offset(1165, 2310), 40.0, _paint2);
  //   _canvas.drawCircle(new Offset(1235, 2310), 40.0, _paint);
  //
  //   _canvas.drawCircle(new Offset(1190, 3405), 40.0, _paint);
  //   _canvas.drawCircle(new Offset(1255, 3405), 40.0, _paint2);
  //   _canvas.drawCircle(new Offset(1325, 3405), 40.0, _paint);
  //   _canvas.drawCircle(new Offset(1390, 3405), 40.0, _paint2);
  //   _canvas.drawCircle(new Offset(1460, 3405), 40.0, _paint);
  //
  //   _canvas.drawCircle(new Offset(323, 765), 40.0, _paint);
  //   _canvas.drawCircle(new Offset(458, 700), 40.0, _paint2);
  //   _canvas.drawCircle(new Offset(484, 630), 40.0, _paint);
  //   _canvas.drawCircle(new Offset(458, 565), 40.0, _paint2);
  //   _canvas.drawCircle(new Offset(458, 495), 40.0, _paint);
  //   var pic = _pictureRecorder.endRecording();
  //   ui.Image img = await pic.toImage(_image.width, _image.height);
  //   var byteData = await img.toByteData(format: ui.ImageByteFormat.png);
  //   var buffer = byteData.buffer.asUint8List();
  //
  //   setState(() {
  //     testImage = Image.memory(buffer);
  //   });
  // }
  //////////////

  void _scanCodeButtonHandler() async {
    // Navigator.push(
    //   context,
    //   CupertinoPageRoute(builder: (context) => CodeScannerPage()),
    // );
    await Permission.camera.request();
    String cameraScanResult = await scanner.scan();
    if (cameraScanResult == null) {
      print('nothing return.');
    } else if (cameraScanResult.contains('DR', 0)) {
      if (_roomIdList.contains(cameraScanResult)) {
        Navigator.push(
          context,
          CupertinoPageRoute(builder: (context) => CreateBookingPage(roomId: cameraScanResult)),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              "Invalid Code",
              style: Constants.TEXT_STYLE_DIALOG_TITLE_AND_ACTION_1,
            ),
            content: Text(
              "Invalid room ID.",
              style: Constants.TEXT_STYLE_DIALOG_CONTENT,
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "OK",
                  style: Constants.TEXT_STYLE_DIALOG_TITLE_AND_ACTION_1,
                ),
              ),
            ],
          ),
        );
      }

    } else if (cameraScanResult.contains('TG', 0) && cameraScanResult.length == 10 && _userRole == 'Library Staff') {
      Navigator.push(
        context,
        CupertinoPageRoute(builder: (context) => TagWritingPage(barcode: cameraScanResult.substring(2, 10),)),
      );
    } else {
      EasyLoading.show(
        status: 'Searching...',
        maskType: EasyLoadingMaskType.black,
      );
      _bookDataFetcher.searchWithCode(cameraScanResult).then((list) async => {
      EasyLoading.dismiss(),
        print(list),
        Navigator.push(
          context,
          CupertinoPageRoute(builder: (context) => ScanResultPage(
            itemId: list.length != 0 ? list[0].itemId : '',
            bookImage: list.length != 0 ? Image.network(list[0].imageUrl) : null,
            bookTitle: list.length != 0 ? list[0].bookTitle : '',
            bookAuthor: list.length != 0 ? list[0].bookAuthor : '',
            tagName: list.length != 0 ? list[0].tagName : '',
            availabilityStatus: list.length != 0 ? list[0].availabilityStatus : '',
          )),
        ),
      });
    }
  }

  void _onOptionTap(int index) {
    setState(() {
      _selectedPageIndex = index;
      _pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 200),
        curve: Curves.easeOutCubic
      );
    });
  }

  void _onPageChange(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;

      if (_connectionStatus.toString() != 'ConnectivityResult.none') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Connected to Internet',
              style: Constants.TEXT_STYLE_SNACK_BAR_CONTENT,
            ),
            backgroundColor: Constants.COLOR_GREEN_LIGHT,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Connection Lost.',
              style: Constants.TEXT_STYLE_SNACK_BAR_CONTENT,
            ),
            backgroundColor: Constants.COLOR_RED,
          ),
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _bookDataFetcher = new BookDataFetcher();

    new PushNotificationServiceProvider().getDeviceToken();

    if (widget.pageIndex != null) {
      _selectedPageIndex = widget.pageIndex;
    }
    _pageController = new PageController(initialPage: _selectedPageIndex);

    _authenticationHandler = new AuthenticationHandler();
    _notificationDataProvider = new NotificationDataProvider();

    _authenticationHandler = new AuthenticationHandler();

    _authenticationHandler.getRole().then((role) => {
      setState(() {
        _userRole = role;
        print(_userRole);
      }),
    });

    _fetchNotificationList().then((list) => {
      if (mounted) {
        setState(() {
          _notificationList = list;
          _numberOfUnreadNotification = _calculateTotalUnreadNotification(_notificationList);
        })
      }
    });

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {

      if (message != null) {
        print(message);
        // Navigator.pushNamed(context, '/message',
        //     arguments: MessageArguments(message, true));
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      print("On app opened notification triggered.");
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channel.description,
              priority: Priority.max,
              importance: Importance.max,
              // TODO add a proper drawable resource to android, for now using
              //      one that already exists in example app.
              icon: 'app_icon',
              largeIcon: DrawableResourceAndroidBitmap('app_icon_big'),
              channelShowBadge: true,
            ),
          ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      // Navigator.pushNamed(context, '/message',
      //     arguments: MessageArguments(message, true));
    });

    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();


  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: false,
        title: Image.asset('assets/app-bar-icon.png'),
        actions: [
          GestureDetector(
            onTap: () => _searchButtonHandler(),
            child: Container(
              padding: EdgeInsets.fromLTRB(screenWidth * 0.03, screenHeight * 0.005,
                  screenWidth * 0.03, 0.0
              ),
              child: Icon(
                Icons.search_rounded,
                color: Constants.COLOR_BLUE_SAPPHIRE,
                size: 35,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => _scanCodeButtonHandler(),
            child: Container(
              padding: EdgeInsets.fromLTRB(screenWidth * 0.03, screenHeight * 0.005,
                screenWidth * 0.03, 0.0
              ),
              child: Icon(
                Icons.qr_code_scanner_rounded,
                color: Constants.COLOR_BLUE_SAPPHIRE,
                size: 35,
              ),
            ),
          )
        ],
      ),
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          physics: BouncingScrollPhysics(),
          onPageChanged: (index) => _onPageChange(index),
          children: [
            NewsAnnouncementPage(),
            BookingPage(),
            HomePage(),
            NotificationPage(),
            MoreOptionPage(),
          ],
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedPageIndex,
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: Constants.COLOR_BLUE_THEME,
        color: Constants.COLOR_BLUE_THEME,
        height: 50.0,
        animationDuration: Duration(milliseconds: 200),
        onTap: (index) => _onOptionTap(index),
        items: [
          Icon(
            Icons.campaign_rounded,
            color: Constants.COLOR_WHITE,
            size: 30,
          ),
          Icon(
            Icons.event_available_rounded,
            color: Constants.COLOR_WHITE,
            size: 30,
          ),
          Icon(
            Icons.home_rounded,
            color: Constants.COLOR_WHITE,
            size: 30,
          ),
          Badge(
            badgeContent: Text(
              _notificationList.length == 0 ? '0' : _numberOfUnreadNotification.toString(),
              style: Constants.TEXT_STYLE_BADGE_TEXT,
            ),
            badgeColor: Constants.COLOR_RED,
            child: Icon(
              Icons.notifications_rounded,
              color: Constants.COLOR_WHITE,
              size: 30,
            ),
          ),
          Icon(
            Icons.more_vert_rounded,
            color: Constants.COLOR_WHITE,
            size: 30,
          ),
        ],
      ),
    );
  }

}