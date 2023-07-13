import 'package:ap_lib/authenticate/authentication_handler.dart';
import 'package:ap_lib/constants.dart';
import 'package:ap_lib/authenticate/otp_handler.dart';
import 'package:ap_lib/authenticate/verification_code_sign_up_page.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:progress_state_button/progress_button.dart';
// import 'package:sms_autofill/sms_autofill.dart';
import 'dart:async';

class PhoneNumberSignUpPage extends StatefulWidget {
  final String tpNumber;
  final String fullName;
  final String email;
  final String password;
  final String schoolDepartment;
  final String role;

  PhoneNumberSignUpPage({
    @required this.tpNumber,
    @required this.fullName,
    @required this.email,
    @required this.password,
    @required this.schoolDepartment,
    @required this.role
  });

  @override
  _PhoneNumberSignUpPageState createState() => _PhoneNumberSignUpPageState();
}

class _PhoneNumberSignUpPageState extends State<PhoneNumberSignUpPage> {
    PhoneNumber _phoneNumber = new PhoneNumber();

    _back(BuildContext context) {
      Navigator.pop(context);
    }

    _nextButtonHandler(String phoneNumber) async {
      OtpHandler otpHandler = new OtpHandler(context);
      AuthenticationHandler _authenticationHandler = new AuthenticationHandler();
      EasyLoading.show(
        status: 'Verifying...',
        maskType: EasyLoadingMaskType.black,
      );
      _authenticationHandler.verifyContactNumber(phoneNumber.substring(1, phoneNumber.length)).then((signUp) => {
        EasyLoading.dismiss(),
        if (signUp.signUpStatus == 'not found') {
          Navigator.push(
            context,
            CupertinoPageRoute(builder: (context) =>
              VerificationCodeSignUpPage(
                verificationCode: otpHandler.sendOtp(phoneNumber),
                phoneNumber: phoneNumber.substring(1, phoneNumber.length),
                tpNumber: widget.tpNumber,
                fullName: widget.fullName,
                email: widget.email,
                password: widget.password,
                schoolDepartment: widget.schoolDepartment,
                role: widget.role,
              ),
            ),
          ),
        } else if (signUp.signUpStatus == 'found') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Phone number exists.',
                style: Constants.TEXT_STYLE_SNACK_BAR_CONTENT,
              ),
              backgroundColor: Constants.COLOR_RED,
            ),
          ),
        }
      });
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
              Icons.arrow_back_outlined,
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
                                child: Text(
                                  'A verification code will be sent to your phone number',
                                  style: Constants.TEXT_STYLE_SUB_HEADING_1,
                                )
                              ),

                              // international number input
                              Container(
                                child: InternationalPhoneNumberInput(
                                  isEnabled: true,
                                  spaceBetweenSelectorAndTextField: 0.0,
                                  selectorTextStyle: Constants.TEXT_STYLE_DROPDOWN_HINT_1,
                                  textStyle: Constants.TEXT_STYLE_DROPDOWN_HINT_1,
                                  // initialValue: PhoneNumber(isoCode: 'MY'),
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

              // next button
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