import 'package:animate_icons/animate_icons.dart';
import 'package:ap_lib/authenticate/authentication_handler.dart';
import 'package:ap_lib/profile/my_qr_page.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'complete_update_page.dart';
import 'package:ap_lib/enum/enum_state.dart';
import 'package:ap_lib/user/user_data_fetcher.dart';
import 'package:ap_lib/user/user_details_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'verification_code_update_profile_page.dart';
import 'package:ap_lib/authenticate/otp_handler.dart';
import 'package:email_validator/email_validator.dart';

import '../constants.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin {
  TextEditingController _nameController;
  TextEditingController _tpNumberController;
  TextEditingController _emailController;
  TextEditingController _contactNumberController;
  TextEditingController _passwordController;
  TextEditingController _confirmPasswordController;

  var _formKey = GlobalKey<FormState>();

  AnimateIconController _animateIconController;

  AuthenticationHandler _authenticationHandler;
  UserDataFetcher _userDataFetcher;

  LoadState _loadState = LoadState.Loading;

  bool _editMode = false;

  String _nameText = 'Bryan Leong Wai Yik';
  String _tpNumberText = 'TP045928';
  String _emailText = 'tp045928@mail.apu.edu.my';
  String _contactNumberText = '60182912618';
  String _schoolDepartmentText = 'School of Computing and Technology';
  String _schoolDepartmentId = '';

  // default password text to detect changes
  String _passwordText = '########';
  String _confirmPasswordText = '########';

  String _currentSelectedSchoolDepartment;

  List<UserDetailsModel> _userDetails = [];

  List<String> _schoolDepartmentString = [
    'SD000001,School of Computing and Technology',
    'SD000002,School of Business',
    'SD000003,School of Art',
    'SD000004,School of Engineering',
    'SD000005,School of Finance and Accounting',
    'SD100001,Finance Department',
    'SD100002,Logistic Department',
    'SD100003,Student Service Department',
    'SD100004,Library Department',
  ];

  Future<List<UserDetailsModel>> _fetchUserDetails() async {
    String userToken = await _authenticationHandler.getToken();
    return await _userDataFetcher.getUserDetails(userToken);
  }

  bool _onEndIconPress(BuildContext context) {
    OtpHandler otpHandler = new OtpHandler(context);
    if (_formKey.currentState.validate()) {
      _authenticationHandler.getToken().then((token) => {
        EasyLoading.show(
        status: 'Verifying...',
        maskType: EasyLoadingMaskType.black,
        ),
        _userDataFetcher.verifyEmailPhone(_emailController.text, _contactNumberController.text, token).then((response) {
          EasyLoading.dismiss();
          if (response == 'success') {
            if (_contactNumberText != _userDetails[0].contactNumber ||
                (_confirmPasswordController.text == _passwordController.text
                    && _passwordController.text != '########')) {
              _authenticationHandler.getToken().then((userToken) =>
              {
                // otpHandler.sendOtp(_contactNumberController.text),
                Navigator.push(
                  context,
                  CupertinoPageRoute(builder: (context) =>
                      VerificationCodeUpdateProfilePage(
                        userToken: userToken,
                        name: _nameController.text,
                        email: _emailController.text,
                        phoneNumber: _contactNumberController.text,
                        schoolDepartmentId: _currentSelectedSchoolDepartment != null
                            ? _currentSelectedSchoolDepartment
                            : _schoolDepartmentId,
                        password: _passwordText,
                        verificationCode: otpHandler.sendOtp(
                            '+' + _contactNumberController.text),
                      )),
                ),
              });
            } else if (_nameText != _userDetails[0].fullName ||
                _emailText != _userDetails[0].email ||
                _contactNumberText != _userDetails[0].contactNumber
                || _currentSelectedSchoolDepartment != null ||
                (_passwordController.text == _confirmPasswordController.text
                    && _passwordController.text != '########')) {
              _authenticationHandler.getToken().then((userToken) {
                _userDataFetcher.updateUserDetails(userToken, _nameController.text,
                    _emailController.text, _contactNumberController.text,
                    _currentSelectedSchoolDepartment != null
                        ? _currentSelectedSchoolDepartment
                        : _schoolDepartmentId).then((status) =>
                {
                  if (status == 'success') {
                    _authenticationHandler.updatePassword(
                        _passwordController.text, userToken, 'token').then((
                        updatePasswordStatus) =>
                    {
                      if (updatePasswordStatus == 'success') {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(builder: (context) =>
                              CompleteUpdatePage()),
                        ),
                      }
                    }),
                  },
                });
              });
            } else {
              print('failed');
            }
          } else {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(
                  "Duplication Found",
                  style: Constants.TEXT_STYLE_DIALOG_TITLE_AND_ACTION_1,
                ),
                content: Text(
                  "Duplicate phone number or email is found.",
                  style: Constants.TEXT_STYLE_DIALOG_CONTENT,
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "OK",
                      style: Constants.TEXT_STYLE_DIALOG_TITLE_AND_ACTION_1,
                    ),
                  ),
                ],
              ),
            );
          }
        }),
      });
      setState(() {
        _editMode = !_editMode;
      });

      return true;

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

    return false;
  }

  void _schoolDepartmentDropdownHandler(String newValue) {
    print(newValue);
    setState(() {
      _currentSelectedSchoolDepartment = newValue;
      _schoolDepartmentString.forEach((element) {
        if (element.contains(newValue)) {
          var part = element.split(',');
          print(part);
          _schoolDepartmentText = part[1];
        }
      });
    });
  }

  bool _onStartIconPress(BuildContext context) {
    // setState(() {
    //   _editMode = !_editMode;
    // });
    _fetchUserDetails().then((list) => {
      if (mounted) {
        setState(() {
          _userDetails = list;
          _nameText = _userDetails[0].fullName;
          _tpNumberText = _userDetails[0].tpNumber;
          _emailText = _userDetails[0].email;
          _contactNumberText = _userDetails[0].contactNumber;
          _schoolDepartmentText = _userDetails[0].schoolDepartment;
          _schoolDepartmentId = _userDetails[0].schoolDepartmentId;
          _loadState = LoadState.Done;
          _editMode = !_editMode;
        })
      }
    });
    return true;
  }

  void _navigateToMyQrPage() {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => MyQrPage(
        name: _nameText,
        tpNumber: _tpNumberText,
      )),
    );
  }

  _back(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();

    _authenticationHandler = new AuthenticationHandler();
    _userDataFetcher = new UserDataFetcher();

    _nameController = new TextEditingController();
    _tpNumberController = new TextEditingController();
    _emailController = new TextEditingController();
    _contactNumberController = new TextEditingController();
    _passwordController = new TextEditingController();
    _confirmPasswordController = new TextEditingController();

    _animateIconController = new AnimateIconController();

    _fetchUserDetails().then((list) => {
      if (mounted) {
        setState(() {
          _userDetails = list;
          _nameText = _userDetails[0].fullName;
          _tpNumberText = _userDetails[0].tpNumber;
          _emailText = _userDetails[0].email;
          _contactNumberText = _userDetails[0].contactNumber;
          _schoolDepartmentText = _userDetails[0].schoolDepartment;
          _schoolDepartmentId = _userDetails[0].schoolDepartmentId;
          _loadState = LoadState.Done;
        })
      }
    });
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: _editMode ? Constants.COLOR_RED : Constants.COLOR_BLUE_THEME,
        child: AnimateIcons(
          startIcon: Icons.edit_rounded,
          endIcon: Icons.done_rounded,
          startIconColor: Constants.COLOR_WHITE,
          endIconColor: Constants.COLOR_WHITE,
          controller: _animateIconController,
          onEndIconPress: () => _onEndIconPress(context),
          onStartIconPress: () => _onStartIconPress(context),
          duration: Duration(milliseconds: 300),
        ),
      ),
      body: SizedBox.expand(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: BouncingScrollPhysics(),
          child: Container(
            padding: EdgeInsets.fromLTRB(screenWidth * 0.05, screenHeight * 0.02, screenWidth * 0.05, 0.0),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.always,
              child: Column(
                children: [
                  // page title
                  Container(
                    width: screenWidth,
                    child: Text(
                      'My Profile',
                      style: Constants.TEXT_STYLE_HEADING_1,
                    ),
                  ),

                  // 1st section
                  Container(
                    margin: EdgeInsets.only(top: screenHeight * 0.02),
                    child: Row(
                      children: [
                        // profile icon
                        Container(
                          child: Icon(
                            Icons.account_circle_rounded,
                            size: 100,
                            color: Constants.COLOR_MIDNIGHT_BLUE,
                          ),
                        ),

                        Container(
                          margin: EdgeInsets.only(left: screenWidth * 0.02),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: screenWidth * 0.55,
                                child: _loadState == LoadState.Loading ? Shimmer.fromColors(
                                  baseColor: Constants.COLOR_SILVER_LIGHTER,
                                  highlightColor: Constants.COLOR_WHITE,
                                  child: Container(
                                    height: screenHeight * 0.034,
                                    decoration: BoxDecoration(
                                      color: Constants.COLOR_SILVER_LIGHTER,
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                  ),
                                ) : TextFormField(
                                  controller: _nameController..text = _nameText,
                                  style: Constants.TEXT_STYLE_PROFILE_NAME_TEXT,
                                  enabled: _editMode,
                                  validator: (value) {
                                    if (value.length == 0) {
                                      return '* Required';
                                    }

                                    return null;
                                  },
                                  onChanged: (newValue) => {
                                    _nameText = _nameController.text,
                                  },
                                  decoration: InputDecoration(
                                    isDense: true,
                                    disabledBorder: InputBorder.none,
                                    focusedBorder: UnderlineInputBorder(),
                                    enabledBorder: UnderlineInputBorder(),
                                    contentPadding: EdgeInsets.zero,
                                    hintText: 'Full Name',
                                    hintStyle: Constants.TEXT_STYLE_INPUT_HINT_3,
                                  ),
                                ),
                              ),

                              Container(

                                child: _loadState == LoadState.Loading ? Shimmer.fromColors(
                                  baseColor: Constants.COLOR_SILVER_LIGHTER,
                                  highlightColor: Constants.COLOR_WHITE,
                                  child: Container(
                                    margin: EdgeInsets.only(top: screenHeight * 0.01),
                                    width: screenWidth * 0.3,
                                    height: screenHeight * 0.034,
                                    decoration: BoxDecoration(
                                      color: Constants.COLOR_SILVER_LIGHTER,
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                  ),
                                ) : ElevatedButton.icon(
                                  label: Text(
                                    'My QR Code',
                                    style: Constants.TEXT_STYLE_DETAILS_ACTION_BUTTON_TEXT,
                                  ),
                                  icon: Icon(
                                    Icons.qr_code_rounded,
                                    color: Constants.COLOR_WHITE,
                                  ),
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<Color>(Constants.COLOR_BLUE_MEDIUM_STATE),
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50.0),
                                      ),
                                    ),
                                  ),
                                  onPressed: () => _navigateToMyQrPage(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 2nd section
                  Container(
                    margin: EdgeInsets.only(top: screenHeight * 0.015),
                    padding: EdgeInsets.only(bottom: screenHeight * 0.015),
                    width: screenWidth,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.0),
                      color: Constants.COLOR_WHITE,
                      boxShadow: [
                        BoxShadow(
                          color: Constants.COLOR_GRAY_BOX_SHADOW,
                          offset: Offset(0.0, 5.0),
                          blurRadius: 4.0,
                          spreadRadius: 1.0,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: screenWidth,
                          padding: EdgeInsets.symmetric(vertical: screenHeight * 0.015, horizontal: screenWidth * 0.04),
                          decoration: BoxDecoration(
                            color: Constants.COLOR_MAGNOLIA,
                            borderRadius: BorderRadius.vertical(top: Radius.circular(6.0)),
                          ),
                          child: Text(
                            'Personal Details',
                            style: Constants.TEXT_STYLE_HEADING_3,
                          ),
                        ),

                        // 1st - tp number
                        Container(
                          padding: EdgeInsets.fromLTRB(screenWidth * 0.04, screenHeight * 0.022, screenWidth * 0.04, 0.0),
                          child: _loadState == LoadState.Loading ? Shimmer.fromColors(
                            baseColor: Constants.COLOR_SILVER_LIGHTER,
                            highlightColor: Constants.COLOR_WHITE,
                            child: Container(
                              height: screenHeight * 0.028,
                              decoration: BoxDecoration(
                                color: Constants.COLOR_SILVER_LIGHTER,
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                            ),
                          ) : TextFormField(
                            controller: _tpNumberController..text = _tpNumberText,
                            style: Constants.TEXT_STYLE_INPUT_TEXT_2,
                            enabled: false,
                            onChanged: (newValue) => {
                              _tpNumberText = _tpNumberController.text,
                            },
                            decoration: InputDecoration(
                              isCollapsed: true,
                              disabledBorder: InputBorder.none,
                              focusedBorder: UnderlineInputBorder(),
                              enabledBorder: UnderlineInputBorder(),
                              hintText: 'TP Number',
                              hintStyle: Constants.TEXT_STYLE_INPUT_HINT_3,
                              icon: Icon(Icons.badge,
                                color: Constants.COLOR_ILLUMINATING_EMERALD,
                                size: 25,
                              ),
                            ),
                          ),
                        ),

                        // 2nd - email
                        Container(
                          padding: EdgeInsets.fromLTRB(screenWidth * 0.04, screenHeight * 0.023, screenWidth * 0.04, 0.0),
                          child: _loadState == LoadState.Loading ? Shimmer.fromColors(
                            baseColor: Constants.COLOR_SILVER_LIGHTER,
                            highlightColor: Constants.COLOR_WHITE,
                            child: Container(
                              height: screenHeight * 0.028,
                              decoration: BoxDecoration(
                                color: Constants.COLOR_SILVER_LIGHTER,
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                            ),
                          ) : TextFormField(
                            controller: _emailController..text = _emailText,
                            style: Constants.TEXT_STYLE_INPUT_TEXT_2,
                            enabled: _editMode,
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (newValue) => {
                              _emailText = _emailController.text,
                            },
                            validator: (value) {
                              if (value.length == 0) {
                                return '* Required';
                              }

                              if (!EmailValidator.validate(value)) {
                                return 'Email is invalid.';
                              }

                              return null;
                            },
                            decoration: InputDecoration(
                              isCollapsed: true,
                              disabledBorder: InputBorder.none,
                              focusedBorder: UnderlineInputBorder(),
                              enabledBorder: UnderlineInputBorder(),
                              hintText: 'Email Address',
                              hintStyle: Constants.TEXT_STYLE_INPUT_HINT_3,
                              icon: Icon(Icons.mail_rounded,
                                color: Constants.COLOR_ORANGE_PANTONE,
                                size: 25,
                              ),
                            ),
                          ),
                        ),

                        // 3rd - contact number
                        Container(
                          padding: EdgeInsets.fromLTRB(screenWidth * 0.04, screenHeight * 0.023, screenWidth * 0.04, 0.0),
                          child: _loadState == LoadState.Loading ? Shimmer.fromColors(
                            baseColor: Constants.COLOR_SILVER_LIGHTER,
                            highlightColor: Constants.COLOR_WHITE,
                            child: Container(
                              height: screenHeight * 0.028,
                              decoration: BoxDecoration(
                                color: Constants.COLOR_SILVER_LIGHTER,
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                            ),
                          ) : TextFormField(
                            controller: _contactNumberController..text = _contactNumberText,
                            style: Constants.TEXT_STYLE_INPUT_TEXT_2,
                            enabled: _editMode,
                            keyboardType: TextInputType.number,
                            onChanged: (newValue) => {
                              _contactNumberText = _contactNumberController.text,
                            },
                            validator: (value) {
                              if (value.length == 0) {
                                return "* Required";
                              }

                              if (value.length > 15 || value.length < 8) {
                                return "Phone number is invalid. e.g. 60123456789 / +60123456789";
                              }

                              return null;
                            },
                            decoration: InputDecoration(
                              isCollapsed: true,
                              disabledBorder: InputBorder.none,
                              focusedBorder: UnderlineInputBorder(),
                              enabledBorder: UnderlineInputBorder(),
                              hintText: 'Contact Number',
                              hintStyle: Constants.TEXT_STYLE_INPUT_HINT_3,
                              icon: Icon(Icons.call_rounded,
                                color: Constants.COLOR_ROYAL_PURPLE,
                                size: 25,
                              ),
                            ),
                          ),
                        ),

                        // 4th - school / department
                        Container(
                          padding: EdgeInsets.fromLTRB(screenWidth * 0.04, screenHeight * 0.023, screenWidth * 0.04, screenHeight * 0.01),
                          child: _loadState == LoadState.Loading ? Shimmer.fromColors(
                            baseColor: Constants.COLOR_SILVER_LIGHTER,
                            highlightColor: Constants.COLOR_WHITE,
                            child: Container(
                              height: screenHeight * 0.028,
                              decoration: BoxDecoration(
                                color: Constants.COLOR_SILVER_LIGHTER,
                                borderRadius: BorderRadius.circular(16.0),
                              ),
                            ),
                          ) : DropdownButtonFormField(
                            hint: Text(
                              _schoolDepartmentText,
                              style: Constants.TEXT_STYLE_INPUT_TEXT_2,
                            ),
                            value: _currentSelectedSchoolDepartment,
                            items: !_editMode ? null : _schoolDepartmentString.map((String item) {
                              var part = item.split(',');
                              return DropdownMenuItem<String>(
                                child: Text(
                                  part[1],
                                  style: Constants.TEXT_STYLE_INPUT_TEXT_2,
                                ),
                                value: part[0],
                              );
                            }).toList(),
                            onChanged: (newValue) => _schoolDepartmentDropdownHandler(newValue),
                            style: Constants.TEXT_STYLE_INPUT_HINT_1,
                            isExpanded: true,
                            decoration: InputDecoration(
                              isCollapsed: true,
                              focusedBorder: UnderlineInputBorder(),
                              enabledBorder: !_editMode ? InputBorder.none : UnderlineInputBorder(),
                              hintStyle: Constants.TEXT_STYLE_INPUT_TEXT_2,
                              icon: Icon(Icons.school_rounded ,
                                color: Constants.COLOR_MIDNIGHT_BLUE,
                                size: 25,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 3rd section
                  Container(
                    margin: EdgeInsets.only(top: screenHeight * 0.02),
                    padding: EdgeInsets.only(bottom: screenHeight * 0.015),
                    width: screenWidth,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.0),
                      color: Constants.COLOR_WHITE,
                      boxShadow: [
                        BoxShadow(
                          color: Constants.COLOR_GRAY_BOX_SHADOW,
                          offset: Offset(0.0, 5.0),
                          blurRadius: 4.0,
                          spreadRadius: 1.0,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: screenWidth,
                          padding: EdgeInsets.symmetric(vertical: screenHeight * 0.015, horizontal: screenWidth * 0.04),
                          decoration: BoxDecoration(
                            color: Constants.COLOR_MAGNOLIA,
                            borderRadius: BorderRadius.vertical(top: Radius.circular(6.0)),
                          ),
                          child: Text(
                            'Password',
                            style: Constants.TEXT_STYLE_HEADING_3,
                          ),
                        ),

                        // 5th - password
                        Container(
                          padding: EdgeInsets.fromLTRB(screenWidth * 0.04, screenHeight * 0.02, screenWidth * 0.04, 0.0),
                          child: Row(
                            children: [
                              Container(
                                width: screenWidth * 0.37,
                                child: Text(
                                  'Password: ',
                                  style: Constants.TEXT_STYLE_DETAILS_PASSAGE_CONTENT_2,
                                ),
                              ),

                              Container(
                                width: screenWidth * 0.4,
                                child: _loadState == LoadState.Loading ? Shimmer.fromColors(
                                  baseColor: Constants.COLOR_SILVER_LIGHTER,
                                  highlightColor: Constants.COLOR_WHITE,
                                  child: Container(
                                    height: screenHeight * 0.028,
                                    decoration: BoxDecoration(
                                      color: Constants.COLOR_SILVER_LIGHTER,
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                  ),
                                ) : TextFormField(
                                  controller: _passwordController..text = _passwordText,
                                  style: Constants.TEXT_STYLE_INPUT_TEXT_2,
                                  obscureText: true,
                                  enabled: _editMode,
                                  onChanged: (newValue) => {
                                    _passwordText = _passwordController.text,
                                  },
                                  onTap: () {
                                    _passwordText = '';
                                  },
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
                                    isCollapsed: true,
                                    disabledBorder: InputBorder.none,
                                    focusedBorder: UnderlineInputBorder(),
                                    enabledBorder: UnderlineInputBorder(),
                                    hintText: 'Password',
                                    hintStyle: Constants.TEXT_STYLE_INPUT_HINT_3,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // 6th - confirm password
                        Container(
                          padding: EdgeInsets.fromLTRB(screenWidth * 0.04, screenHeight * 0.023, screenWidth * 0.04, screenHeight * 0.01),
                          child: Row(
                            children: [
                              Container(
                                width: screenWidth * 0.37,
                                child: Text(
                                  'Confirm Password: ',
                                  style: Constants.TEXT_STYLE_DETAILS_PASSAGE_CONTENT_2,
                                ),
                              ),

                              Container(
                                width: screenWidth * 0.4,
                                child: _loadState == LoadState.Loading ? Shimmer.fromColors(
                                  baseColor: Constants.COLOR_SILVER_LIGHTER,
                                  highlightColor: Constants.COLOR_WHITE,
                                  child: Container(
                                    height: screenHeight * 0.028,
                                    decoration: BoxDecoration(
                                      color: Constants.COLOR_SILVER_LIGHTER,
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                  ),
                                ) : TextFormField(
                                  controller: _confirmPasswordController..text = _confirmPasswordText,
                                  style: Constants.TEXT_STYLE_INPUT_TEXT_2,
                                  obscureText: true,
                                  enabled: _editMode,
                                  onChanged: (newValue) => {
                                    _confirmPasswordText = _confirmPasswordController.text,
                                  },
                                  onTap: () {
                                    _confirmPasswordText = '';
                                  },
                                  validator: (value) {
                                    if (value.length == 0) {
                                      return "* Required";
                                    }

                                    if (value != _passwordText) {
                                      return 'Password is different.';
                                    }

                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    isCollapsed: true,
                                    disabledBorder: InputBorder.none,
                                    focusedBorder: UnderlineInputBorder(),
                                    enabledBorder: UnderlineInputBorder(),
                                    hintText: 'Confirm Password',
                                    hintStyle: Constants.TEXT_STYLE_INPUT_HINT_3,
                                  ),
                                ),
                              ),
                            ],
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
      ),
    );
  }
}