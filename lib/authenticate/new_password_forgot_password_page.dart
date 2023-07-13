import 'package:ap_lib/authenticate/authentication_handler.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:progress_state_button/progress_button.dart';

import '../constants.dart';
import 'login_page.dart';

class NewPasswordForgotPasswordPage extends StatefulWidget {
  final String contactDetails;
  final String method;

  NewPasswordForgotPasswordPage({
    @required this.contactDetails,
    @required this.method
  });

  @override
  _NewPasswordForgotPasswordPageState createState() => _NewPasswordForgotPasswordPageState();
}

class _NewPasswordForgotPasswordPageState extends State<NewPasswordForgotPasswordPage> {
  TextEditingController _passwordInputController = new TextEditingController();
  TextEditingController _confirmPasswordInputController = new TextEditingController();
  bool _hideObscureTextPassword = true;
  bool _hideObscureTextConfirmPassword = true;
  ButtonState _updateState = ButtonState.idle;

  var _formKey = GlobalKey<FormState>();

  _back(BuildContext context) {
    Navigator.pop(context);
  }

  _toggleObscureViewPassword() {
    setState(() {
      _hideObscureTextPassword = !_hideObscureTextPassword;
    });
  }

  _toggleObscureViewConfirmPassword() {
    setState(() {
      _hideObscureTextConfirmPassword = !_hideObscureTextConfirmPassword;
    });
  }

  _updateButtonHandler(String password, String confirmPassword) {
    AuthenticationHandler _authenticationHandler = new AuthenticationHandler();
    // if (password == confirmPassword) {
      switch (_updateState) {
        case ButtonState.idle:
          setState(() {
            _updateState = ButtonState.loading;
          });
          if (password == confirmPassword && _formKey.currentState.validate()) {
            var _contactDetails;
            if (widget.method == "phone")
              _contactDetails = widget.contactDetails.substring(
                  1, widget.contactDetails.length);

            _contactDetails = widget.contactDetails;

            _authenticationHandler.updatePassword(
                password, _contactDetails, widget.method).then((status) {
              print(status);
              if (status == "success") {
                setState(() {
                  _updateState = ButtonState.success;
                });
                Navigator.pushAndRemoveUntil(
                    context,
                    CupertinoPageRoute(builder: (context) => LoginPage()),
                    ModalRoute.withName('/')
                );
              } else {
                setState(() {
                  _updateState = ButtonState.fail;
                });
              }
            });
          } else {
            setState(() {
              _updateState = ButtonState.fail;
            });
          }
          break;
        case ButtonState.loading:
          break;
        case ButtonState.success:
          _updateState = ButtonState.idle;
          break;
        case ButtonState.fail:
          _updateState = ButtonState.idle;
          Future.delayed(Duration(seconds: 1), () {
            setState(() {
              _updateState = ButtonState.idle;
            });
          });
          break;
      }
    // }
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
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.always,
                    child: Column(
                      children: [
                        Container(
                          alignment: AlignmentDirectional.topStart,
                          child: Text(
                            'Please enter your new password',
                            style: Constants.TEXT_STYLE_HEADING_2,
                          ),
                        ),

                        // password input label
                        Container(
                          padding: EdgeInsets.only(top: screenHeight * 0.025),
                          alignment: AlignmentDirectional.topStart,
                          child: Text('PASSWORD',
                            style: Constants.textStyleInputLabel,
                          ),
                        ),

                        // password input field
                        Container(
                          width: screenWidth,
                          padding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.01,
                          ),
                          child: TextFormField(
                            obscureText: _hideObscureTextPassword,
                            controller: _passwordInputController,
                            style: TextStyle(
                              fontSize: 20,
                            ),
                            validator: (value) {
                              if (value.length == 0) {
                                return "* Required";
                              }

                              if (value.length > 20 || value.length < 8) {
                                return "Password length must between 8 and 20.";
                              }

                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: 'Password',
                              hintStyle: Constants.TEXT_STYLE_INPUT_HINT_1,
                              prefixIcon: Icon(
                                Icons.lock_rounded,
                                color: Constants.COLOR_BLUE_THEME,
                                size: 30,
                              ),
                              suffix: GestureDetector(
                                onTap: () => _toggleObscureViewPassword(),
                                child: Icon(
                                  _hideObscureTextPassword
                                    ? Icons.visibility_rounded
                                    : Icons.visibility_off_rounded,
                                  color: Constants.COLOR_SILVER_LIGHT,
                                ),
                              ),
                            ),
                          ),
                        ),

                        // confirm password input label
                        Container(
                          padding: EdgeInsets.only(top: screenHeight * 0.025),
                          alignment: AlignmentDirectional.topStart,
                          child: Text('CONFIRM PASSWORD',
                            style: Constants.textStyleInputLabel
                          ),
                        ),

                        // confirm password text field
                        Container(
                          width: screenWidth,
                          padding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.01
                          ),
                          child: TextFormField(
                            obscureText: _hideObscureTextConfirmPassword,
                            controller: _confirmPasswordInputController,
                            style: TextStyle(
                              fontSize: 20
                            ),
                            validator: (value) {
                              if (value.length == 0) {
                                return "* Required";
                              }

                              if (value != _passwordInputController.text) {
                                return 'Password is different.';
                              }

                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: 'Confirm Password',
                              hintStyle: Constants.TEXT_STYLE_INPUT_HINT_1,
                              prefixIcon: Icon(Icons.lock_rounded ,
                                color: Constants.COLOR_BLUE_THEME,
                                size: 30,
                              ),
                              suffix: GestureDetector(
                                onTap: () => _toggleObscureViewConfirmPassword(),
                                child: Icon(
                                  _hideObscureTextConfirmPassword
                                    ? Icons.visibility_rounded
                                    : Icons.visibility_off_rounded,
                                  color: Constants.COLOR_SILVER_LIGHT,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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
                    onPressed: () => _updateButtonHandler(
                      _passwordInputController.text,
                      _confirmPasswordInputController.text
                    ),
                    progressIndicatorAligment: MainAxisAlignment.center,
                    progressIndicatorSize: 25.0,
                    state: _updateState,
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
            ),
          ],
        ),
      ),
    );
  }

}