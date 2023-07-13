import 'package:ap_lib/authenticate/authentication_handler.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:progress_state_button/progress_button.dart';

import '../constants.dart';
import 'login_page.dart';

class VerificationCodeSignUpPage extends StatefulWidget {
  final String verificationCode;
  final String phoneNumber;
  final String tpNumber;
  final String fullName;
  final String email;
  final String password;
  final String schoolDepartment;
  final String role;

  VerificationCodeSignUpPage({
    @required this.verificationCode,
    @required this.phoneNumber,
    @required this.tpNumber,
    @required this.fullName,
    @required this.email,
    @required this.password,
    @required this.schoolDepartment,
    @required this.role
  });

  @override
  _VerificationCodeSignUpPageState createState() => _VerificationCodeSignUpPageState();
}

class _VerificationCodeSignUpPageState extends State<VerificationCodeSignUpPage> {
  List<String> _verificationCode = [];
  ButtonState _signUpState = ButtonState.idle;

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

  void _signUpButtonHandler() async {
    AuthenticationHandler _authenticationHandler = new AuthenticationHandler();
    switch (_signUpState) {
      case ButtonState.idle:
        setState(() {
          _signUpState = ButtonState.loading;
        });
        if (widget.verificationCode == convertVerificationCodeToString()) {
          _authenticationHandler.signUp(widget.phoneNumber, widget.tpNumber.toUpperCase(), widget.fullName,
              widget.email, widget.password, widget.schoolDepartment, widget.role).then((status) {
             print(status);

             if (status == "success" && widget.role == 'RL004') {
               showDialog(
                 context: context,
                 builder: (context) =>
                     AlertDialog(
                       title: Text(
                         "Request Sent",
                         style: Constants
                             .TEXT_STYLE_DIALOG_TITLE_AND_ACTION_1,
                       ),
                       content: Text(
                         "Your request will reviewed by the panel. Kindly check with the librarian for the request status.",
                         style: Constants.TEXT_STYLE_DIALOG_CONTENT,
                       ),
                       actions: <Widget>[
                         TextButton(
                           onPressed: () {
                             Navigator.pushAndRemoveUntil(
                                 context,
                                 CupertinoPageRoute(builder: (context) => LoginPage()),
                                 ModalRoute.withName('/'),
                             );
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
               setState(() {
                 _signUpState = ButtonState.success;
               });
             } else if (status == "success") {
               Navigator.pushAndRemoveUntil(
                 context,
                 CupertinoPageRoute(builder: (context) => LoginPage()),
                 ModalRoute.withName('/'),
               );
             } else {
               setState(() {
                 _signUpState = ButtonState.fail;
               });
             }
          });
        } else {
          print("verification failed");
          setState(() {
            _signUpState = ButtonState.fail;
          });
        }
        break;
      case ButtonState.loading:
        break;
      case ButtonState.success:
        _signUpState = ButtonState.idle;
        break;
      case ButtonState.fail:
        _signUpState = ButtonState.idle;
        Future.delayed(Duration(seconds: 1), () {
          setState(() {
            _signUpState = ButtonState.idle;
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
              'assets/sign_up_page.flr',
              animation: "SignUp Page",
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
                                'We sent a verification code to ${widget.phoneNumber}',
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
                                  ),
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
                            ),
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
                    onPressed: () => _signUpButtonHandler(),
                    progressIndicatorAligment: MainAxisAlignment.center,
                    progressIndicatorSize: 25.0,
                    state: _signUpState,
                    padding: EdgeInsets.all(8.0),
                    stateWidgets: {
                      ButtonState.idle: Text(
                        "Sign Up",
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
            ),
          ],
        ),
      ),
    );
  }

}