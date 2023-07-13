import 'package:ap_lib/authenticate/otp_handler.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:email_auth/email_auth.dart';

import '../constants.dart';
import 'verification_code_forgot_password_page.dart';

class EmailForgotPasswordPage extends StatefulWidget {
  @override
  _EmailForgotPasswordPageState createState() => _EmailForgotPasswordPageState();
}

class _EmailForgotPasswordPageState extends State<EmailForgotPasswordPage> {
  TextEditingController _emailInputController = new TextEditingController();

  _back(BuildContext context) {
    Navigator.pop(context);
  }

  _nextButtonHandler(String email) {
    OtpHandler otpHandler = new OtpHandler(context);
    var snackBar;
    otpHandler.sendOtpEmail(email).then((data) => {
      if (!data) {
        snackBar = SnackBar(content: Text('Email sending failed')),
        ScaffoldMessenger.of(context).showSnackBar(snackBar),
      } else {
        Navigator.push(
          context,
          CupertinoPageRoute(builder: (context) => VerificationCodeForgotPasswordPage(
            contactDetails: email,
            method: "email"
          )),
        )
      }
    });
  }

  @override
  void initState() {

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
                  height: screenHeight * 0.53,
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
                  width: screenWidth,
                  child: Column(
                    children: [
                      // main title
                      Container(
                        alignment: AlignmentDirectional.topStart,
                        child: Text(
                          'Please enter your registered email address',
                          style: Constants.TEXT_STYLE_HEADING_2,
                        )
                      ),

                      // instruction
                      Container(
                        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                        alignment: AlignmentDirectional.topStart,
                        child: Text(
                          'An OTP will be sent to your email address',
                          style: Constants.TEXT_STYLE_SUB_HEADING_1,
                        ),
                      ),

                      Container(
                        width: screenWidth,
                        child: TextFormField(
                          autofocus: true,
                          controller: _emailInputController,
                          style: TextStyle(
                            fontSize: 20
                          ),
                          decoration: InputDecoration(
                            hintText: 'TP Email',
                            hintStyle: Constants.TEXT_STYLE_INPUT_HINT_1,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),

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
                    onPressed: () => _nextButtonHandler(_emailInputController.text),
                    progressIndicatorAligment: MainAxisAlignment.center,
                    progressIndicatorSize: 25.0,
                    state: ButtonState.idle,
                    padding: EdgeInsets.all(8.0),
                    stateWidgets: {
                      ButtonState.idle: Text(
                        "Next",
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