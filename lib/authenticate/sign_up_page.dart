import 'dart:convert';

import 'package:ap_lib/authenticate/authentication_handler.dart';
import 'package:ap_lib/authenticate/phone_number_sign_up_page.dart';
import 'package:ap_lib/authenticate/school_department.dart';
import 'package:ap_lib/constants.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_easyloading/flutter_easyloading.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUpPage> {
  bool _hideObscureTextPassword = true;
  bool _hideObscureTextConfirmPassword = true;
  String _currentSelectedSchoolDepartment;
  String _currentSelectedRole;
  TextEditingController _usernameInputController = new TextEditingController();
  TextEditingController _nameInputController = new TextEditingController();
  TextEditingController _emailInputController = new TextEditingController();
  TextEditingController _passwordInputController = new TextEditingController();
  TextEditingController _confirmPasswordInputController = new TextEditingController();
  AuthenticationHandler _authenticationHandler;

  var _formKey = GlobalKey<FormState>();

  List<DropdownMenuItem<String>> _schoolDepartmentList = [];

  List<DropdownMenuItem<String>> _roleList = [
    new DropdownMenuItem(
      child: new Text(
        "PhD",
        style: Constants.TEXT_STYLE_DROPDOWN_HINT_1,
      ),
      value: "RL009",
    ),
    new DropdownMenuItem(
      child: new Text(
        "English Language Courses",
        style: Constants.TEXT_STYLE_DROPDOWN_HINT_1,
      ),
      value: "RL008",
    ),
    new DropdownMenuItem(
      child: new Text(
        "Administrative Staff",
        style: Constants.TEXT_STYLE_DROPDOWN_HINT_1,
      ),
      value: "RL006",
    ),
    new DropdownMenuItem(
      child: new Text(
        "Library Staff",
        style: Constants.TEXT_STYLE_DROPDOWN_HINT_1,
      ),
      value: "RL004",
    ),
    new DropdownMenuItem(
      child: new Text(
        "Part-time Academic Staff",
        style: Constants.TEXT_STYLE_DROPDOWN_HINT_1,
      ),
      value: "RL005",
    ),
    new DropdownMenuItem(
      child: new Text(
        "Full-time Academic Staff",
        style: Constants.TEXT_STYLE_DROPDOWN_HINT_1,
      ),
      value: "RL003",
    ),
    new DropdownMenuItem(
      child: new Text(
        "Masters (part-time)",
        style: Constants.TEXT_STYLE_DROPDOWN_HINT_1,
      ),
      value: "RL007",
    ),
    new DropdownMenuItem(
      child: new Text(
        "Masters (full-time)",
        style: Constants.TEXT_STYLE_DROPDOWN_HINT_1,
      ),
      value: "RL002",
    ),
    new DropdownMenuItem(
      child: new Text(
        "Certificate, Foundation, Diploma and Degree",
        style: Constants.TEXT_STYLE_DROPDOWN_HINT_1,
      ),
      value: "RL001",
    ),
  ];

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

  _schoolDepartmentOnChangeHandler(String newValue) {
    setState(() {
      _currentSelectedSchoolDepartment = newValue;
    });
  }

  _roleOnChangeHandler(String newValue) {
    setState(() {
      _currentSelectedRole = newValue;
    });
  }

  List<SchoolDepartment> _parseSchoolDepartment(String responseBody) {
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
    // final parsed = List<Map<String, dynamic>>.from(json.decode(responseBody));

    return parsed.map<SchoolDepartment>((json) => SchoolDepartment.fromJson(json)).toList();
  }

  Future<List<SchoolDepartment>> _fetchAllSchoolDepartment() async {
    var url = Uri.parse("https://zj9ohmm9uh.execute-api.us-east-1.amazonaws.com/dev/school-department");
    var response = await http.get(url,
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
        'Connection': 'keep-alive',
      },
    );

    return _parseSchoolDepartment(response.body);
  }

  _updateSchoolDepartmentList() {
    _fetchAllSchoolDepartment().then((list) => {
      list.forEach((element) {
        _addItemToSchoolDepartmentList(element);
      })
    });
  }

  _addItemToSchoolDepartmentList(var element) {
    setState(() {
      _schoolDepartmentList.add(
        new DropdownMenuItem(
          child: new Text(
            element.schoolDepartmentName,
            style: Constants.TEXT_STYLE_DROPDOWN_HINT_1,
          ),
          value: element.schoolDepartmentId
        )
      );
    });
  }

  _signUpButtonHandler(String name, String tpNumber, String email,
      String password, String schoolDepartment, String role, BuildContext context) {
    if (_formKey.currentState.validate()) {
      EasyLoading.show(
        status: 'Verifying...',
        maskType: EasyLoadingMaskType.black,
      );
      _authenticationHandler.verifyTpNumber(tpNumber, email).then((response) => {
        EasyLoading.dismiss(),
         if (response == 'not exists') {
            Navigator.push(
            context,
            CupertinoPageRoute(builder: (context) =>
                PhoneNumberSignUpPage(
                  tpNumber: tpNumber,
                  fullName: name,
                  email: email,
                  password: password,
                  schoolDepartment: schoolDepartment,
                  role: role,
                ),
            ),
          ),
         } else if (response == 'exists') {
           showDialog(
             context: context,
             builder: (context) =>
               AlertDialog(
                 title: Text(
                   "Invalid TP Number or Email",
                   style: Constants
                       .TEXT_STYLE_DIALOG_TITLE_AND_ACTION_1,
                 ),
                 content: Text(
                   "The TP Number and/or Email have been registered to the system.",
                   style: Constants.TEXT_STYLE_DIALOG_CONTENT,
                 ),
                 actions: <Widget>[
                   TextButton(
                     onPressed: () {
                       Navigator.of(context).pop();
                     },
                     child: Text(
                       "OK",
                       style: Constants
                           .TEXT_STYLE_DIALOG_TITLE_AND_ACTION_1,
                     ),
                   ),
                 ],
               ),
           ),
         } else if (response == 'in review') {
           showDialog(
             context: context,
             builder: (context) =>
                 AlertDialog(
                   title: Text(
                     "Reviewing",
                     style: Constants
                         .TEXT_STYLE_DIALOG_TITLE_AND_ACTION_1,
                   ),
                   content: Text(
                     "The TP Number and/or Email is still reviewing by the panel.",
                     style: Constants.TEXT_STYLE_DIALOG_CONTENT,
                   ),
                   actions: <Widget>[
                     TextButton(
                       onPressed: () {
                         Navigator.of(context).pop();
                       },
                       child: Text(
                         "OK",
                         style: Constants
                             .TEXT_STYLE_DIALOG_TITLE_AND_ACTION_1,
                       ),
                     ),
                   ],
                 ),
           ),
         } else if (response == "invalid tp") {
            showDialog(
            context: context,
            builder: (context) =>
              AlertDialog(
                title: Text(
                  "Invalid TP Number",
                  style: Constants
                      .TEXT_STYLE_DIALOG_TITLE_AND_ACTION_1,
                ),
                content: Text(
                  "TP Number is not found in the institution's database. Kindly seek for assistance from admins.",
                  style: Constants.TEXT_STYLE_DIALOG_CONTENT,
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "OK",
                      style: Constants
                          .TEXT_STYLE_DIALOG_TITLE_AND_ACTION_1,
                    ),
                  ),
                ],
              ),
          ),
        } else {
            showDialog(
              context: context,
              builder: (context) =>
                AlertDialog(
                  title: Text(
                    "Verification failed",
                    style: Constants
                        .TEXT_STYLE_DIALOG_TITLE_AND_ACTION_1,
                  ),
                  content: Text(
                    "Unexpected error. Pleas try again later.",
                    style: Constants.TEXT_STYLE_DIALOG_CONTENT,
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "OK",
                      style: Constants
                          .TEXT_STYLE_DIALOG_TITLE_AND_ACTION_1,
                      ),
                    ),
                  ],
                ),
            ),
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Invalid input.',
            style: Constants.TEXT_STYLE_SNACK_BAR_CONTENT,
          ),
          backgroundColor: Constants.COLOR_RED,
        ),
      );
    }
  }

  _back(BuildContext context) {
    Navigator.pop(context);
  }

  void initState() {
    super.initState();
    _updateSchoolDepartmentList();
    _authenticationHandler = new AuthenticationHandler();
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
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          physics: BouncingScrollPhysics(),
                          child: Form(
                            key: _formKey,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            child: Column(
                              children: [
                                // tp number input label
                                Container(
                                  alignment: AlignmentDirectional.topStart,
                                  child: Text('TP NUMBER',
                                    style: Constants.textStyleInputLabel
                                  ),
                                ),

                                // tp number text field
                                Container(
                                  width: screenWidth,
                                  padding: EdgeInsets.symmetric(
                                    vertical: screenHeight * 0.01,
                                  ),
                                  child: TextFormField(
                                    controller: _usernameInputController,
                                    maxLength: 8,
                                    maxLengthEnforcement: MaxLengthEnforcement.truncateAfterCompositionEnds,
                                    validator: (value) {
                                      // String pattern = r'([T|t][P|p])[0-9]{6}';
                                      // RegExp regExp = new RegExp(pattern);

                                      if (value.length == 0) {
                                        return '* Required';
                                      }

                                      // if (!regExp.hasMatch(value)) {
                                      //   return 'TP Number is invalid.';
                                      // }
                                      if (value.length > 8) {
                                        return 'TP Number is invalid.';
                                      }

                                      if (value.length < 8) {
                                        return 'TP Number is invalid.';
                                      }

                                      return null;
                                    },
                                    style: TextStyle(
                                        fontSize: 20
                                    ),
                                    decoration: InputDecoration(
                                      counterText: "",
                                      hintText: 'TP Number',
                                      hintStyle: Constants.TEXT_STYLE_INPUT_HINT_1,
                                      prefixIcon: Icon(Icons.person_rounded,
                                        color: Constants.COLOR_BLUE_THEME,
                                        size: 30,
                                      ),
                                    ),
                                  ),
                                ),

                                // name input label
                                Container(
                                  padding: EdgeInsets.only(top: screenHeight * 0.025),
                                  alignment: AlignmentDirectional.topStart,
                                  child: Text('NAME',
                                    style: Constants.textStyleInputLabel,
                                  ),
                                ),

                                // name text field
                                Container(
                                  width: screenWidth,
                                  padding: EdgeInsets.symmetric(
                                    vertical: screenHeight * 0.01,
                                  ),
                                  child: TextFormField(
                                    controller: _nameInputController,
                                    validator: (value) {
                                      if (value.length == 0) {
                                        return '* Required';
                                      }

                                      return null;
                                    },
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: 'Name',
                                      hintStyle: Constants.TEXT_STYLE_INPUT_HINT_1,
                                      prefixIcon: Icon(Icons.person_add_alt_1_rounded,
                                        color: Constants.COLOR_BLUE_THEME,
                                        size: 30,
                                      ),
                                    ),
                                  ),
                                ),

                                // email input label
                                Container(
                                  padding: EdgeInsets.only(top: screenHeight * 0.025),
                                  alignment: AlignmentDirectional.topStart,
                                  child: Text('TP EMAIL',
                                      style: Constants.textStyleInputLabel
                                  ),
                                ),

                                // email text field
                                Container(
                                  width: screenWidth,
                                  padding: EdgeInsets.symmetric(
                                      vertical: screenHeight * 0.01
                                  ),
                                  child: TextFormField(
                                    keyboardType: TextInputType.emailAddress,
                                    controller: _emailInputController,
                                    validator: (value) {
                                      if (value.length == 0) {
                                        return '* Required';
                                      }

                                      if (!EmailValidator.validate(value)) {
                                        return 'Email is invalid.';
                                      }

                                      return null;
                                    },
                                    style: TextStyle(
                                        fontSize: 20
                                    ),
                                    decoration: InputDecoration(
                                      hintText: 'TP Email',
                                      hintStyle: Constants.TEXT_STYLE_INPUT_HINT_1,
                                      prefixIcon: Icon(Icons.email_rounded ,
                                        color: Constants.COLOR_BLUE_THEME,
                                        size: 30,
                                      ),
                                    ),
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

                                // password text field
                                Container(
                                  width: screenWidth,
                                  padding: EdgeInsets.symmetric(
                                    vertical: screenHeight * 0.01,
                                  ),
                                  child: TextFormField(
                                    obscureText: _hideObscureTextPassword,
                                    controller: _passwordInputController,
                                    validator: (value) {
                                      if (value.length == 0) {
                                        return "* Required";
                                      }

                                      if (value.length > 20 || value.length < 8) {
                                        return "Password length must between 8 and 20.";
                                      }

                                      return null;
                                    },
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: 'Password',
                                      hintStyle: Constants.TEXT_STYLE_INPUT_HINT_1,
                                      prefixIcon: Icon(Icons.lock_rounded ,
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
                                    style: Constants.textStyleInputLabel,
                                  ),
                                ),

                                // confirm password text field
                                Container(
                                  width: screenWidth,
                                  padding: EdgeInsets.symmetric(
                                    vertical: screenHeight * 0.01,
                                  ),
                                  child: TextFormField(
                                    obscureText: _hideObscureTextConfirmPassword,
                                    controller: _confirmPasswordInputController,
                                    validator: (value) {
                                      if (value.length == 0) {
                                        return "* Required";
                                      }

                                      if (value != _passwordInputController.text) {
                                        return 'Password is different.';
                                      }

                                      return null;
                                    },
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
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

                                // school / faculty / department input label
                                Container(
                                  padding: EdgeInsets.only(top: screenHeight * 0.025),
                                  alignment: AlignmentDirectional.topStart,
                                  child: Text('SCHOOL / FACULTY / DEPARTMENT',
                                    style: Constants.textStyleInputLabel,
                                  ),
                                ),

                                // school / faculty / department text field
                                Container(
                                  width: screenWidth,
                                  padding: EdgeInsets.symmetric(
                                    vertical: screenHeight * 0.01,
                                  ),
                                  child: DropdownButtonFormField(
                                    hint: Text("School / Faculty / Department"),
                                    value: _currentSelectedSchoolDepartment,
                                    items: _schoolDepartmentList,
                                    validator: (value) {
                                      if (_currentSelectedSchoolDepartment == null) {
                                        return '* Required';
                                      }

                                      return null;
                                    },
                                    onChanged: (newValue) => _schoolDepartmentOnChangeHandler(newValue),
                                    style: Constants.TEXT_STYLE_INPUT_HINT_1,
                                    isExpanded: true,
                                    decoration: InputDecoration(
                                      hintStyle: Constants.TEXT_STYLE_INPUT_HINT_1,
                                      prefixIcon: Icon(Icons.school_rounded ,
                                        color: Constants.COLOR_BLUE_THEME,
                                        size: 30,
                                      ),
                                    ),
                                  ),
                                ),

                                // role input label
                                Container(
                                  padding: EdgeInsets.only(top: screenHeight * 0.025),
                                  alignment: AlignmentDirectional.topStart,
                                  child: Text('ROLE',
                                    style: Constants.textStyleInputLabel,
                                  ),
                                ),

                                // role text field
                                Container(
                                  width: screenWidth,
                                  padding: EdgeInsets.symmetric(
                                    vertical: screenHeight * 0.01,
                                  ),
                                  child: DropdownButtonFormField(
                                    hint: Text("Role"),
                                    value: _currentSelectedRole,
                                    items: _roleList,
                                    validator: (value) {
                                      if (_currentSelectedRole == null) {
                                        return '* Required';
                                      }

                                      return null;
                                    },
                                    onChanged: (newValue) => _roleOnChangeHandler(newValue),
                                    style: Constants.TEXT_STYLE_INPUT_HINT_1,
                                    isExpanded: true,
                                    decoration: InputDecoration(
                                      hintStyle: Constants.TEXT_STYLE_INPUT_HINT_1,
                                      prefixIcon: Icon(Icons.engineering_rounded ,
                                        color: Constants.COLOR_BLUE_THEME,
                                        size: 30,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
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
                    onPressed: () => _signUpButtonHandler(
                      _nameInputController.text,
                      _usernameInputController.text,
                      _emailInputController.text,
                      _confirmPasswordInputController.text,
                      _currentSelectedSchoolDepartment,
                      _currentSelectedRole,
                      context
                    ),
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
            ),
          ],
        ),
      )
    );
  }
}