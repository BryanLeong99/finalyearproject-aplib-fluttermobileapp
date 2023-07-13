import 'package:ap_lib/dashboard/dashboard_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flare_flutter/flare_actor.dart';

import '../constants.dart';

class CompleteLoanPage extends StatefulWidget {
  final String title;
  final DateTime loanDateTime;
  final DateTime dueDateTime;

  CompleteLoanPage({
    @required this.title,
    @required this.loanDateTime,
    @required this.dueDateTime,
  });

  @override
  _CompleteLoanPageState createState() => _CompleteLoanPageState();
}

class _CompleteLoanPageState extends State<CompleteLoanPage> {
  DateFormat _dateTimeFormatter;

  void _navigateBackToDashboard() {
    Navigator.pushAndRemoveUntil(
      context,
      CupertinoPageRoute(builder: (context) => DashboardPage()),
      ModalRoute.withName('/'),
    );
  }

  @override
  void initState() {
    super.initState();

    _dateTimeFormatter = new DateFormat('dd MMM yyyy,').add_jms();
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
                crossAxisAlignment: CrossAxisAlignment.center,
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
                      'Loan Success!',
                      style: Constants.TEXT_STYLE_HEADING_1,
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.only(top: screenHeight * 0.04),
                    child: Text(
                      'Title: ' + widget.title,
                      style: Constants.TEXT_STYLE_HEADING_4,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.only(top: screenHeight * 0.025),
                    child: Container(
                      child: Text(
                        _dateTimeFormatter.format(widget.loanDateTime),
                        style: Constants.TEXT_STYLE_HEADING_2,
                      ),
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.only(top: screenHeight * 0.015),
                    child: Container(
                      child: Text(
                        'to',
                        style: Constants.TEXT_STYLE_CARD_SUB_TITLE_5,
                      ),
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.only(top: screenHeight * 0.015),
                    child: Container(
                      child: Text(
                        _dateTimeFormatter.format(widget.dueDateTime),
                        style: Constants.TEXT_STYLE_HEADING_2,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Positioned(
              bottom: screenHeight * 0.05,
              child: Container(
                alignment: Alignment.center,
                child: Container(
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}