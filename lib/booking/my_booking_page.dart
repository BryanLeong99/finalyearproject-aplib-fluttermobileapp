import 'package:ap_lib/booking/room_data_fetcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:permission_handler/permission_handler.dart';
import 'booking_details.dart';
import 'package:ap_lib/authenticate/authentication_handler.dart';
import '../constants.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';
import 'package:ap_lib/enum/enum_state.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class MyBookingPage extends StatefulWidget {
  @override
  _MyBookingPageState createState() => _MyBookingPageState();
}

class _MyBookingPageState extends State<MyBookingPage> {
  RoomDataFetcher _roomDataFetcher;
  DateFormat _dateFormatter;
  List<BookingDetails> _bookingDetailsList = [];
  LoadState _loadState = LoadState.Loading;

  _back(BuildContext context) {
    Navigator.pop(context);
  }

  Future<List<BookingDetails>> _fetchBookingDetails() async {
    String userToken = await new AuthenticationHandler().getToken();
    return await _roomDataFetcher.getBookingDetails(userToken);
  }

  void _accessRoom(String bookingId, String status) async {
    await Permission.camera.request();
    String cameraScanResult = await scanner.scan();
    if (cameraScanResult == null) {
      print('nothing return.');
    } else if (cameraScanResult == _bookingDetailsList[0].roomId) {
      EasyLoading.show(
        status: 'Processing...',
        maskType: EasyLoadingMaskType.black,
      );
      var _currentTime = DateTime.now();
      var _bookingTime = DateTime.fromMillisecondsSinceEpoch(int.parse(_bookingDetailsList[0].startingTime + '000'));
      if (_currentTime.isAtSameMomentAs(_bookingTime) || _currentTime.isAfter(_bookingTime)) {
        _roomDataFetcher.updateBookingStatus(bookingId, status).then((status) =>
        {
          EasyLoading.dismiss(),
          if (status == 'success') {
            _loadState = LoadState.Loading,
            _fetchBookingDetails().then((List<BookingDetails> list) =>
            {
              setState(() {
                _bookingDetailsList = list;
                _loadState = LoadState.Done;
              })
            }),
          } else
            {
              showDialog(
                context: context,
                builder: (context) =>
                    AlertDialog(
                      title: Text(
                        "Access Failed",
                        style: Constants.TEXT_STYLE_DIALOG_TITLE_AND_ACTION_1,
                      ),
                      content: Text(
                        "Unexpected error. Please try again later.",
                        style: Constants.TEXT_STYLE_DIALOG_CONTENT,
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "OK",
                            style: Constants
                                .TEXT_STYLE_DIALOG_TITLE_AND_ACTION_1,
                          ),
                        ),
                      ],
                    ),
              ),
            }
        });
      } else {
        EasyLoading.dismiss();
        showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(
                title: Text(
                  "Access Failed",
                  style: Constants.TEXT_STYLE_DIALOG_TITLE_AND_ACTION_1,
                ),
                content: Text(
                  "You are not allowed to access the room prior to the booking period.",
                  style: Constants.TEXT_STYLE_DIALOG_CONTENT,
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "OK",
                      style: Constants
                          .TEXT_STYLE_DIALOG_TITLE_AND_ACTION_1,
                    ),
                  ),
                ],
              ),
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (context) =>
          AlertDialog(
            title: Text(
              "Invalid Room ID",
              style: Constants.TEXT_STYLE_DIALOG_TITLE_AND_ACTION_1,
            ),
            content: Text(
              "This is not your reserved room.",
              style: Constants.TEXT_STYLE_DIALOG_CONTENT,
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "OK",
                  style: Constants
                      .TEXT_STYLE_DIALOG_TITLE_AND_ACTION_1,
                ),
              ),
            ],
          ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _roomDataFetcher = new RoomDataFetcher();
    _dateFormatter = new DateFormat.jm();
    _fetchBookingDetails().then((List<BookingDetails> list) => {
      setState(() {
        _bookingDetailsList = list;
        _loadState = LoadState.Done;
      })
    });
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
        leading: GestureDetector(
          onTap: () => _back(context),
          child: Icon(
            Icons.arrow_back_outlined,
            color: Constants.COLOR_BLACK,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(screenWidth * 0.05, screenHeight * 0.02, screenWidth * 0.05, 0.0),
        height: screenHeight,
        child: Stack(
          children: [
            Container(
              height: screenHeight * 0.63,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                physics: BouncingScrollPhysics(),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // page title
                      Container(
                        child: Text(
                          'My Upcoming Booking',
                          style: Constants.TEXT_STYLE_HEADING_1,
                        ),
                      ),

                      // page instructions
                      Container(
                        padding: EdgeInsets.only(top: screenHeight * 0.015),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'At the end of the booking period, kindly press ',
                                style: Constants.TEXT_STYLE_SUB_HEADING_1,
                              ),
                              TextSpan(
                                text: 'Checkout',
                                style: Constants.TEXT_STYLE_SUB_HEADING_BOLD_1,
                              ),
                              TextSpan(
                                text: ' after you have left the room.' +
                                    ' Thank you for your cooperation.',
                                style: Constants.TEXT_STYLE_SUB_HEADING_1,
                              ),
                            ]
                          ),
                        ),
                      ),

                      // room number
                      Container(
                        padding: EdgeInsets.only(top: screenHeight * 0.03),
                        child: Text(
                          'Room Number',
                          style: Constants.TEXT_STYLE_HEADING_2,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: screenHeight * 0.005),
                        child:  Container(
                          child: _loadState == LoadState.Loading ? Shimmer.fromColors(
                            baseColor: Constants.COLOR_SILVER_LIGHTER,
                            highlightColor: Constants.COLOR_WHITE,
                            child: Container(
                              color: Constants.COLOR_SILVER_LIGHTER,
                              width: screenWidth - (screenWidth * 0.05) * 2,
                              height: screenHeight * 0.035,
                            )
                          ) :
                          Text(
                            _bookingDetailsList.length == 0 ? '-' : _bookingDetailsList[0].roomName,
                            style: Constants.TEXT_STYLE_DETAILS_PASSAGE_CONTENT_1,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.009),
                        child: Divider(
                          color: Constants.COLOR_GRAY_LIGHT,
                        ),
                      ),

                      // time
                      Container(
                        child: Text(
                          'Time',
                          style: Constants.TEXT_STYLE_HEADING_2,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: screenHeight * 0.005),
                          child:  Container(
                            child: _loadState == LoadState.Loading ? Shimmer.fromColors(
                              baseColor: Constants.COLOR_SILVER_LIGHTER,
                              highlightColor: Constants.COLOR_WHITE,
                              child: Container(
                                color: Constants.COLOR_SILVER_LIGHTER,
                                width: screenWidth - (screenWidth * 0.05) * 2,
                                height: screenHeight * 0.035,
                              )
                            ) :
                            Text(
                              // '02:00 PM - 04:00 PM',
                                _bookingDetailsList.length == 0 ? '-' : _dateFormatter.format(DateTime.fromMillisecondsSinceEpoch(int.parse(_bookingDetailsList[0].startingTime + '000'))).padLeft(8, '0') + " - " +
                                  _dateFormatter.format(DateTime.fromMillisecondsSinceEpoch(int.parse(_bookingDetailsList[0].startingTime + '000') + _bookingDetailsList[0].duration * 3600000)).padLeft(8, '0'),
                              style: Constants.TEXT_STYLE_DETAILS_PASSAGE_CONTENT_1,
                            ),
                          )
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.009),
                        child: Divider(
                          color: Constants.COLOR_GRAY_LIGHT,
                        ),
                      ),

                      // number of person
                      Container(
                        child: Text(
                          'Number of Person',
                          style: Constants.TEXT_STYLE_HEADING_2,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: screenHeight * 0.005),
                        child:  Container(
                          child: _loadState == LoadState.Loading ? Shimmer.fromColors(
                            baseColor: Constants.COLOR_SILVER_LIGHTER,
                            highlightColor: Constants.COLOR_WHITE,
                            child: Container(
                              color: Constants.COLOR_SILVER_LIGHTER,
                              width: screenWidth - (screenWidth * 0.05) * 2,
                              height: screenHeight * 0.035,
                            )
                          ) :
                          Text(
                            _bookingDetailsList.length == 0 ? '-' : _bookingDetailsList[0].numOfPerson.toString() + ' Person',
                            style: Constants.TEXT_STYLE_DETAILS_PASSAGE_CONTENT_1,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.009),
                        child: Divider(
                          color: Constants.COLOR_GRAY_LIGHT,
                        ),
                      ),

                      // description
                      Container(
                        child: Text(
                          'Description',
                          style: Constants.TEXT_STYLE_HEADING_2,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: screenHeight * 0.005),
                          child: Container(
                            child: _loadState == LoadState.Loading ? Shimmer.fromColors(
                              baseColor: Constants.COLOR_SILVER_LIGHTER,
                              highlightColor: Constants.COLOR_WHITE,
                              child: Container(
                                color: Constants.COLOR_SILVER_LIGHTER,
                                width: screenWidth - (screenWidth * 0.05) * 2,
                                height: screenHeight * 0.035,
                              )
                            ) :
                            Text(
                              _bookingDetailsList.length == 0 ? '-' :
                              _bookingDetailsList[0].description == ' ' ? '- ' : _bookingDetailsList[0].description,
                              style: Constants.TEXT_STYLE_DETAILS_PASSAGE_CONTENT_1,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),

            Positioned(
              bottom: screenHeight * 0.05,
              child: Container(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: _loadState == LoadState.Loading ? Shimmer.fromColors(
                          baseColor: Constants.COLOR_SILVER_LIGHTER,
                          highlightColor: Constants.COLOR_WHITE,
                          child: Container(
                            color: Constants.COLOR_SILVER_LIGHTER,
                            width: screenWidth - (screenWidth * 0.05) * 2,
                            height: screenHeight * 0.08,
                          )
                      ) : _bookingDetailsList.length != 0 ?
                      Container(
                        child: Material(
                          color: _bookingDetailsList[0].accessed == false ? Constants.COLOR_BLUE_THEME : Constants.COLOR_PLATINUM_LIGHT,
                          borderRadius: BorderRadius.circular(11.0),
                          child: InkWell(
                            onTap: () => _bookingDetailsList[0].accessed == false ? _accessRoom(_bookingDetailsList[0].bookingId, 'true') : print(""),
                            child: Container(
                              width: screenWidth - (screenWidth * 0.05) * 2,
                              padding: EdgeInsets.symmetric(vertical: 20.0),
                              alignment: Alignment.center,
                              child: Text(
                                "Access",
                                style: Constants.TEXT_STYLE_BUTTON_TEXT,
                              ),
                            ),
                          ),
                        ),
                      ) : Container(),
                    ),

                    Container(
                      child: _loadState == LoadState.Loading ? Shimmer.fromColors(
                        baseColor: Constants.COLOR_SILVER_LIGHTER,
                        highlightColor: Constants.COLOR_WHITE,
                        child: Container(
                          margin: EdgeInsets.only(top: screenHeight * 0.02),
                          color: Constants.COLOR_SILVER_LIGHTER,
                          width: screenWidth - (screenWidth * 0.05) * 2,
                          height: screenHeight * 0.08,
                        )
                      ) : _bookingDetailsList.length != 0 ?
                      Container(
                        margin: EdgeInsets.only(top: screenHeight * 0.02),
                        child: Material(
                          color: _bookingDetailsList[0].accessed == false ? Constants.COLOR_PLATINUM_LIGHT : Constants.COLOR_RED,
                          borderRadius: BorderRadius.circular(11.0),
                          child: InkWell(
                            onTap: () => _bookingDetailsList[0].accessed == false ? print("") : _accessRoom(_bookingDetailsList[0].bookingId, 'false'),
                            child: Container(
                              width: screenWidth - (screenWidth * 0.05) * 2,
                              padding: EdgeInsets.symmetric(vertical: 20.0),
                              alignment: Alignment.center,
                              child: Text(
                                "Checkout",
                                style: Constants.TEXT_STYLE_BUTTON_TEXT,
                              ),
                            ),
                          ),
                        ),
                      ) : Container(),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}