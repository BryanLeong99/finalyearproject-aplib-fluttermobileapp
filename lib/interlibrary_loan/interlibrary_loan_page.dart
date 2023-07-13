import 'package:ap_lib/authenticate/authentication_handler.dart';
import 'package:ap_lib/enum/enum_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'new_ill_request_page.dart';
import 'ill_request_list_model.dart';
import 'ill_data_provider.dart';
import 'ill_request_list_component.dart';
import '../constants.dart';

class InterlibraryLoanPage extends StatefulWidget {
  @override
  _InterlibraryLoanPageState createState() => _InterlibraryLoanPageState();
}

class _InterlibraryLoanPageState extends State<InterlibraryLoanPage> {
  IllDataProvider _illDataProvider;
  AuthenticationHandler _authenticationHandler;
  LoadState _loadState = LoadState.Loading;

  List<IllRequestListModel> _illRequestList = [];

  Future<List<IllRequestListModel>> _fetchIllRequest() async {
    String userToken = await _authenticationHandler.getToken();
    return await _illDataProvider.getAllRequest(userToken);
  }

  _navigateToNewILLRequestPage() {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => NewIllRequestPage())
    );
  }

  _back(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    _illDataProvider = new IllDataProvider();
    _authenticationHandler = new AuthenticationHandler();
    _fetchIllRequest().then((list) => {
      setState(() {
        _loadState = LoadState.Done;
        _illRequestList = list;
      })
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: SpeedDial(
        icon: Icons.add_rounded,
        activeIcon: Icons.close_rounded,
        curve: Curves.bounceIn,
        overlayColor: Constants.COLOR_WHITE,
        backgroundColor: Constants.COLOR_BLUE_THEME,
        foregroundColor: Constants.COLOR_WHITE,
        children: [
          SpeedDialChild(
            backgroundColor: Constants.COLOR_BLACK,
            label: "Create New Request",
            labelStyle: Constants.TEXT_STYLE_FLOATING_BUTTON_LIST_TEXT,
            labelBackgroundColor: Constants.COLOR_BLACK,
            onTap: () => _navigateToNewILLRequestPage(),
            child: Icon(
              Icons.playlist_add_rounded,
              color: Constants.COLOR_WHITE,
            ),
          ),
        ],
      ),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // page title
              Container(
                child: Text(
                  'Interlibrary Loan (ILL)',
                  style: Constants.TEXT_STYLE_HEADING_1,
                ),
              ),

              // page instructions
              Container(
                padding: EdgeInsets.only(top: screenHeight * 0.015),
                child: Text(
                  'Academic staff and Post-graduate students may request for Interlibrary Loan ' +
                      'service for books that are not available in APU library and e-databases. ' +
                      'These items are sourced from other local university libraries. ',
                  style: Constants.TEXT_STYLE_SUB_HEADING_1,
                ),
              ),

              // requests section title
              Container(
                padding: EdgeInsets.only(top: screenHeight * 0.03, bottom: screenHeight * 0.02),
                child: Text(
                  'Requests',
                  style: Constants.TEXT_STYLE_HEADING_2,
                ),
              ),

              IllRequestListComponent(
                illRequestList: _illRequestList,
                loadState: _loadState,
              ),
            ],
          ),
        ),
      ),
    );
  }

}