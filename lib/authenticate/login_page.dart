import 'dart:async';

import 'package:ap_lib/authenticate/authentication_handler.dart';
import 'package:ap_lib/authenticate/phone_number_forgot_password_page.dart';
import 'package:ap_lib/authenticate/sign_up_page.dart';
import 'package:ap_lib/constants.dart';
import 'package:ap_lib/dashboard/dashboard_page.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _hideObscureText = true;
  ButtonState _signInState = ButtonState.idle;
  TextEditingController _usernameInputController = new TextEditingController();
  TextEditingController _passwordInputController = new TextEditingController();
  String _authenticationToken = "";
  String _userRole = "";

  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};

  @override
  void initState() {
    super.initState();
    initPlatformState();
    // print(new CryptographyHandler().encryptString(new CryptographyHandler().hashString("11221122")));
    // print(new CryptographyHandler().hashString("11111111"));
  }

  Future<void> initPlatformState() async {
    var deviceData = <String, dynamic>{};
    try {
      deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    if (!mounted) return;

    setState(() {
      _deviceData = deviceData;
      print(_deviceData);
    });
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'androidId': build.androidId,
      'systemFeatures': build.systemFeatures,
    };
  }

  _toggleObscureView() {
    setState(() {
      _hideObscureText = !_hideObscureText;
    });
  }

  _signInButtonHandler() async {
    AuthenticationHandler _authenticationHandler = new AuthenticationHandler();
    switch (_signInState) {
      case ButtonState.idle:
        _signInState = ButtonState.loading;
        _authenticationHandler.authenticateCredential(
            _usernameInputController.text,
            _passwordInputController.text,
            _deviceData['version.release'] + ' ' + _deviceData['id'],
            _deviceData['brand'] + ' ' +  _deviceData['model'],).then((authentication) {
          if (authentication.authenticationToken == "none" || authentication.authenticationToken == null) {
            setState(() {
              _signInState = ButtonState.fail;
            });
          } else {
            setState(() {
              _authenticationToken = authentication.authenticationToken;
              _userRole = authentication.userRole;
              _authenticationHandler.saveToken(_authenticationToken, _userRole).then((value)
                => {
                  _signInState = ButtonState.success,
                  Future.delayed(Duration(seconds: 1), () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      CupertinoPageRoute(builder: (context) => DashboardPage()),
                      ModalRoute.withName('/')
                    );
                  }),
                }
              );
            });
          }
        });
        break;
      case ButtonState.loading:
        break;
      case ButtonState.success:
        _signInState = ButtonState.idle;
        break;
      case ButtonState.fail:
        _signInState = ButtonState.idle;
        Future.delayed(Duration(seconds: 1), () {
          setState(() {
            _signInState = ButtonState.idle;
          });
        });
        break;
    }
    setState(() {
      _signInState = _signInState;
    });
  }

  _forgotPasswordButtonHandler(BuildContext context) {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => PhoneNumberForgotPasswordPage())
    );
  }

  _signUpButtonHandler(BuildContext context) {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => SignUpPage())
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: screenHeight,
        child: Stack(
          alignment: AlignmentDirectional.topCenter,
          children: [
            FlareActor(
              'assets/login_page.flr',
              animation: 'Login Page',
              fit: BoxFit.cover,
            ),
            Positioned(
              top: screenHeight * 0.42,
              child: DelayedDisplay(
                delay: Duration(milliseconds: 1000),
                fadingDuration: Duration(milliseconds: 300),
                slidingCurve: Curves.easeInOut,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
                      width: screenWidth,
                      child: Column(
                        children: [
                          Container(
                            alignment: AlignmentDirectional.topStart,
                            child: Text('TP NUMBER',
                              style: Constants.textStyleInputLabel,
                            ),
                          ),

                          // tp number text field
                          Container(
                            width: screenWidth,
                            padding: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.01
                            ),
                            child: TextFormField(
                              controller: _usernameInputController,
                              style: TextStyle(
                                  fontSize: 20
                              ),
                              decoration: InputDecoration(
                                hintText: 'TP Number',
                                hintStyle: Constants.TEXT_STYLE_INPUT_HINT_1,
                                prefixIcon: Icon(Icons.person_rounded,
                                  color: Constants.COLOR_BLUE_THEME,
                                  size: 30,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            alignment: AlignmentDirectional.topStart,
                            padding: EdgeInsets.only(top: screenHeight * 0.025),
                            child: Text('PASSWORD',
                              style: Constants.textStyleInputLabel,
                            ),
                          ),

                          // password text field
                          Container(
                            width: screenWidth,
                            padding: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.01
                            ),
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                  primaryColor: Constants.COLOR_BLUE_THEME
                              ),
                              child: TextFormField(
                                controller: _passwordInputController,
                                obscureText: _hideObscureText,
                                style: TextStyle(
                                    fontSize: 20
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Password',
                                  hintStyle: Constants.TEXT_STYLE_INPUT_HINT_1,
                                  prefixIcon: Icon(Icons.lock_rounded,
                                    color: Constants.COLOR_BLUE_THEME,
                                    size: 30,
                                  ),
                                  suffix: GestureDetector(
                                    onTap: () => _toggleObscureView(),
                                    child: Icon(
                                      _hideObscureText
                                          ? Icons.visibility_rounded
                                          : Icons.visibility_off_rounded,
                                      color: Constants.COLOR_SILVER_LIGHT,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // forgot password section
                          Container(
                            padding: EdgeInsets.only(top: screenHeight * 0.01),
                            child: GestureDetector(
                              onTap: () => _forgotPasswordButtonHandler(context),
                              child: Text(
                                'Forgot your password?',
                                style: Constants.textStyleForgotPasswordText,
                              )
                            ),
                          ),
                        ]
                      ),
                    ),
                  ]
                ),
              ),
            ),

            // sign in button section
            Positioned(
              bottom: screenHeight * 0.15,
              child: DelayedDisplay(
                delay: Duration(milliseconds: 1000),
                fadingDuration: Duration(milliseconds: 300),
                slidingCurve: Curves.easeInOut,
                child: Column(
                  children: [
                    // sign in button
                    Container(
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
                        width: screenWidth,
                        child: ProgressButton(
                          onPressed: () => _signInButtonHandler(),
                          progressIndicatorAligment: MainAxisAlignment.center,
                          progressIndicatorSize: 25.0,
                          state: _signInState,
                          padding: EdgeInsets.all(8.0),
                          stateWidgets: {
                            ButtonState.idle: Text(
                                "Sign In",
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

                    // sign up text
                    Container(
                      padding: EdgeInsets.only(top: screenHeight * 0.015),
                      child: RichText(
                        text: TextSpan(
                          text: "Don't have account?",
                          style: Constants.textStyleSignUpText1,
                          children: [
                            TextSpan(
                              text: " Sign Up ",
                              style: Constants.textStyleSignUpText2,
                              recognizer: new TapGestureRecognizer()..onTap
                                = () => _signUpButtonHandler(context)
                            ),
                            TextSpan(
                              text: "now"
                            )
                          ],
                        ),
                      ),
                    ),

                    // FutureBuilder(
                    //   future: new AuthenticationHandler().authenticateAPICall("TP045928", "12345678"),
                    //   builder: (context, snapshot) {
                    //     print(snapshot);
                    //     if (snapshot.hasData) {
                    //       return Text("${snapshot.data.username}");
                    //     }
                    //
                    //     return CircularProgressIndicator();
                    //   },
                    // )


                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}