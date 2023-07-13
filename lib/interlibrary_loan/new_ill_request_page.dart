import 'package:ap_lib/authenticate/authentication_handler.dart';
import 'package:ap_lib/user/user_data_fetcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:ap_lib/user/user_details_model.dart';
import 'ill_data_provider.dart';
import 'complete_ill_request_page.dart';
import 'package:email_validator/email_validator.dart';
import '../constants.dart';

class NewIllRequestPage extends StatefulWidget {
  @override
  _NewIllRequestPageState createState() => _NewIllRequestPageState();
}

class _NewIllRequestPageState extends State<NewIllRequestPage> {
  DateFormat _dateFormatter;
  UserDataFetcher _userDataFetcher;

  TextEditingController _nameController = new TextEditingController();
  TextEditingController _tpNumberController = new TextEditingController();
  TextEditingController _applicationDateController = new TextEditingController();
  TextEditingController _schoolDepartmentController = new TextEditingController();
  TextEditingController _contactNumberController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _titleController = new TextEditingController();
  TextEditingController _authorController = new TextEditingController();
  TextEditingController _publishingYearController = new TextEditingController();
  TextEditingController _publishingCityController = new TextEditingController();
  TextEditingController _publisherController = new TextEditingController();
  TextEditingController _editionController = new TextEditingController();
  TextEditingController _isbnController = new TextEditingController();
  TextEditingController _callNumberController = new TextEditingController();
  TextEditingController _organisationController = new TextEditingController();

  var _formKey = GlobalKey<FormState>();

  List<UserDetailsModel> _userDetailsList = [];

  ButtonState _submitState = ButtonState.idle;

  Future<List<UserDetailsModel>> _fetchUserDetails() async {
    String userToken = await new AuthenticationHandler().getToken();
    return await _userDataFetcher.getUserDetails(userToken);
  }

  void _submitIllRequest(String requestDateTime,
      String email, String contactNumber, String title, String author, String year,
      String city, String publisher, String edition, String isbn, String callNumber,
      String organisation) async {
    IllDataProvider _illDataProvider = new IllDataProvider();
    String userToken = await new AuthenticationHandler().getToken();
    
    if (_formKey.currentState.validate()) {
      switch (_submitState) {
        case ButtonState.idle:
          setState(() {
            _submitState = ButtonState.loading;
          });

          _illDataProvider.createNewIllRequest(
              requestDateTime,
              email,
              contactNumber,
              title,
              author,
              year,
              city,
              publisher,
              edition,
              isbn,
              callNumber,
              organisation,
              userToken).then((statusString) =>
          {
            print(statusString),

            if (statusString == "success") {
              setState(() {
                _submitState = ButtonState.success;
              }),
              Navigator.push(
                context,
                CupertinoPageRoute(builder: (context) =>
                    CompleteIllRequestPage(
                      bookTitle: title,
                      organisation: organisation,
                    )),
              )
            } else
              {
                setState(() {
                  _submitState = ButtonState.fail;
                }),
              }
          });
          break;
        case ButtonState.loading:
          break;
        case ButtonState.success:
          _submitState = ButtonState.idle;
          break;
        case ButtonState.fail:
          _submitState = ButtonState.idle;
          Future.delayed(Duration(seconds: 1), () {
            setState(() {
              _submitState = ButtonState.idle;
            });
          });
          break;
      }
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

  @override
  void initState() {
    super.initState();
    _userDataFetcher = new UserDataFetcher();
    _dateFormatter = new DateFormat('dd MMM yyyy');

    _fetchUserDetails().then((list) => {
      setState(() {
        _userDetailsList = list;
      })
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: BouncingScrollPhysics(),
          child: Container(
            padding: EdgeInsets.fromLTRB(screenWidth * 0.05, screenHeight * 0.02, screenWidth * 0.05, 0.0),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.always,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // page title
                  Container(
                    child: Text(
                      'Submit ILL Request',
                      style: Constants.TEXT_STYLE_HEADING_1,
                    ),
                  ),

                  // requestor's details section title
                  Container(
                    padding: EdgeInsets.only(top: screenHeight * 0.015),
                    child: Text(
                      'Requestor\'s Details',
                      style: Constants.TEXT_STYLE_HEADING_2,
                    ),
                  ),

                  // 1st - name field
                  Container(
                    padding: EdgeInsets.only(top: screenHeight * 0.02),
                    child: TextFormField(
                      controller: _nameController,
                      style: TextStyle(
                        fontSize: 20
                      ),
                      enabled: false,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Constants.COLOR_PLATINUM_LIGHT,
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: Constants.COLOR_GRAY_LIGHT,
                            width: 1.5
                          )
                        ),
                        hintText: _userDetailsList.length == 0 ? '' : _userDetailsList[0].fullName.toUpperCase(),
                        hintStyle: Constants.TEXT_STYLE_INPUT_HINT_3,
                        prefixIcon: Icon(Icons.person_rounded,
                          color: Constants.COLOR_GRAY_LIGHT,
                          size: 25,
                        ),
                      ),
                    ),
                  ),

                  // 2nd - tp number field
                  Container(
                    padding: EdgeInsets.only(top: screenHeight * 0.02),
                    child: TextFormField(
                      controller: _tpNumberController,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                      enabled: false,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Constants.COLOR_PLATINUM_LIGHT,
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: Constants.COLOR_GRAY_LIGHT,
                            width: 1.5,
                          ),
                        ),
                        hintText: _userDetailsList.length == 0 ? '' : _userDetailsList[0].tpNumber.toUpperCase(),
                        hintStyle: Constants.TEXT_STYLE_INPUT_HINT_3,
                        prefixIcon: Icon(Icons.badge,
                          color: Constants.COLOR_GRAY_LIGHT,
                          size: 25,
                        ),
                      ),
                    ),
                  ),

                  // 3rd - application date field
                  Container(
                    padding: EdgeInsets.only(top: screenHeight * 0.02),
                    child: TextFormField(
                      controller: _applicationDateController,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                      enabled: false,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Constants.COLOR_PLATINUM_LIGHT,
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: Constants.COLOR_GRAY_LIGHT,
                            width: 1.5,
                          ),
                        ),
                        hintText: _dateFormatter.format(DateTime.now()),
                        hintStyle: Constants.TEXT_STYLE_INPUT_HINT_3,
                        prefixIcon: Icon(Icons.event_rounded,
                          color: Constants.COLOR_GRAY_LIGHT,
                          size: 25,
                        ),
                      ),
                    ),
                  ),

                  // 4th - school/department field
                  Container(
                    padding: EdgeInsets.only(top: screenHeight * 0.02),
                    child: TextFormField(
                      controller: _schoolDepartmentController,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                      enabled: false,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Constants.COLOR_PLATINUM_LIGHT,
                        disabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: Constants.COLOR_GRAY_LIGHT,
                            width: 1.5,
                          ),
                        ),
                        hintText: _userDetailsList.length == 0 ? '' : _userDetailsList[0].schoolDepartment,
                        hintStyle: Constants.TEXT_STYLE_INPUT_HINT_3,
                        prefixIcon: Icon(Icons.school_rounded,
                          color: Constants.COLOR_GRAY_LIGHT,
                          size: 25,
                        ),
                      ),
                    ),
                  ),

                  // 5th - contact number field
                  Container(
                    padding: EdgeInsets.only(top: screenHeight * 0.02),
                    child: TextFormField(
                      controller: _contactNumberController..text = _userDetailsList.length == 0 ? '' : _userDetailsList[0].contactNumber,
                      style: Constants.TEXT_STYLE_INPUT_TEXT_1,
                      keyboardType: TextInputType.number,
                      enabled: true,
                      onChanged: (newValue) => {
                        _userDetailsList[0].contactNumber = _contactNumberController.text,
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
                        helperStyle: Constants.TEXT_STYLE_INVALID_INPUT_TEXT,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: Constants.COLOR_GRAY_LIGHT,
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: Constants.COLOR_GRAY_LIGHT,
                            width: 1.5,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: Constants.COLOR_GRAY_LIGHT,
                            width: 1.5,
                          ),
                        ),
                        hintText: 'Contact Number',
                        hintStyle: Constants.TEXT_STYLE_INPUT_HINT_3,
                        prefixIcon: Icon(Icons.call_rounded,
                          color: Constants.COLOR_GRAY_LIGHT,
                          size: 25,
                        ),
                      ),
                    ),
                  ),

                  // 6th - email field
                  Container(
                    padding: EdgeInsets.only(top: screenHeight * 0.02),
                    child: TextFormField(
                      controller: _emailController..text = _userDetailsList.length == 0 ? '' : _userDetailsList[0].email.toLowerCase(),
                      style: Constants.TEXT_STYLE_INPUT_TEXT_1,
                      keyboardType: TextInputType.emailAddress,
                      enabled: true,
                      onChanged: (newValue) => {
                        _userDetailsList[0].email = _emailController.text.toLowerCase(),
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
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: Constants.COLOR_GRAY_LIGHT,
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: Constants.COLOR_GRAY_LIGHT,
                            width: 1.5,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: Constants.COLOR_GRAY_LIGHT,
                            width: 1.5,
                          ),
                        ),
                        hintText: 'Email Address',
                        hintStyle: Constants.TEXT_STYLE_INPUT_HINT_3,
                        prefixIcon: Icon(Icons.mail_rounded,
                          color: Constants.COLOR_GRAY_LIGHT,
                          size: 25,
                        ),
                      ),
                    ),
                  ),

                  // resource details section title
                  Container(
                    padding: EdgeInsets.only(top: screenHeight * 0.035),
                    child: Text(
                      'Resource Details',
                      style: Constants.TEXT_STYLE_HEADING_2,
                    ),
                  ),

                  // 1st - book title field
                  Container(
                    padding: EdgeInsets.only(top: screenHeight * 0.02),
                    child: TextFormField(
                      controller: _titleController,
                      style: Constants.TEXT_STYLE_INPUT_TEXT_1,
                      enabled: true,
                      validator: (value) {
                        if (value.length == 0) {
                          return '* Required';
                        }

                        return null;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: Constants.COLOR_GRAY_LIGHT,
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: Constants.COLOR_GRAY_LIGHT,
                            width: 1.5,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: Constants.COLOR_GRAY_LIGHT,
                            width: 1.5,
                          ),
                        ),
                        hintText: 'Book Title',
                        hintStyle: Constants.TEXT_STYLE_INPUT_HINT_3,
                        prefixIcon: Icon(Icons.title_rounded,
                          color: Constants.COLOR_GRAY_LIGHT,
                          size: 25,
                        ),
                      ),
                    ),
                  ),

                  // 2nd - author field
                  Container(
                    padding: EdgeInsets.only(top: screenHeight * 0.02),
                    child: TextFormField(
                      controller: _authorController,
                      style: Constants.TEXT_STYLE_INPUT_TEXT_1,
                      enabled: true,
                      validator: (value) {
                        if (value.length == 0) {
                          return '* Required';
                        }

                        return null;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: Constants.COLOR_GRAY_LIGHT,
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: Constants.COLOR_GRAY_LIGHT,
                            width: 1.5,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: Constants.COLOR_GRAY_LIGHT,
                            width: 1.5,
                          ),
                        ),
                        hintText: 'Author(s)',
                        hintStyle: Constants.TEXT_STYLE_INPUT_HINT_3,
                        prefixIcon: Icon(Icons.history_edu_rounded,
                          color: Constants.COLOR_GRAY_LIGHT,
                          size: 25,
                        ),
                      ),
                    ),
                  ),

                  // 3rd - year of publication field
                  Container(
                    padding: EdgeInsets.only(top: screenHeight * 0.02),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: _publishingYearController,
                      style: Constants.TEXT_STYLE_INPUT_TEXT_1,
                      enabled: true,
                      validator: (value) {
                        if (value.length == 0) {
                          return '* Required';
                        }

                        return null;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: Constants.COLOR_GRAY_LIGHT,
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: Constants.COLOR_GRAY_LIGHT,
                            width: 1.5,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: Constants.COLOR_GRAY_LIGHT,
                            width: 1.5,
                          ),
                        ),
                        hintText: 'Year of Publication',
                        hintStyle: Constants.TEXT_STYLE_INPUT_HINT_3,
                        prefixIcon: Icon(Icons.event_rounded,
                          color: Constants.COLOR_GRAY_LIGHT,
                          size: 25,
                        ),
                      ),
                    ),
                  ),

                  // 4th - place of publication field
                  Container(
                    padding: EdgeInsets.only(top: screenHeight * 0.02),
                    child: TextFormField(
                      controller: _publishingCityController,
                      style: Constants.TEXT_STYLE_INPUT_TEXT_1,
                      enabled: true,
                      validator: (value) {
                        if (value.length == 0) {
                          return '* Required';
                        }

                        return null;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: Constants.COLOR_GRAY_LIGHT,
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: Constants.COLOR_GRAY_LIGHT,
                            width: 1.5,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: Constants.COLOR_GRAY_LIGHT,
                            width: 1.5,
                          ),
                        ),
                        hintText: 'Place of publication',
                        hintStyle: Constants.TEXT_STYLE_INPUT_HINT_3,
                        prefixIcon: Icon(Icons.location_on_rounded,
                          color: Constants.COLOR_GRAY_LIGHT,
                          size: 25,
                        ),
                      ),
                    ),
                  ),

                  // 5th - publisher field
                  Container(
                    padding: EdgeInsets.only(top: screenHeight * 0.02),
                    child: TextFormField(
                      controller: _publisherController,
                      style: Constants.TEXT_STYLE_INPUT_TEXT_1,
                      enabled: true,
                      validator: (value) {
                        if (value.length == 0) {
                          return '* Required';
                        }

                        return null;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: Constants.COLOR_GRAY_LIGHT,
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: Constants.COLOR_GRAY_LIGHT,
                            width: 1.5,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: Constants.COLOR_GRAY_LIGHT,
                            width: 1.5,
                          ),
                        ),
                        hintText: 'Publisher',
                        hintStyle: Constants.TEXT_STYLE_INPUT_HINT_3,
                        prefixIcon: Icon(Icons.print_rounded,
                          color: Constants.COLOR_GRAY_LIGHT,
                          size: 25,
                        ),
                      ),
                    ),
                  ),

                  // 6th - edition field
                  Container(
                    padding: EdgeInsets.only(top: screenHeight * 0.02),
                    child: TextFormField(
                      controller: _editionController,
                      style: Constants.TEXT_STYLE_INPUT_TEXT_1,
                      keyboardType: TextInputType.number,
                      enabled: true,
                      validator: (value) {
                        if (value.length == 0) {
                          return '* Required';
                        }

                        return null;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: Constants.COLOR_GRAY_LIGHT,
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: Constants.COLOR_GRAY_LIGHT,
                            width: 1.5,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: Constants.COLOR_GRAY_LIGHT,
                            width: 1.5,
                          ),
                        ),
                        hintText: 'Edition',
                        hintStyle: Constants.TEXT_STYLE_INPUT_HINT_3,
                        prefixIcon: Icon(Icons.tag,
                          color: Constants.COLOR_GRAY_LIGHT,
                          size: 25,
                        ),
                      ),
                    ),
                  ),

                  // 7th - isbn field
                  Container(
                    padding: EdgeInsets.only(top: screenHeight * 0.02),
                    child: TextFormField(
                      controller: _isbnController,
                      style: Constants.TEXT_STYLE_INPUT_TEXT_1,
                      enabled: true,
                      validator: (value) {
                        if (value.length == 0) {
                          return '* Required';
                        }

                        return null;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: Constants.COLOR_GRAY_LIGHT,
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: Constants.COLOR_GRAY_LIGHT,
                            width: 1.5,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: Constants.COLOR_GRAY_LIGHT,
                            width: 1.5,
                          ),
                        ),
                        hintText: 'ISBN',
                        hintStyle: Constants.TEXT_STYLE_INPUT_HINT_3,
                        prefixIcon: Icon(Icons.confirmation_number_rounded ,
                          color: Constants.COLOR_GRAY_LIGHT,
                          size: 25,
                        ),
                      ),
                    ),
                  ),

                  // 8th - call number field
                  Container(
                    padding: EdgeInsets.only(top: screenHeight * 0.02),
                    child: TextField(
                      controller: _callNumberController,
                      style: Constants.TEXT_STYLE_INPUT_TEXT_1,
                      enabled: true,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: Constants.COLOR_GRAY_LIGHT,
                            width: 1.5,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: Constants.COLOR_GRAY_LIGHT,
                            width: 1.5,
                          ),
                        ),
                        hintText: 'Call Number',
                        hintStyle: Constants.TEXT_STYLE_INPUT_HINT_3,
                        prefixIcon: Icon(Icons.push_pin_rounded ,
                          color: Constants.COLOR_GRAY_LIGHT,
                          size: 25,
                        ),
                      ),
                    ),
                  ),

                  // 9th - target organisation field
                  Container(
                    padding: EdgeInsets.only(top: screenHeight * 0.02),
                    child: TextFormField(
                      controller: _organisationController,
                      style: Constants.TEXT_STYLE_INPUT_TEXT_1,
                      enabled: true,
                      validator: (value) {
                        if (value.length == 0) {
                          return '* Required';
                        }

                        return null;
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: Constants.COLOR_GRAY_LIGHT,
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: Constants.COLOR_GRAY_LIGHT,
                            width: 1.5,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: Constants.COLOR_GRAY_LIGHT,
                            width: 1.5,
                          ),
                        ),
                        hintText: 'Target Organisation / University',
                        hintStyle: Constants.TEXT_STYLE_INPUT_HINT_3,
                        prefixIcon: Icon(Icons.apartment_rounded ,
                          color: Constants.COLOR_GRAY_LIGHT,
                          size: 25,
                        ),
                      ),
                    ),
                  ),

                  // special note section title
                  Container(
                    padding: EdgeInsets.only(top: screenHeight * 0.035),
                    child: Text(
                      'Special Note',
                      style: Constants.TEXT_STYLE_HEADING_2,
                    ),
                  ),

                  // special note contents
                  Container(
                    padding: EdgeInsets.only(top: screenHeight * 0.02),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'According to Section 9(4) read together with Section 41(1)(i) ' +
                                'of the Malaysian Copyright Act 1987, you may make minimal copies of ' +
                                'printed materials for non-profit research',
                            style: Constants.TEXT_STYLE_SUB_HEADING_1,
                          ),
                          TextSpan(
                            text: ' and ',
                            style: Constants.TEXT_STYLE_SUB_HEADING_BOLD_1,
                          ),
                          TextSpan(
                            text: 'must acknowledge the source.',
                            style: Constants.TEXT_STYLE_SUB_HEADING_1,
                          ),
                        ],
                      ),
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.symmetric(vertical: screenHeight * 0.05),
                    child: ProgressButton(
                      minWidth: screenWidth - (screenWidth * 0.05) * 2,
                      onPressed: () => _submitIllRequest(
                        DateTime.now().toUtc().millisecondsSinceEpoch.toString().substring(0, 10),
                        _emailController.text == '' ? ' ' : _emailController.text,
                        _contactNumberController.text == '' ? ' ' : _contactNumberController.text,
                        _titleController.text == '' ? ' ' : _titleController.text,
                        _authorController.text == '' ? ' ' : _authorController.text,
                        _publishingYearController.text == '' ? ' ' : _publishingYearController.text,
                        _publishingCityController.text == '' ? ' ' : _publishingCityController.text,
                        _publisherController.text == '' ? ' ' : _publisherController.text,
                        _editionController.text == '' ? ' ' : _editionController.text,
                        _isbnController.text == '' ? ' ' : _isbnController.text,
                        _callNumberController.text == '' ? ' ' : _callNumberController.text,
                        _organisationController.text == '' ? ' ' : _organisationController.text
                      ),
                      progressIndicatorAligment: MainAxisAlignment.center,
                      progressIndicatorSize: 25.0,
                      state: _submitState,
                      padding: EdgeInsets.all(8.0),
                      stateWidgets: {
                        ButtonState.idle: Text(
                          "Submit Request",
                          style: Constants.TEXT_STYLE_BUTTON_TEXT,
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
                                  style: Constants.TEXT_STYLE_BUTTON_TEXT,
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
                                  style: Constants.TEXT_STYLE_BUTTON_TEXT,
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}