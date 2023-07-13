import 'package:ap_lib/authenticate/authentication_handler.dart';
import 'package:ap_lib/authenticate/otp_handler.dart';
import 'package:ap_lib/user/user_data_fetcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_state_button/progress_button.dart';
import 'complete_update_page.dart';

import '../constants.dart';

class VerificationCodeUpdateProfilePage extends StatefulWidget {
  final String userToken;
  final String name;
  final String email;
  final String phoneNumber;
  final String schoolDepartmentId;
  final String password;
  final String verificationCode;

  VerificationCodeUpdateProfilePage({
    @required this.userToken,
    @required this.name,
    @required this.email,
    @required this.phoneNumber,
    @required this.schoolDepartmentId,
    @required this.password,
    @required this.verificationCode,
  });

  @override
  _VerificationCodeUpdateProfilePageState createState() => _VerificationCodeUpdateProfilePageState();
}

class _VerificationCodeUpdateProfilePageState extends State<VerificationCodeUpdateProfilePage> {
  List<String> _verificationCode = [];

  ButtonState _verifyState = ButtonState.idle;

  void _verifyButtonHandler() async {
    UserDataFetcher _userDataFetcher = new UserDataFetcher();
    AuthenticationHandler _authenticationHandler = new AuthenticationHandler();
    switch (_verifyState) {
      case ButtonState.idle:
        setState(() {
          _verifyState = ButtonState.loading;
        });
        // new OtpHandler().verifyNumber('+' + widget.phoneNumber, convertVerificationCodeToString());
        if (widget.verificationCode == convertVerificationCodeToString()) {
          _userDataFetcher.updateUserDetails(widget.userToken, widget.name, widget.email,
              widget.phoneNumber, widget.schoolDepartmentId).then((status) {
            if (status == 'success' && widget.password != '########') {
              _authenticationHandler.updatePassword(widget.password, widget.userToken, 'token').then((updatePasswordStatus) => {
                if (updatePasswordStatus == "success") {
                  setState(() {
                    _verifyState = ButtonState.success;
                  }),
                  Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (context) => CompleteUpdatePage()),
                  ),
                } else {
                  setState(() {
                    _verifyState = ButtonState.fail;
                  }),
                }
              });
            } else if (status == 'success') {
              Navigator.push(
                context,
                CupertinoPageRoute(builder: (context) => CompleteUpdatePage()),
              );
            }
          });
        } else {
          print("verification failed");
          setState(() {
            _verifyState = ButtonState.fail;
          });
        }
        break;
      case ButtonState.loading:
        break;
      case ButtonState.success:
        _verifyState = ButtonState.idle;
        break;
      case ButtonState.fail:
        _verifyState = ButtonState.idle;
        Future.delayed(Duration(seconds: 1), () {
          setState(() {
            _verifyState = ButtonState.idle;
          });
        });
        break;
    }
  }

  String convertVerificationCodeToString() {
    String _verificationCodeString = "";
    _verificationCode.forEach((element) {
      _verificationCodeString += element;
    });

    return _verificationCodeString;
  }

  void _addNumberValue(String numberValue) {
    setState(() {
      if (_verificationCode.length < 6) {
        _verificationCode.add(numberValue);
      } else {
        _verificationCode[_verificationCode.length - 1] = numberValue;
      }
    });
  }

  void _removeValue() {
    setState(() {
      if (_verificationCode.length != 0)
        _verificationCode.removeAt(_verificationCode.length - 1);
    });
  }

  _back(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: true,
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
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(screenWidth * 0.05, screenHeight * 0.02, screenWidth * 0.05, 0.0),
              child: Column(
                children: [
                  // page title
                  Container(
                    width: screenWidth,
                    child: Text(
                      'Verify Phone Number',
                      style: Constants.TEXT_STYLE_HEADING_1,
                    ),
                  ),

                  // instruction
                  Container(
                    margin: EdgeInsets.only(top: screenHeight * 0.02),
                    width: screenWidth,
                    child: Text(
                      'Please enter the code sent to your phone number',
                      style: Constants.TEXT_STYLE_HEADING_4,
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.symmetric(vertical: screenHeight * 0.018),
                    alignment: AlignmentDirectional.topStart,
                    child: Text(
                      'We sent a verification code to ${widget.phoneNumber}',
                      style: Constants.TEXT_STYLE_SUB_HEADING_1,
                    ),
                  ),

                  // code indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: screenHeight * 0.04, bottom: screenHeight * 0.03),
                        height: screenHeight * 0.06,
                        child: ListView.builder(
                          itemCount: _verificationCode.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) => Container(
                            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                            child: Icon(
                              Icons.circle,
                              size: 15,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: screenHeight * 0.04, bottom: screenHeight * 0.03),
                        height: screenHeight * 0.06,
                        child: ListView.builder(
                          itemCount: 6 - _verificationCode.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) => Container(
                            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
                            child: Icon(
                              Icons.radio_button_off_rounded,
                              size: 15,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // num pad
                  Container(
                    // padding: EdgeInsets.only(top: screenHeight * 0.02),
                    padding: EdgeInsets.fromLTRB(
                      screenWidth * 0.1,
                      screenHeight * 0.02,
                      screenWidth * 0.1,
                      0.0,
                    ),
                    width: screenWidth,
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(bottom: screenHeight * 0.017),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () => _addNumberValue('1'),
                                child: Container(
                                  width: screenWidth * 0.1,
                                  alignment: Alignment.center,
                                  height: screenHeight * 0.05,
                                  child: Text(
                                    '1',
                                    style: Constants.TEXT_STYLE_NUM_PAD,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => _addNumberValue('2'),
                                child: Container(
                                  width: screenWidth * 0.1,
                                  alignment: Alignment.center,
                                  height: screenHeight * 0.05,
                                  child: Text(
                                    '2',
                                    style: Constants.TEXT_STYLE_NUM_PAD,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => _addNumberValue('3'),
                                child: Container(
                                  width: screenWidth * 0.1,
                                  alignment: Alignment.center,
                                  height: screenHeight * 0.05,
                                  child: Text(
                                    '3',
                                    style: Constants.TEXT_STYLE_NUM_PAD,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: screenHeight * 0.017),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () => _addNumberValue('4'),
                                child: Container(
                                  width: screenWidth * 0.1,
                                  alignment: Alignment.center,
                                  height: screenHeight * 0.05,
                                  child: Text(
                                    '4',
                                    style: Constants.TEXT_STYLE_NUM_PAD,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => _addNumberValue('5'),
                                child: Container(
                                  width: screenWidth * 0.1,
                                  alignment: Alignment.center,
                                  height: screenHeight * 0.05,
                                  child: Text(
                                    '5',
                                    style: Constants.TEXT_STYLE_NUM_PAD,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => _addNumberValue('6'),
                                child: Container(
                                  width: screenWidth * 0.1,
                                  alignment: Alignment.center,
                                  height: screenHeight * 0.05,
                                  child: Text(
                                    '6',
                                    style: Constants.TEXT_STYLE_NUM_PAD,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: screenHeight * 0.017),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () => _addNumberValue('7'),
                                child: Container(
                                  width: screenWidth * 0.1,
                                  alignment: Alignment.center,
                                  height: screenHeight * 0.05,
                                  child: Text(
                                    '7',
                                    style: Constants.TEXT_STYLE_NUM_PAD,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => _addNumberValue('8'),
                                child: Container(
                                  width: screenWidth * 0.1,
                                  height: screenHeight * 0.05,
                                  alignment: Alignment.center,
                                  child: Text(
                                    '8',
                                    style: Constants.TEXT_STYLE_NUM_PAD,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => _addNumberValue('9'),
                                child: Container(
                                  width: screenWidth * 0.1,
                                  height: screenHeight * 0.05,
                                  alignment: Alignment.center,
                                  child: Text(
                                    '9',
                                    style: Constants.TEXT_STYLE_NUM_PAD,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: screenHeight * 0.017),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: screenWidth * 0.1,
                                alignment: Alignment.center,
                                child: Text(
                                  '0',
                                  style: Constants.TEXT_STYLE_NUM_PAD_EMPTY,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => _addNumberValue('0'),
                                child: Container(
                                  width: screenWidth * 0.1,
                                  alignment: Alignment.center,
                                  height: screenHeight * 0.05,
                                  child: Text(
                                    '0',
                                    style: Constants.TEXT_STYLE_NUM_PAD,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () => _removeValue(),
                                child: Container(
                                  width: screenWidth * 0.1,
                                  alignment: Alignment.center,
                                  height: screenHeight * 0.05,
                                  child: Icon(
                                    Icons.backspace_rounded,
                                    size: 17,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // verify button
            Positioned(
              bottom: screenHeight * 0.05,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
                  width: screenWidth,
                  child: ProgressButton(
                    onPressed: () => _verifyButtonHandler(),
                    progressIndicatorAligment: MainAxisAlignment.center,
                    progressIndicatorSize: 25.0,
                    state: _verifyState,
                    padding: EdgeInsets.all(8.0),
                    stateWidgets: {
                      ButtonState.idle: Text(
                          "Verify",
                          style: Constants.TEXT_STYLE_BUTTON_TEXT
                      ),
                      ButtonState.loading: Container(),
                      ButtonState.fail: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.cancel_rounded,
                              color: Constants.COLOR_WHITE,
                            ),
                            Container(
                              padding: EdgeInsets.only(left: screenWidth * 0.02),
                              child: Text(
                                  'Fail',
                                  style: Constants.TEXT_STYLE_BUTTON_TEXT
                              ),
                            )
                          ],
                        ),
                      ),
                      ButtonState.success: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.check_circle_rounded,
                              color: Constants.COLOR_WHITE,
                            ),
                            Container(
                              padding: EdgeInsets.only(left: screenWidth * 0.02),
                              child: Text(
                                  'Success',
                                  style: Constants.TEXT_STYLE_BUTTON_TEXT
                              ),
                            )
                          ],
                        ),
                      )
                    },
                    stateColors: {
                      ButtonState.idle: Constants.COLOR_BLUE_THEME,
                      ButtonState.loading: Constants.COLOR_BLUE_THEME,
                      ButtonState.fail: Constants.COLOR_RED,
                      ButtonState.success: Constants.COLOR_GREEN_LIGHT
                    },
                  ),
                ),
            ),
          ],
        ),



      ),
    );
  }

}