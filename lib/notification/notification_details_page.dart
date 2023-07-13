import 'package:ap_lib/notification/notification_data_provider.dart';
import 'package:ap_lib/notification/notification_model.dart';
import 'package:ap_lib/reading_history/reading_history_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ap_lib/enum/enum_state.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import '../constants.dart';

class NotificationDetailsPage extends StatefulWidget {
  final String notificationId;
  final String relatedReminderId;
  final String notificationDateTime;

  NotificationDetailsPage({
    @required this.notificationId,
    @required this.relatedReminderId,
    @required this.notificationDateTime,
  });

  @override
  _NotificationDetailsPageState createState() => _NotificationDetailsPageState();
}

class _NotificationDetailsPageState extends State<NotificationDetailsPage> {
  DateFormat _dateFormatter;
  DateFormat _timeFormatter;
  NotificationDataProvider _notificationDataProvider;

  List<NotificationModel> _notificationDetailsList = [];

  LoadState _loadState = LoadState.Loading;

  Future<List<NotificationModel>> _fetchNotificationDetails() async {
    if (widget.relatedReminderId.substring(0, 2) == 'LR') {
      return _notificationDataProvider.getNotificationDetailsLoan(widget.relatedReminderId, widget.notificationId);
    }
    return _notificationDataProvider.getNotificationDetailsBooking(widget.relatedReminderId, widget.notificationId);
  }

  void _viewLoanDetails() {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => ReadingHistoryPage()),
    );
  }

  _back(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();

    _dateFormatter = new DateFormat('dd MMM yyyy');
    _timeFormatter = new DateFormat.jm();
    _notificationDataProvider = new NotificationDataProvider();

    _fetchNotificationDetails().then((list) => {
      setState(() {
        _notificationDetailsList = list;
        _loadState = LoadState.Done;
      })
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Hero(
      tag: widget.notificationId,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        // extendBodyBehindAppBar: true,
        backgroundColor: widget.relatedReminderId.substring(0, 2) == 'LR' ? Constants.COLOR_BLUE_MEDIUM_STATE : Constants.COLOR_MIDNIGHT_BLUE,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: GestureDetector(
            onTap: () => _back(context),
            child: Icon(
              Icons.arrow_back_outlined,
              color: Constants.COLOR_WHITE,
            ),
          ),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            padding: EdgeInsets.fromLTRB(screenWidth * 0.05, screenHeight * 0.02, screenWidth * 0.05, 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // page title
                Container(
                  width: screenWidth,
                  child: Text(
                    widget.relatedReminderId.substring(0, 2) == 'LR' ? 'Due Date Reminder' : 'Booking Reminder',
                    style: Constants.TEXT_STYLE_HEADING_WHITE_1,
                  ),
                ),

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    margin: EdgeInsets.only(top: screenHeight * 0.018),
                    child: Row(
                      children: [
                        // notification date icon
                        Container(
                          padding: EdgeInsets.only(right: screenWidth * 0.02),
                          child: Icon(
                            Icons.event_note_rounded,
                            color: Constants.COLOR_WHITE,
                            size: 18.0,
                          ),
                        ),

                        // notification date
                        _loadState == LoadState.Loading ? Shimmer.fromColors(
                          baseColor: Constants.COLOR_SILVER_LIGHTER,
                          highlightColor: Constants.COLOR_PLATINUM_LIGHT,
                          child: Container(
                            width: screenWidth * 0.2,
                            height: screenHeight * 0.015,
                            margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                            decoration: BoxDecoration(
                              color: Constants.COLOR_SILVER_LIGHTER,
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ) : Container(
                          child: Text(
                            _dateFormatter.format(DateTime.fromMillisecondsSinceEpoch(int.parse(widget.notificationDateTime + '000'))),
                            style: Constants.TEXT_STYLE_HEADING_SUBTITLE_1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(top: screenHeight * 0.03),
                  child: Text(
                    widget.relatedReminderId.substring(0, 2) == 'RB'
                        ? 'You have an upcoming booking due date. Kindly visit the library to access the discussion room.'
                        : 'You have an upcoming loaning due date. Kindly return the book by the due date to prevent being fined.',
                    style: Constants.TEXT_STYLE_DETAILS_PASSAGE_CONTENT_WHITE_2,
                  ),
                ),


                // room booking notification
                _loadState == LoadState.Loading && widget.relatedReminderId.substring(0, 2) == 'RB' ? Shimmer.fromColors(
                  baseColor: Constants.COLOR_SILVER_LIGHTER,
                  highlightColor: Constants.COLOR_PLATINUM_LIGHT,
                  child: Container(
                    width: screenWidth * 0.3,
                    height: screenHeight * 0.015,
                    margin: EdgeInsets.only(top: screenHeight * 0.025),
                    decoration: BoxDecoration(
                      color: Constants.COLOR_SILVER_LIGHTER,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ) : widget.relatedReminderId.substring(0, 2) == 'RB' ? Container(
                  margin: EdgeInsets.only(top: screenHeight * 0.025),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Date: ',
                          style: Constants.TEXT_STYLE_DETAILS_PASSAGE_CONTENT_SMALL_TITLE_WHITE_1,
                        ),
                        TextSpan(
                          text: _dateFormatter.format(DateTime.fromMillisecondsSinceEpoch(int.parse(_notificationDetailsList[0].bookingDetails.startingTime + '000'))),
                          style: Constants.TEXT_STYLE_DETAILS_PASSAGE_CONTENT_SMALL_WHITE_1,
                        ),
                      ],
                    ),
                  ),
                ) : Container(),


                _loadState == LoadState.Loading && widget.relatedReminderId.substring(0, 2) == 'RB' ? Shimmer.fromColors(
                  baseColor: Constants.COLOR_SILVER_LIGHTER,
                  highlightColor: Constants.COLOR_PLATINUM_LIGHT,
                  child: Container(
                    width: screenWidth * 0.4,
                    height: screenHeight * 0.015,
                    margin: EdgeInsets.only(top: screenHeight * 0.007),
                    decoration: BoxDecoration(
                      color: Constants.COLOR_SILVER_LIGHTER,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ) : widget.relatedReminderId.substring(0, 2) == 'RB' ? Container(
                  margin: EdgeInsets.only(top: screenHeight * 0.007),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Time: ',
                          style: Constants.TEXT_STYLE_DETAILS_PASSAGE_CONTENT_SMALL_TITLE_WHITE_1,
                        ),
                        TextSpan(
                          text: _timeFormatter.format(DateTime.fromMillisecondsSinceEpoch(int.parse(_notificationDetailsList[0].bookingDetails.startingTime + '000'))).padLeft(8, '0'),
                          style: Constants.TEXT_STYLE_DETAILS_PASSAGE_CONTENT_SMALL_WHITE_1,
                        ),
                        TextSpan(
                          text: ' - ' + _timeFormatter.format(
                            DateTime.fromMillisecondsSinceEpoch(
                              int.parse(_notificationDetailsList[0].bookingDetails.startingTime + '000'),
                            ).add(Duration(hours: _notificationDetailsList[0].bookingDetails.duration)),
                          ).padLeft(8, '0'),
                        ),
                      ],
                    ),
                  ),
                ) : Container(),

                _loadState == LoadState.Loading && widget.relatedReminderId.substring(0, 2) == 'RB' ? Shimmer.fromColors(
                  baseColor: Constants.COLOR_SILVER_LIGHTER,
                  highlightColor: Constants.COLOR_PLATINUM_LIGHT,
                  child: Container(
                    width: screenWidth * 0.25,
                    height: screenHeight * 0.015,
                    margin: EdgeInsets.only(top: screenHeight * 0.007),
                    decoration: BoxDecoration(
                      color: Constants.COLOR_SILVER_LIGHTER,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ) : widget.relatedReminderId.substring(0, 2) == 'RB' ? Container(
                  margin: EdgeInsets.only(top: screenHeight * 0.007),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Room: ',
                          style: Constants.TEXT_STYLE_DETAILS_PASSAGE_CONTENT_SMALL_TITLE_WHITE_1,
                        ),
                        TextSpan(
                          text: _notificationDetailsList[0].bookingDetails.roomName,
                          style: Constants.TEXT_STYLE_DETAILS_PASSAGE_CONTENT_SMALL_WHITE_1,
                        ),
                      ],
                    ),
                  ),
                ) : Container(),

                _loadState == LoadState.Loading && widget.relatedReminderId.substring(0, 2) == 'RB' ? Shimmer.fromColors(
                  baseColor: Constants.COLOR_SILVER_LIGHTER,
                  highlightColor: Constants.COLOR_PLATINUM_LIGHT,
                  child: Container(
                    width: screenWidth * 0.25,
                    height: screenHeight * 0.015,
                    margin: EdgeInsets.only(top: screenHeight * 0.007),
                    decoration: BoxDecoration(
                      color: Constants.COLOR_SILVER_LIGHTER,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ) :  widget.relatedReminderId.substring(0, 2) == 'RB' ? Container(
                  margin: EdgeInsets.only(top: screenHeight * 0.007),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Number of Person: ',
                          style: Constants.TEXT_STYLE_DETAILS_PASSAGE_CONTENT_SMALL_TITLE_WHITE_1,
                        ),
                        TextSpan(
                          text: _notificationDetailsList[0].bookingDetails.numOfPerson.toString() + " Person",
                          style: Constants.TEXT_STYLE_DETAILS_PASSAGE_CONTENT_SMALL_WHITE_1,
                        ),
                      ],
                    ),
                  ),
                ) : Container(),

                _loadState == LoadState.Loading && widget.relatedReminderId.substring(0, 2) == 'RB' ? Shimmer.fromColors(
                  baseColor: Constants.COLOR_SILVER_LIGHTER,
                  highlightColor: Constants.COLOR_PLATINUM_LIGHT,
                  child: Container(
                    width: screenWidth * 0.2,
                    height: screenHeight * 0.015,
                    margin: EdgeInsets.only(top: screenHeight * 0.007),
                    decoration: BoxDecoration(
                      color: Constants.COLOR_SILVER_LIGHTER,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ) : widget.relatedReminderId.substring(0, 2) == 'RB' ? Container(
                  margin: EdgeInsets.only(top: screenHeight * 0.007),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Description: ',
                          style: Constants.TEXT_STYLE_DETAILS_PASSAGE_CONTENT_SMALL_TITLE_WHITE_1,
                        ),
                        TextSpan(
                          text: _notificationDetailsList[0].bookingDetails.description == '' ? '-' : _notificationDetailsList[0].bookingDetails.description,
                          style: Constants.TEXT_STYLE_DETAILS_PASSAGE_CONTENT_SMALL_WHITE_1,
                        ),
                      ],
                    ),
                  ),
                ) : Container(),

              widget.relatedReminderId.substring(0, 2) == 'RB'
                  && _loadState == LoadState.Done
                  && DateTime.now().isBefore(DateTime.fromMillisecondsSinceEpoch(int.parse(_notificationDetailsList[0].bookingDetails.startingTime + '000')))
                  ? SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    padding: EdgeInsets.only(top: screenHeight * 0.01),
                    child: ElevatedButton.icon(
                      label: Text(
                        'View Booking',
                        style: Constants.TEXT_STYLE_DETAILS_ACTION_BUTTON_TEXT,
                      ),
                      icon: Icon(
                        Icons.event_available_rounded,
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
                    ),
                  ),
                ) : Container(),


                // book loaning notification
                widget.relatedReminderId.substring(0, 2) == 'LR' ? SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    margin: EdgeInsets.only(top: screenHeight * 0.025),
                    child: Row(
                      children: [
                        // book image
                        _loadState == LoadState.Loading ? Shimmer.fromColors(
                          baseColor: Constants.COLOR_SILVER_LIGHTER,
                          highlightColor: Constants.COLOR_WHITE,
                          child: Container(
                            // height: screenHeight * 0.05,
                            width: screenWidth * 0.32,
                            height: screenHeight * 0.22,
                            decoration: BoxDecoration(
                              color: Constants.COLOR_SILVER_LIGHTER,
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                          ),
                        ) : Container(
                          width: screenWidth * 0.32,
                          height: screenHeight * 0.22,
                          decoration: BoxDecoration(
                            color: Constants.COLOR_WHITE,
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16.0),
                            child: Image.network(_notificationDetailsList[0].readingHistoryDetails.imageUrl),
                          ),
                        ),

                        // loan details
                        Container(
                          width: screenWidth - (screenWidth * 0.05 * 2) - (screenWidth * 0.32),
                          height: screenHeight * 0.22,
                          padding: EdgeInsets.only(left: screenWidth * 0.035),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // due date
                              Container(
                                child: _loadState == LoadState.Loading ? Shimmer.fromColors(
                                  baseColor: Constants.COLOR_SILVER_LIGHTER,
                                  highlightColor: Constants.COLOR_WHITE,
                                  child: Container(
                                    height: screenHeight * 0.02,
                                    decoration: BoxDecoration(
                                      color: Constants.COLOR_SILVER_LIGHTER,
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                  ),
                                ) : RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Due Date: ',
                                        style: Constants.TEXT_STYLE_DETAILS_PASSAGE_CONTENT_SMALL_TITLE_WHITE_1,
                                      ),
                                      TextSpan(
                                        text: _dateFormatter.format(DateTime.fromMillisecondsSinceEpoch(int.parse(_notificationDetailsList[0].readingHistoryDetails.dueDate + '000'))),
                                        style: Constants.TEXT_STYLE_DETAILS_PASSAGE_CONTENT_SMALL_WHITE_1,
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              // book title
                              Container(
                                padding: EdgeInsets.only(top: screenHeight * 0.005),
                                child: _loadState == LoadState.Loading ? Shimmer.fromColors(
                                  baseColor: Constants.COLOR_SILVER_LIGHTER,
                                  highlightColor: Constants.COLOR_WHITE,
                                  child: Container(
                                    height: screenHeight * 0.02,
                                    decoration: BoxDecoration(
                                      color: Constants.COLOR_SILVER_LIGHTER,
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                  ),
                                ) : RichText(
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Title: ',
                                        style: Constants.TEXT_STYLE_DETAILS_PASSAGE_CONTENT_SMALL_TITLE_WHITE_1,
                                      ),
                                      TextSpan(
                                        text: _notificationDetailsList[0].readingHistoryDetails.bookTitle,
                                        style: Constants.TEXT_STYLE_DETAILS_PASSAGE_CONTENT_SMALL_WHITE_1,
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              // book author
                              Container(
                                padding: EdgeInsets.only(top: screenHeight * 0.005),
                                child: _loadState == LoadState.Loading ? Shimmer.fromColors(
                                  baseColor: Constants.COLOR_SILVER_LIGHTER,
                                  highlightColor: Constants.COLOR_WHITE,
                                  child: Container(
                                    height: screenHeight * 0.02,
                                    decoration: BoxDecoration(
                                      color: Constants.COLOR_SILVER_LIGHTER,
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                  ),
                                ) : RichText(
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Author: ',
                                        style: Constants.TEXT_STYLE_DETAILS_PASSAGE_CONTENT_SMALL_TITLE_WHITE_1,
                                      ),
                                      TextSpan(
                                        text: _notificationDetailsList[0].readingHistoryDetails.bookAuthor,
                                        style: Constants.TEXT_STYLE_DETAILS_PASSAGE_CONTENT_SMALL_WHITE_1,
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              // loaning date
                              Container(
                                padding: EdgeInsets.only(top: screenHeight * 0.005),
                                child: _loadState == LoadState.Loading ? Shimmer.fromColors(
                                  baseColor: Constants.COLOR_SILVER_LIGHTER,
                                  highlightColor: Constants.COLOR_WHITE,
                                  child: Container(
                                    height: screenHeight * 0.02,
                                    decoration: BoxDecoration(
                                      color: Constants.COLOR_SILVER_LIGHTER,
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                  ),
                                ) : RichText(
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Loaning Date: ',
                                        style: Constants.TEXT_STYLE_DETAILS_PASSAGE_CONTENT_SMALL_TITLE_WHITE_1,
                                      ),
                                      TextSpan(
                                        text: _dateFormatter.format(DateTime.fromMillisecondsSinceEpoch(int.parse(_notificationDetailsList[0].readingHistoryDetails.loanDateTime + '000'))),
                                        style: Constants.TEXT_STYLE_DETAILS_PASSAGE_CONTENT_SMALL_WHITE_1,
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              // locate material button
                              widget.relatedReminderId.substring(0, 2) == 'LR'
                                  && _loadState == LoadState.Done
                                  // && DateTime.now().isBefore(DateTime.fromMillisecondsSinceEpoch(int.parse(_notificationDetailsList[0].readingHistoryDetails.dueDate + '000')))
                                  ? Container(
                                padding: EdgeInsets.only(top: screenHeight * 0.01),
                                child: ElevatedButton.icon(
                                  onPressed: () => _viewLoanDetails(),
                                  label: Text(
                                    'View Details',
                                    style: Constants.TEXT_STYLE_DETAILS_ACTION_BUTTON_TEXT,
                                  ),
                                  icon: Icon(
                                    Icons.info_rounded,
                                    color: Constants.COLOR_WHITE,
                                  ),
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<Color>(Constants.COLOR_MIDNIGHT_BLUE),
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ) : Container(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ) : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }

}