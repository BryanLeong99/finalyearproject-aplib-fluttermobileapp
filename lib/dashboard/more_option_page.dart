import 'package:ap_lib/authenticate/authentication_handler.dart';
import 'package:ap_lib/authenticate/login_page.dart';
import 'package:ap_lib/constants.dart';
import 'package:ap_lib/setting/setting_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ap_lib/interlibrary_loan/interlibrary_loan_page.dart';
import 'package:ap_lib/about/about_page.dart';
import 'package:ap_lib/library/library_page.dart';
import 'package:ap_lib/reading_history/reading_history_page.dart';
import 'package:ap_lib/fine/fine_paid_history_page.dart';
import 'package:ap_lib/profile/profile_page.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class MoreOptionPage extends StatefulWidget {
  @override
  _MoreOptionPageState createState() => _MoreOptionPageState();
}

class _MoreOptionPageState extends State<MoreOptionPage> {
  String _userRole = "";
  bool _illEligibility = false;
  AuthenticationHandler _authenticationHandler;

  void _navigateToInterlibraryLoanPage() {
    Navigator.push(
      context,
      CupertinoPageRoute(
        settings: RouteSettings(name: 'IllPage1'),
        builder: (context) => InterlibraryLoanPage()
      )
    );
  }

  void _navigateToAboutPage() {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => AboutPage()),
    );
  }

  void _navigateToLibraryPage() {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => LibraryPage()),
    );
  }

  void _navigateToReadingHistoryPage() {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => ReadingHistoryPage()),
    );
  }

  void _navigateToFinePaidHistoryPage() {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => FinePaidHistoryPage()),
    );
  }

  void _navigateToProfilePage() {
    Navigator.push(
      context,
      CupertinoPageRoute(
        settings: RouteSettings(name: 'ProfilePage1'),
        builder: (context) => ProfilePage(),
      ),
    );
  }

  void _navigateToSettingPage() {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => SettingPage()),
    );
  }

  void _signOut() async {
    EasyLoading.show(
      status: 'Signing Out...',
      maskType: EasyLoadingMaskType.black,
    );

    _authenticationHandler.signOut().then((authenticate) => {
      if (authenticate.authenticationStatus == 'success') {
        _authenticationHandler.clearToken(),
        EasyLoading.dismiss(),
        Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(builder: (context) => LoginPage()),
          ModalRoute.withName('/'),
        ),
      }
    });
  }

  bool _checkIllEligibility(String userRole) {
    if (userRole == "Certificate, Foundation, Diploma and Degree"
    || userRole == "Administrative Staff"
    || userRole == "English Language Courses") {
      return false;
    }
    return true;
  }

  @override
  void initState() {
    super.initState();

    _authenticationHandler = new AuthenticationHandler();

    _authenticationHandler.getRole().then((role) => {
      setState(() {
        _userRole = role;
        _illEligibility = _checkIllEligibility(_userRole);
      }),
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        padding: EdgeInsets.fromLTRB(screenWidth * 0.035, screenHeight * 0.02, screenWidth * 0.035, 0.0),
        child: Wrap(
        // child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // page title
            Container(
              width: screenWidth,
              child: Text(
                'More',
                style: Constants.TEXT_STYLE_HEADING_1,
              ),
            ),

            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              physics: BouncingScrollPhysics(),
              child: Container(
                child: Column(
                  children: [
                    // 1st - interlibrary loan
                    _illEligibility ? GestureDetector(
                      onTap: () => _navigateToInterlibraryLoanPage(),
                      child: Container(
                        padding: EdgeInsets.only(top: screenHeight * 0.02),
                        child: Row(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              width: screenWidth * 0.12,
                              child: Icon(
                                Icons.local_library_rounded,
                                size: 27,
                                color: Constants.COLOR_MAXIMUM_YELLOW_RED,
                              ),
                            ),

                            Container(
                              width: screenWidth * 0.65,
                              child: Text(
                                'Interlibrary Loan (ILL)',
                                style: Constants.TEXT_STYLE_MORE_OPTIONS_TEXT,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),

                            Expanded(
                              child: Container(
                                alignment: Alignment.centerRight,
                                child: Icon(
                                  Icons.chevron_right_rounded,
                                  size: 27.0,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ) : Container(),

                    // 2nd - profile
                    GestureDetector(
                      onTap: () => _navigateToProfilePage(),
                      child: Container(
                        padding: EdgeInsets.only(top: screenHeight * 0.04),
                        child: Row(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              width: screenWidth * 0.12,
                              child: Icon(
                                Icons.person_rounded,
                                size: 27,
                                color: Constants.COLOR_TURQUOISE,
                              ),
                            ),

                            Container(
                              width: screenWidth * 0.65,
                              child: Text(
                                'Profile',
                                style: Constants.TEXT_STYLE_MORE_OPTIONS_TEXT,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),

                            Expanded(
                              child: Container(
                                alignment: Alignment.centerRight,
                                child: Icon(
                                  Icons.chevron_right_rounded,
                                  size: 27.0,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),

                    // 3rd - loaning history
                    GestureDetector(
                      onTap: () => _navigateToReadingHistoryPage(),
                      child: Container(
                        padding: EdgeInsets.only(top: screenHeight * 0.04),
                        child: Row(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              width: screenWidth * 0.12,
                              child: Icon(
                                Icons.history_rounded,
                                size: 27,
                                color: Constants.COLOR_FLAME,
                              ),
                            ),

                            Container(
                              width: screenWidth * 0.65,
                              child: Text(
                                'Reading History',
                                style: Constants.TEXT_STYLE_MORE_OPTIONS_TEXT,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),

                            Expanded(
                              child: Container(
                                alignment: Alignment.centerRight,
                                child: Icon(
                                  Icons.chevron_right_rounded,
                                  size: 27.0,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),

                    // 4th - fine
                    GestureDetector(
                      onTap: () => _navigateToFinePaidHistoryPage(),
                      child: Container(
                        padding: EdgeInsets.only(top: screenHeight * 0.04),
                        child: Row(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              width: screenWidth * 0.12,
                              child: Icon(
                                Icons.request_quote_rounded,
                                size: 27,
                                color: Constants.COLOR_MEDIUM_BLUE,
                              ),
                            ),

                            Container(
                              width: screenWidth * 0.65,
                              child: Text(
                                'Fine',
                                style: Constants.TEXT_STYLE_MORE_OPTIONS_TEXT,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),

                            Expanded(
                              child: Container(
                                alignment: Alignment.centerRight,
                                child: Icon(
                                  Icons.chevron_right_rounded,
                                  size: 27.0,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),

                    // 5th - libraries
                    GestureDetector(
                      onTap: () => _navigateToLibraryPage(),
                      child: Container(
                        padding: EdgeInsets.only(top: screenHeight * 0.04),
                        child: Row(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              width: screenWidth * 0.12,
                              child: Icon(
                                Icons.business_rounded,
                                size: 27,
                                color: Constants.COLOR_BLACK_CORAL,
                              ),
                            ),

                            Container(
                              width: screenWidth * 0.65,
                              child: Text(
                                'Libraries',
                                style: Constants.TEXT_STYLE_MORE_OPTIONS_TEXT,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),

                            Expanded(
                              child: Container(
                                alignment: Alignment.centerRight,
                                child: Icon(
                                  Icons.chevron_right_rounded,
                                  size: 27.0,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),

                    // 6th - settings
                    GestureDetector(
                      onTap: () => _navigateToSettingPage(),
                      child: Container(
                        padding: EdgeInsets.only(top: screenHeight * 0.04),
                        child: Row(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              width: screenWidth * 0.12,
                              child: Icon(
                                Icons.settings_rounded,
                                size: 27,
                                color: Constants.COLOR_MEDIUM_SLATE_BLUE,
                              ),
                            ),

                            Container(
                              width: screenWidth * 0.65,
                              child: Text(
                                'Settings',
                                style: Constants.TEXT_STYLE_MORE_OPTIONS_TEXT,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),

                            Expanded(
                              child: Container(
                                alignment: Alignment.centerRight,
                                child: Icon(
                                  Icons.chevron_right_rounded,
                                  size: 27.0,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),

                    // 7th - about
                    GestureDetector(
                      onTap: () => _navigateToAboutPage(),
                      child: Container(
                        padding: EdgeInsets.only(top: screenHeight * 0.04),
                        child: Row(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              width: screenWidth * 0.12,
                              child: Icon(
                                Icons.info_rounded,
                                size: 27,
                                color: Constants.COLOR_BLUE_SECONDARY,
                              ),
                            ),

                            Container(
                              width: screenWidth * 0.65,
                              child: Text(
                                'About',
                                style: Constants.TEXT_STYLE_MORE_OPTIONS_TEXT,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),

                            Expanded(
                              child: Container(
                                alignment: Alignment.centerRight,
                                child: Icon(
                                  Icons.chevron_right_rounded,
                                  size: 27.0,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),

                    // 8th - sign out
                    GestureDetector(
                      onTap: () => _signOut(),
                      child: Container(
                        padding: EdgeInsets.only(top: screenHeight * 0.04),
                        child: Row(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              width: screenWidth * 0.12,
                              child: Icon(
                                Icons.logout,
                                size: 27,
                                color: Constants.COLOR_RED,
                              ),
                            ),

                            Container(
                              width: screenWidth * 0.65,
                              child: Text(
                                'Sign Out',
                                style: Constants.TEXT_STYLE_MORE_OPTIONS_RED_TEXT,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),

                            Expanded(
                              child: Container(
                                alignment: Alignment.centerRight,
                                child: Icon(
                                  Icons.chevron_right_rounded,
                                  size: 27.0,
                                  color: Constants.COLOR_RED,
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
            )
          ],
        ),
      ),
    );
  }

}