import 'dart:async';

import 'package:ap_lib/authenticate/authentication_handler.dart';
import 'package:ap_lib/reading_history/reading_history_data_provider.dart';
import 'package:ap_lib/search_catalogue/book_details_page.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:progress_state_button/progress_button.dart';
import 'complete_loan_page.dart';
import '../constants.dart';

class ScanResultPage extends StatefulWidget {
  final String itemId;
  final Image bookImage;
  final String bookTitle;
  final String bookAuthor;
  final String tagName;
  final String availabilityStatus;

  ScanResultPage({
    @required this.itemId,
    @required this.bookImage,
    @required this.bookTitle,
    @required this.bookAuthor,
    @required this.tagName,
    @required this.availabilityStatus,
  });

  @override
  _ScanResultPageState createState() => _ScanResultPageState();
}

class _ScanResultPageState extends State<ScanResultPage> {
  ButtonState _loanState = ButtonState.idle;

  DateFormat _dateTimeFormatter;

  Timer _timer;

  DateTime _loanDateTime;
  DateTime _dueDateTime;

  void _confirmLoaning(String itemId, String loanDateTime, String dueDateTime, String tag) async {
    ReadingHistoryDataProvider _readingHistoryDataProvider = new ReadingHistoryDataProvider();
    String userToken = await new AuthenticationHandler().getToken();

    switch(_loanState) {
      case ButtonState.idle:
        setState(() {
          _loanState = ButtonState.loading;
        });

        _readingHistoryDataProvider.createLoanRecord(userToken, itemId, loanDateTime, dueDateTime, tag).then((statusString) => {
          print(statusString),
          // Navigator.of(context).pop(),
          if (statusString == "success") {
            setState(() {
              _loanState = ButtonState.success;
            }),
            Navigator.push(
              context,
              CupertinoPageRoute(builder: (context) => CompleteLoanPage(
                title: widget.bookTitle,
                dueDateTime: _dueDateTime,
                loanDateTime: _loanDateTime,
              )),
            ),
            print("success"),
          } else if (statusString == "role not available") {
            setState(() {
              _loanState = ButtonState.fail;
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(
                    "Loan Failed",
                    style: Constants.TEXT_STYLE_DIALOG_TITLE_AND_ACTION_1,
                  ),
                  content: Text(
                    "It's a green-tagged material, you are not eligible to loan the material.",
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
            }),
          } else if (statusString == "exceed limit") {
            setState(() {
              _loanState = ButtonState.fail;
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(
                    "Loan Failed",
                    style: Constants.TEXT_STYLE_DIALOG_TITLE_AND_ACTION_1,
                  ),
                  content: Text(
                    "You have exceeded your loan limit.",
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
            }),
          } else if (statusString == "outstanding fine") {
            setState(() {
              _loanState = ButtonState.fail;
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(
                    "Loan Failed",
                    style: Constants.TEXT_STYLE_DIALOG_TITLE_AND_ACTION_1,
                  ),
                  content: Text(
                    "You have outstanding fine to pay.",
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
            }),
          }
        });
        break;
      case ButtonState.loading:
        break;
      case ButtonState.success:
        _loanState = ButtonState.idle;
        break;
      case ButtonState.fail:
        _loanState = ButtonState.idle;
        Future.delayed(Duration(seconds: 1), () {
          setState(() {
            _loanState = ButtonState.idle;
          });
        });
        break;
    }
  }

  void _loanMaterialButtonHandler(String bookTitle) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Confirm Loaning?",
          style: Constants.TEXT_STYLE_DIALOG_TITLE_AND_ACTION_1,
        ),
        content: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Press ',
                style: Constants.TEXT_STYLE_DIALOG_CONTENT,
              ),
              TextSpan(
                text: 'Confirm',
                style: Constants.TEXT_STYLE_DIALOG_CONTENT_BOLD,
              ),
              TextSpan(
                text: ' to complete the loaning of ',
                style: Constants.TEXT_STYLE_DIALOG_CONTENT,
              ),
              TextSpan(
                text: bookTitle,
                style: Constants.TEXT_STYLE_DIALOG_CONTENT_BOLD,
              ),
              TextSpan(
                text: '.',
                style: Constants.TEXT_STYLE_DIALOG_CONTENT,
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              "Cancel",
              style: Constants.TEXT_STYLE_DIALOG_TITLE_AND_ACTION_2,
            ),
          ),
          TextButton(
            onPressed: () {
              _confirmLoaning(widget.itemId, _loanDateTime.toUtc().millisecondsSinceEpoch.toString().substring(0, 10),
              _dueDateTime.toUtc().millisecondsSinceEpoch.toString().substring(0, 10), widget.tagName);
            },
            child: Text(
              "Confirm",
              style: Constants.TEXT_STYLE_DIALOG_TITLE_AND_ACTION_1,
            ),
          ),
        ],
      ),
    );
  }

  void _viewBookDetails(String itemId, Image bookImage) {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => BookDetailsPage(
        itemId: itemId,
        imageData: bookImage,
      )),
    );
  }

  DateTime _calculateDueDateTime(String tagName, DateTime loanDateTime) {
    if (tagName == 'Open') {
      return _loanDateTime.add(Duration(days: 7));
    } else if (tagName == 'Yellow') {
      return _loanDateTime.add(Duration(days: 3));
    } else if (tagName == 'Red') {
      return _loanDateTime.add(Duration(days: 1));
    }

    return _loanDateTime.add(Duration(days: 120));
  }

  void _back(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();

    _dateTimeFormatter = new DateFormat('dd MMM yyyy,').add_jms();
    _loanDateTime = DateTime.now();
    _dueDateTime = _calculateDueDateTime(widget.tagName, _loanDateTime);

    _timer = new Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _loanDateTime = DateTime.now();
          _dueDateTime = _calculateDueDateTime(widget.tagName, _loanDateTime);
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
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
        child: Container(
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(screenWidth * 0.05, screenHeight * 0.02, screenWidth * 0.05, 0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // page title
                    Container(
                      width: screenWidth,
                      child: Text(
                        'Search Result:',
                        style: Constants.TEXT_STYLE_HEADING_1,
                      ),
                    ),

                    // book image
                    widget.itemId != '' ? Container(
                      margin: EdgeInsets.only(top: screenHeight * 0.03),
                      child: Row(
                        children: [
                          Hero(
                            tag: widget.itemId,
                            child: Container(
                              width: screenWidth * 0.32,
                              height: screenHeight * 0.22,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Constants.COLOR_GRAY_BOX_SHADOW,
                                    offset: Offset(0.0, 5.0),
                                    blurRadius: 5.0,
                                    spreadRadius: 1.0,
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16.0),
                                child: widget.bookImage,
                              ),
                            ),
                          ),

                          // book title, author and view details button
                          Container(
                            width: screenWidth - (screenWidth * 0.05 * 2) - (screenWidth * 0.32),
                            height: screenHeight * 0.22,
                            padding: EdgeInsets.only(left: screenWidth * 0.035),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // book title
                                Container(
                                  child: AutoSizeText(
                                    widget.bookTitle,
                                    minFontSize: 16,
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                    style: Constants.TEXT_STYLE_BOOK_DETAILS_TITLE,
                                  ),
                                ),

                                // book author
                                Container(
                                  padding: EdgeInsets.only(top: screenHeight * 0.005),
                                  child: Text(
                                    widget.bookAuthor,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: Constants.TEXT_STYLE_BOOK_DETAILS_AUTHOR,
                                  ),
                                ),

                                // locate material button
                                Container(
                                  padding: EdgeInsets.only(top: screenHeight * 0.01),
                                  child: ElevatedButton.icon(
                                    onPressed: () => _viewBookDetails(widget.itemId, widget.bookImage),
                                    label: Text(
                                      'View Details',
                                      style: Constants.TEXT_STYLE_DETAILS_ACTION_BUTTON_TEXT,
                                    ),
                                    icon: Icon(
                                      Icons.info_rounded,
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
                                    // style: TextButton.styleFrom(
                                    //   backgroundColor: Constants.COLOR_BLUE_MEDIUM_STATE,
                                    // ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ) : Container(
                      margin: EdgeInsets.only(top: screenHeight * 0.03),
                      child: Text(
                        'No result found.',
                        style: Constants.TEXT_STYLE_NON_ALTERNATIVE_TEXT,
                      ),
                    ),

                    // loan date
                    widget.availabilityStatus == 'Available' ? Container(
                      margin: EdgeInsets.only(top: screenHeight * 0.02),
                      child: RichText(
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Loan Date: ',
                              style: Constants.TEXT_STYLE_DETAILS_PASSAGE_CONTENT_SMALL_TITLE_2,
                            ),
                            TextSpan(
                              text: _dateTimeFormatter.format(_loanDateTime),
                              style: Constants.TEXT_STYLE_DETAILS_PASSAGE_CONTENT_3,
                            ),
                          ],
                        ),
                      ),
                    ) : Container(),

                    // due date
                    widget.availabilityStatus == 'Available' ? Container(
                      margin: EdgeInsets.only(top: screenHeight * 0.005),
                      child: RichText(
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Due Date: ',
                              style: Constants.TEXT_STYLE_DETAILS_PASSAGE_CONTENT_SMALL_TITLE_2,
                            ),
                            TextSpan(
                              text: _dateTimeFormatter.format(_dueDateTime),
                              style: Constants.TEXT_STYLE_DETAILS_PASSAGE_CONTENT_3,
                            ),
                          ],
                        ),
                      ),
                    ) : Container(),
                  ],
                ),
              ),

              widget.availabilityStatus == 'Available' ? Positioned(
                bottom: screenHeight * 0.05,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
                  width: screenWidth,
                  child: ProgressButton(
                    onPressed: () => _loanMaterialButtonHandler(widget.bookTitle),
                    progressIndicatorAligment: MainAxisAlignment.center,
                    progressIndicatorSize: 25.0,
                    state: _loanState,
                    padding: EdgeInsets.all(8.0),
                    stateWidgets: {
                      ButtonState.idle: Text(
                        "Loan Material",
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
              ) : Container(),
            ],
          ),


        ),
      ),
    );
  }

}