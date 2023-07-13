import 'package:ap_lib/interlibrary_loan/interlibrary_loan_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ap_lib/dashboard/dashboard_page.dart';
import 'package:flare_flutter/flare_actor.dart';
import '../constants.dart';

class CompleteIllRequestPage extends StatefulWidget {
  final String bookTitle;
  final String organisation;

  CompleteIllRequestPage({
    @required this.bookTitle,
    @required this.organisation,
  });

  @override
  _CompleteIllRequestPageState createState() => _CompleteIllRequestPageState();
}

class _CompleteIllRequestPageState extends State<CompleteIllRequestPage> {
  void _navigateBackToILLPage() {
    // Navigator.popUntil(
    //   context,
    //   ModalRoute.withName('IllPage1')
    // );
    Navigator.pushAndRemoveUntil(
      context,
      CupertinoPageRoute(builder: (context) => DashboardPage(pageIndex: 4,)),
      ModalRoute.withName('/'),
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
                      'ILL Application Submitted!',
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
                            'Title: ',
                            style: Constants.TEXT_STYLE_HEADING_2,
                          ),
                        ),

                        Container(
                          child: Text(
                            widget.bookTitle,
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
                            'from ' + widget.organisation,
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
                    Container(
                      margin: EdgeInsets.only(top: screenHeight * 0.02),
                      child: Material(
                        color: Constants.COLOR_BLUE_SECONDARY,
                        borderRadius: BorderRadius.circular(11.0),
                        child: InkWell(
                          onTap: () => _navigateBackToILLPage(),
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
            )
          ],
        ),
      ),
    );
  }

}