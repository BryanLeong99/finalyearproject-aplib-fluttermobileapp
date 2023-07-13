import 'package:email_auth/email_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:progress_state_button/progress_button.dart';

import '../constants.dart';
import 'login_page.dart';
import 'new_password_forgot_password_page.dart';

class VerificationCodeForgotPasswordPage extends StatefulWidget {
  final String verificationCode;
  final String contactDetails;
  final String method;

  VerificationCodeForgotPasswordPage({
    @required this.verificationCode,
    @required this.contactDetails,
    @required this.method
  });

  @override
  _VerificationCodeForgotPasswordPageState createState() => _VerificationCodeForgotPasswordPageState();
}

class _VerificationCodeForgotPasswordPageState extends State<VerificationCodeForgotPasswordPage> {
  List<String> _verificationCode = [];
  ButtonState _verificationState = ButtonState.idle;

  _back(BuildContext context) {
    Navigator.pop(context);
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

  String convertVerificationCodeToString() {
    String _verificationCodeString = "";
    _verificationCode.forEach((element) {
      _verificationCodeString += element;
    });

    return _verificationCodeString;
  }

  void _verifyButtonHandler() async {

    switch (_verificationState) {
      case ButtonState.idle:
        setState(() {
          _verificationState = ButtonState.loading;
        });
        if (widget.method == "phone") {
          if (widget.verificationCode == convertVerificationCodeToString()) {
            setState(() {
              _verificationState = ButtonState.success;
            });
            Navigator.push(
              context,
              CupertinoPageRoute(builder: (context) =>
                  NewPasswordForgotPasswordPage(
                      contactDetails: widget.contactDetails,
                      method: widget.method
                  )),
            );
          } else {
            setState(() {
              _verificationState = ButtonState.fail;
            });
          }
        } else {
          if (EmailAuth.validate(receiverMail: widget.contactDetails, userOTP: convertVerificationCodeToString())) {
            setState(() {
              _verificationState = ButtonState.success;
            });
            Navigator.push(
              context,
              CupertinoPageRoute(builder: (context) =>
                  NewPasswordForgotPasswordPage(
                      contactDetails: widget.contactDetails,
                      method: widget.method
                  )),
            );
          } else {
            setState(() {
              _verificationState = ButtonState.fail;
            });
          }
        }
        break;
      case ButtonState.loading:
        break;
      case ButtonState.success:
        _verificationState = ButtonState.idle;
        break;
      case ButtonState.fail:
        _verificationState = ButtonState.idle;
        Future.delayed(Duration(seconds: 1), () {
          setState(() {
            _verificationState = ButtonState.idle;
          });
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () => _back(context),
          child: Icon(
            Icons.arrow_back_outlined
          ),
        ),
      ),
      body: Container(
        height: screenHeight,
        child: Stack(
          alignment: AlignmentDirectional.topCenter,
          children: [
            FlareActor(
                'assets/forgot_password_page.flr',
                animation: "ForgotPasswordPage",
                fit: BoxFit.cover
            ),
            Positioned(
              top: screenHeight * 0.32,
              child: DelayedDisplay(
                delay: Duration(milliseconds: 1000),
                fadingDuration: Duration(milliseconds: 300),
                slidingCurve: Curves.easeInOut,
                child: Container(
                  child: Column(
                    children: [
                      Container(
                        height: screenHeight * 0.53,
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
                        width: screenWidth,
                        child: Column(
                          children: [
                            // main title
                            Container(
                              alignment: AlignmentDirectional.topStart,
                              child: Text(
                                'Please enter the code sent to your phone number',
                                style: Constants.TEXT_STYLE_HEADING_2,
                              )
                            ),

                            // instruction
                            Container(
                              padding: EdgeInsets.symmetric(vertical: screenHeight * 0.018),
                              alignment: AlignmentDirectional.topStart,
                              child: Text(
                                'We sent a verification code to ${widget.contactDetails}',
                                style: Constants.TEXT_STYLE_SUB_HEADING_1,
                              )
                            ),

                            // code indicator
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
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
                                  )
                                ),
                                Container(
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
                                  )
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
                                0.0
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
                                            height: screenHeight * 0.04,
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
                                            height: screenHeight * 0.04,
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
                                            height: screenHeight * 0.04,
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
                                            height: screenHeight * 0.04,
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
                                            height: screenHeight * 0.04,
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
                                            height: screenHeight * 0.04,
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
                                            height: screenHeight * 0.04,
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
                                            alignment: Alignment.center,
                                            height: screenHeight * 0.04,
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
                                            alignment: Alignment.center,
                                            height: screenHeight * 0.04,
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
                                            height: screenHeight * 0.04,
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
                                            height: screenHeight * 0.04,
                                            child: Icon(
                                              Icons.backspace_rounded,
                                              size: 17,
                                            )
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),

            // sign up button
            Positioned(
              bottom: screenHeight * 0.05,
              child: DelayedDisplay(
                delay: Duration(milliseconds: 1000),
                fadingDuration: Duration(milliseconds: 300),
                slidingCurve: Curves.easeInOut,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
                  width: screenWidth,
                  child: ProgressButton(
                    onPressed: () => _verifyButtonHandler(),
                    progressIndicatorAligment: MainAxisAlignment.center,
                    progressIndicatorSize: 25.0,
                    state: _verificationState,
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
                  )
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

}