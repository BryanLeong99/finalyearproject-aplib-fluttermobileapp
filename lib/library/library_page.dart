import 'package:flutter/material.dart';

import '../constants.dart';

class LibraryPage extends StatefulWidget {
  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {

  _back(BuildContext context) {
    Navigator.pop(context);
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
      body: SizedBox.expand(
        child: Container(
          padding: EdgeInsets.fromLTRB(screenWidth * 0.05, screenHeight * 0.02, screenWidth * 0.05, 0.0),
          child: Column(
            children: [
              // page title
              Container(
                width: screenWidth,
                child: Text(
                  'Libraries',
                  style: Constants.TEXT_STYLE_HEADING_1,
                ),
              ),

              // APU Library
              Container(
                // height: screenHeight * 0.098,
                margin: EdgeInsets.only(top: screenHeight * 0.02),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.0),
                  color: Constants.COLOR_MAGNOLIA,
                  boxShadow: [
                    BoxShadow(
                      color: Constants.COLOR_GRAY_BOX_SHADOW,
                      offset: Offset(0.0, 5.0),
                      blurRadius: 4.0,
                      spreadRadius: 1.0,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // left icon
                    Container(
                      height: screenHeight * 0.235,
                      width: screenWidth * 0.12,
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.025),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(6.0), bottomLeft: Radius.circular(6.0)),
                        color: Constants.COLOR_BLUE_THEME,
                      ),
                      child: Icon(
                        Icons.location_on_rounded,
                        color: Constants.COLOR_WHITE,
                      ),
                    ),

                    // library details
                    Container(
                      padding: EdgeInsets.only(left: screenWidth * 0.04),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // library name
                          Container(
                            child: Text(
                              'APU Library @ New Campus',
                              style: Constants.TEXT_STYLE_CARD_TITLE_1,
                            ),
                          ),
                          // operation hour line 1
                          Container(
                            padding: EdgeInsets.only(top: screenHeight * 0.008),
                            child: Text(
                              'Mondays - Fridays: 08:30 AM - 08:00 PM',
                              style: Constants.TEXT_STYLE_CARD_SUB_TITLE_4,
                            ),
                          ),
                          // operation hour line 2
                          Container(
                            padding: EdgeInsets.only(top: screenHeight * 0.0035),
                            child: Text(
                              'Saturdays: 09:00 AM - 01:00 PM',
                              style: Constants.TEXT_STYLE_CARD_SUB_TITLE_4,
                            ),
                          ),
                          // operation hour line 3
                          Container(
                            padding: EdgeInsets.only(top: screenHeight * 0.0035),
                            child: Text(
                              'Closed on Sundays and Public Holidays',
                              style: Constants.TEXT_STYLE_CARD_SUB_TITLE_4,
                            ),
                          ),
                          // contact number line 1
                          Container(
                            padding: EdgeInsets.only(top: screenHeight * 0.007),
                            child: Text(
                              '+603 8992 5207 (Library Counter)',
                              style: Constants.TEXT_STYLE_CARD_SUB_TITLE_4,
                            ),
                          ),
                          // contact number line 2
                          Container(
                            padding: EdgeInsets.only(top: screenHeight * 0.0035),
                            child: Text(
                              '+603 8992 5209 (Reference Desk)',
                              style: Constants.TEXT_STYLE_CARD_SUB_TITLE_4,
                            ),
                          ),
                          // address
                          Container(
                            padding: EdgeInsets.only(top: screenHeight * 0.007),
                            width: screenWidth - ((screenWidth * 0.05) * 2) - (screenWidth * 0.2),
                            child: Text(
                              'Jalan Teknologi 5, Taman Teknologi Malaysia, 57000'
                                  ' Kuala Lumpur, Wilayah Persekutuan Kuala Lumpur',
                              style: Constants.TEXT_STYLE_CARD_ADDRESS_DATE_2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // APIIT Library
              Container(
                // height: screenHeight * 0.098,
                margin: EdgeInsets.only(top: screenHeight * 0.02),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.0),
                  color: Constants.COLOR_MAGNOLIA,
                  boxShadow: [
                    BoxShadow(
                      color: Constants.COLOR_GRAY_BOX_SHADOW,
                      offset: Offset(0.0, 5.0),
                      blurRadius: 4.0,
                      spreadRadius: 1.0,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // left icon
                    Container(
                      height: screenHeight * 0.235,
                      width: screenWidth * 0.12,
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.025),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(6.0), bottomLeft: Radius.circular(6.0)),
                        color: Constants.COLOR_BLUE_THEME,
                      ),
                      child: Icon(
                        Icons.location_on_rounded,
                        color: Constants.COLOR_WHITE,
                      ),
                    ),

                    // library details
                    Container(
                      padding: EdgeInsets.only(left: screenWidth * 0.04),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // library name
                          Container(
                            child: Text(
                              'APIIT Library @ TPM',
                              style: Constants.TEXT_STYLE_CARD_TITLE_1,
                            ),
                          ),
                          // operation hour line 1
                          Container(
                            padding: EdgeInsets.only(top: screenHeight * 0.008),
                            child: Text(
                              'Mondays - Fridays: 08:30 AM - 06:00 PM',
                              style: Constants.TEXT_STYLE_CARD_SUB_TITLE_4,
                            ),
                          ),
                          // operation hour line 2
                          Container(
                            padding: EdgeInsets.only(top: screenHeight * 0.0035),
                            child: Text(
                              'Closed on Sundays and Public Holidays',
                              style: Constants.TEXT_STYLE_CARD_SUB_TITLE_4,
                            ),
                          ),
                          // contact number line 1
                          Container(
                            padding: EdgeInsets.only(top: screenHeight * 0.007),
                            child: Text(
                              '+603 8992 5155 (Library Counter)',
                              style: Constants.TEXT_STYLE_CARD_SUB_TITLE_4,
                            ),
                          ),
                          // address
                          Container(
                            padding: EdgeInsets.only(top: screenHeight * 0.007),
                            width: screenWidth - ((screenWidth * 0.05) * 2) - (screenWidth * 0.2),
                            child: Text(
                              'Technology Park Malaysia, 43300 Kuala Lumpur, '
                                  'Federal Territory of Kuala Lumpur',
                              style: Constants.TEXT_STYLE_CARD_ADDRESS_DATE_2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}