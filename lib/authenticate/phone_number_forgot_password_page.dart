import 'package:ap_lib/authenticate/verification_code_forgot_password_page.dart';
import 'package:ap_lib/authenticate/email_forgot_password_page.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:progress_state_button/progress_button.dart';

import '../constants.dart';
import 'otp_handler.dart';

class PhoneNumberForgotPasswordPage extends StatefulWidget {
  @override
  _PhoneNumberForgotPasswordPageState createState() => _PhoneNumberForgotPasswordPageState();
}

class _PhoneNumberForgotPasswordPageState extends State<PhoneNumberForgotPasswordPage> {
  PhoneNumber _phoneNumber = new PhoneNumber();

  _back(BuildContext context) {
    Navigator.pop(context);
  }

  _emailOptionButtonHandler(BuildContext context) {
    Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
            builder: (context) => EmailForgotPasswordPage()
        )
    );
  }

  _nextButtonHandler(String phoneNumber) {
    OtpHandler otpHandler = new OtpHandler(context);
    try {
      Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (context) =>
                  VerificationCodeForgotPasswordPage(
                    verificationCode: otpHandler.sendOtp(phoneNumber),
                    contactDetails: phoneNumber,
                    method: "phone",
                  )
          )
      );
    } catch (Exception) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Invalid phone number.',
            style: Constants.TEXT_STYLE_SNACK_BAR_CONTENT,
          ),
          backgroundColor: Constants.COLOR_RED,
        ),
      );
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
                              padding: EdgeInsets.only(right: screenWidth * 0.4),
                              alignment: AlignmentDirectional.topStart,
                              child: Text(
                                'Please enter your phone number',
                                style: Constants.TEXT_STYLE_HEADING_2,
                              )
                            ),

                            // instruction
                            Container(
                              padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                              alignment: AlignmentDirectional.topStart,
                              child: RichText(
                                text: TextSpan(
                                  text: 'An OTP will be sent to your phone number or',
                                  style: Constants.TEXT_STYLE_SUB_HEADING_1,
                                  children: [
                                    TextSpan(
                                      text: " use email to receive the OTP",
                                      style: Constants.TEXT_STYLE_FORGOT_PASSWORD_EMAIL_OPTION_TEXT,
                                      recognizer: new TapGestureRecognizer()..onTap
                                        = () => _emailOptionButtonHandler(context)
                                    )
                                  ]
                                ),
                                // ,
                                // style: Constants.TEXT_STYLE_SUB_HEADING_1,
                              )
                            ),

                            // international number input
                            Container(
                              child: InternationalPhoneNumberInput(
                                isEnabled: true,
                                spaceBetweenSelectorAndTextField: 0.0,
                                selectorTextStyle: Constants.TEXT_STYLE_DROPDOWN_HINT_1,
                                textStyle: Constants.TEXT_STYLE_DROPDOWN_HINT_1,
                                // initialValue: new PhoneNumber(isoCode: 'MY'),
                                // textFieldController: _phoneNumberInputController,
                                onInputChanged: (PhoneNumber phoneNumber) => {
                                  _phoneNumber = phoneNumber
                                },
                                keyboardType:
                                TextInputType.numberWithOptions(signed: true, decimal: true),
                                selectorConfig: SelectorConfig(
                                  selectorType: PhoneInputSelectorType.DIALOG,
                                  useEmoji: true,
                                  showFlags: true,
                                  setSelectorButtonAsPrefixIcon: false
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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
                    onPressed: () => _nextButtonHandler(_phoneNumber.phoneNumber),
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