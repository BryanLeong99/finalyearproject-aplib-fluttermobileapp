import 'package:ap_lib/dashboard/dashboard_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:intl/intl.dart';

import '../constants.dart';

class CompleteUpdatePage extends StatefulWidget {
  final String room;
  final String startingTime;
  final String duration;

  CompleteUpdatePage({
    this.room,
    this.startingTime,
    this.duration
  });

  @override
  _CompleteUpdatePageState createState() => _CompleteUpdatePageState();
}

class _CompleteUpdatePageState extends State<CompleteUpdatePage> {
  DateFormat _dateFormatter;

  @override
  void initState() {
    super.initState();
    _dateFormatter = new DateFormat.jm();
  }

  void _navigateBackToProfilePage() {
    Navigator.popUntil(
        context,
        ModalRoute.withName('ProfilePage1'),
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
              child: Wrap(
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
                    width: screenWidth,
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(top: screenHeight * 0.01),
                    child: Text(
                      'Profile Updated!',
                      style: Constants.TEXT_STYLE_HEADING_1,
                    ),
                  ),

                  // Container(
                  //   padding: EdgeInsets.only(top: screenHeight * 0.04),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       Container(
                  //         child: Text(
                  //           'Room Number: ',
                  //           style: Constants.TEXT_STYLE_HEADING_2,
                  //         ),
                  //       ),
                  //
                  //       Container(
                  //         child: Text(
                  //           'ds',
                  //           style: Constants.TEXT_STYLE_HEADING_2,
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // ),

                  // Container(
                  //   padding: EdgeInsets.only(top: screenHeight * 0.01),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       Container(
                  //         child: Text(
                  //           ' - ' ,
                  //           style: Constants.TEXT_STYLE_SUB_HEADING_2,
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
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
                    Container(
                      margin: EdgeInsets.only(top: screenHeight * 0.02),
                      child: Material(
                        color: Constants.COLOR_BLUE_SECONDARY,
                        borderRadius: BorderRadius.circular(11.0),
                        child: InkWell(
                          onTap: () => _navigateBackToProfilePage(),
                          child: Container(
                            width: screenWidth - (screenWidth * 0.07) * 2,
                            padding: EdgeInsets.symmetric(vertical: 20.0),
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
            ),
          ],

        ),
      ),
    );
  }

}