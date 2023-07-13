import 'package:ap_lib/dashboard/dashboard_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import '../constants.dart';
import 'my_booking_page.dart';

class CompleteBookingPage extends StatefulWidget {
  final String room;
  final String startingTime;
  final String duration;
  final String roomId;
  final String bookingId;

  CompleteBookingPage({
    this.room,
    this.startingTime,
    this.duration,
    this.roomId,
    this.bookingId,
  });

  @override
  _CompleteBookingPageState createState() => _CompleteBookingPageState();
}

class _CompleteBookingPageState extends State<CompleteBookingPage> {
  DateFormat _dateFormatter;

  @override
  void initState() {
    super.initState();
    _dateFormatter = new DateFormat.jm();
  }

  void _navigateBackToDashboard() {
    Navigator.pushAndRemoveUntil(
      context,
      CupertinoPageRoute(builder: (context) => DashboardPage(pageIndex: 1,)),
      ModalRoute.withName('/')
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        padding: EdgeInsets.fromLTRB(screenWidth * 0.07, screenHeight * 0.02, screenWidth * 0.07, 0.0),
        height: screenHeight,
        child: Stack(
          children: [
            Container(
              child: Column(
                children: [
                  Container(
                    height: screenHeight * 0.4,
                    child: FlareActor(
                      'assets/complete.flr',
                      animation: 'Done',
                      fit: BoxFit.cover,
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.only(top: screenHeight * 0.01),
                    child: Text(
                      'Booking Success!',
                      style: Constants.TEXT_STYLE_HEADING_1,
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.only(top: screenHeight * 0.04),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Text(
                            'Room Number: ',
                            style: Constants.TEXT_STYLE_HEADING_2,
                          ),
                        ),

                        Container(
                          child: Text(
                            int.parse(widget.room.substring(2, 5)).toString(),
                            style: Constants.TEXT_STYLE_HEADING_2,
                          ),
                        )
                      ],
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.only(top: screenHeight * 0.01),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          child: Text(
                            _dateFormatter.format(DateTime.fromMillisecondsSinceEpoch(int.parse(widget.startingTime + '000'))).padLeft(8, '0'),
                            style: Constants.TEXT_STYLE_SUB_HEADING_2,
                          ),
                        ),
                        Container(
                          child: Text(
                            ' - ' + _dateFormatter.format(
                                DateTime.fromMillisecondsSinceEpoch(
                                  int.parse(widget.startingTime + '000') +
                                    int.parse(widget.duration) * 3600000
                                )
                            ).padLeft(8, '0'),
                            style: Constants.TEXT_STYLE_SUB_HEADING_2,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),

            Positioned(
              bottom: screenHeight * 0.05,
              child: Container(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Container(
                    //   child: Material(
                    //     color: Constants.COLOR_BLUE_THEME,
                    //     borderRadius: BorderRadius.circular(11.0),
                    //     child: InkWell(
                    //       onTap: () => _accessRoom(),
                    //       child: Container(
                    //         width: screenWidth - (screenWidth * 0.07) * 2,
                    //         padding: EdgeInsets.symmetric(vertical: 16.0),
                    //         alignment: Alignment.center,
                    //         child: Text(
                    //           "Unlock The Room Now",
                    //           style: Constants.TEXT_STYLE_BUTTON_TEXT,
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // ),

                    Container(
                      margin: EdgeInsets.only(top: screenHeight * 0.02),
                      child: Material(
                        color: Constants.COLOR_BLUE_SECONDARY,
                        borderRadius: BorderRadius.circular(11.0),
                        child: InkWell(
                          onTap: () => _navigateBackToDashboard(),
                          child: Container(
                            width: screenWidth - (screenWidth * 0.07) * 2,
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            alignment: Alignment.center,
                            child: Text(
                              "Done",
                              style: Constants.TEXT_STYLE_BUTTON_TEXT,
                            ),
                          ),
                        ),
                      ),
                    )
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