import 'package:ap_lib/authenticate/authentication_handler.dart';
import 'package:ap_lib/notification/notification_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'notification_model.dart';
import 'notification_list_component.dart';
import '../constants.dart';
import 'package:ap_lib/enum/enum_state.dart';

class NotificationPage extends StatefulWidget {

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  AuthenticationHandler _authenticationHandler;
  NotificationDataProvider _notificationDataProvider;

  LoadState _loadState = LoadState.Loading;

  List<NotificationModel> _notificationList = [];

  Future<List<NotificationModel>> _fetchNotificationList() async {
    String userToken = await _authenticationHandler.getToken();
    print(userToken);
    return _notificationDataProvider.getNotificationList(userToken);
  }

  @override
  void initState() {
    super.initState();
    _authenticationHandler = new AuthenticationHandler();
    _notificationDataProvider = new NotificationDataProvider();

    _fetchNotificationList().then((list) => {
      if (mounted) {
        setState(() {
          _notificationList = list;
          _loadState = LoadState.Done;
        })
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        padding: EdgeInsets.fromLTRB(screenWidth * 0.035, screenHeight * 0.02, screenWidth * 0.035, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // page title
            Container(
              padding: EdgeInsets.only(bottom: screenHeight * 0.005),
              child: Text(
                "Notifications",
                style: Constants.TEXT_STYLE_HEADING_1,
              ),
            ),

            _loadState == LoadState.Loading ? Expanded(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: 5,
                itemBuilder: (BuildContext context, int index) => NotificationListComponent(
                  loadState: LoadState.Loading,
                ),
              ),
            ) : _notificationList.length == 0 ? Container(
              margin: EdgeInsets.only(top: screenHeight * 0.01),
              child: Text(
                'No notification found.',
                style: Constants.TEXT_STYLE_NON_ALTERNATIVE_TEXT,
              ),
            ) : Expanded(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: _notificationList.length,
                itemBuilder: (BuildContext context, int index) => NotificationListComponent(
                  loadState: LoadState.Done,
                  notificationId: _notificationList[index].notificationId,
                  descriptionMessage: _notificationList[index].descriptionMessage,
                  relatedReminderId: _notificationList[index].relatedReminderId,
                  notificationDateTime: _notificationList[index].notificationDateTime,
                  notificationPrevDateTime: index == 0 ? '' : _notificationList[index - 1].notificationDateTime,
                  messageRead: _notificationList[index].messageRead,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}