import 'package:ap_lib/enum/enum_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'notification_details_page.dart';

import '../constants.dart';

class NotificationListComponent extends StatefulWidget {
  final LoadState loadState;
  final String notificationId;
  final String descriptionMessage;
  final String relatedReminderId;
  final String notificationDateTime;
  final String notificationPrevDateTime;
  final bool messageRead;

  NotificationListComponent({
    @required this.loadState,
    @required this.notificationId,
    @required this.descriptionMessage,
    @required this.relatedReminderId,
    @required this.notificationDateTime,
    @required this.notificationPrevDateTime,
    @required this.messageRead,
  });

  @override
  _NotificationListComponentState createState() => _NotificationListComponentState();
}

class _NotificationListComponentState extends State<NotificationListComponent> {
  DateFormat _dateFormatter;
  DateFormat _dayDateFormatter;
  DateFormat _timeFormatter;

  void _navigateToNotificationDetailsPage(String relatedReminderId, String notificationId, String notificationDateTime) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NotificationDetailsPage(
        relatedReminderId: relatedReminderId,
        notificationId: notificationId,
        notificationDateTime: notificationDateTime,
      )),
    );
  }

  @override
  void initState() {
    super.initState();
    _dateFormatter = new DateFormat('dd MMM yyyy');
    _dayDateFormatter = new DateFormat('E, dd MMM yyyy');
    _timeFormatter = new DateFormat.jm();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return widget.loadState == LoadState.Loading ? Shimmer.fromColors(
      baseColor: Constants.COLOR_SILVER_LIGHTER,
      highlightColor: Constants.COLOR_PLATINUM_LIGHT,
      child: Container(
        width: screenWidth - (screenWidth * 0.035) * 2,
        height: screenHeight * 0.098,
        margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
        decoration: BoxDecoration(
          color: Constants.COLOR_SILVER_LIGHTER,
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    ) : Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // date section title
         _dateFormatter.format(DateTime.fromMillisecondsSinceEpoch(int.parse(widget.notificationDateTime + '000'))) !=
             _dateFormatter.format(DateTime.fromMillisecondsSinceEpoch(int.parse(widget.notificationPrevDateTime + '000'))) ? Container(
            padding: EdgeInsets.only(top: screenHeight * 0.02),
            child: Text(
              _dateFormatter.format(DateTime.fromMillisecondsSinceEpoch(int.parse(widget.notificationDateTime + '000'))) ==
                  _dateFormatter.format(DateTime.now())
                  ? 'Today' : _dateFormatter.format(DateTime.fromMillisecondsSinceEpoch(int.parse(widget.notificationDateTime + '000')).add(Duration(days: 1))) ==
                  _dateFormatter.format(DateTime.now())
                  ? 'Yesterday' : _dayDateFormatter.format(DateTime.fromMillisecondsSinceEpoch(int.parse(widget.notificationDateTime + '000'))),
              style: Constants.TEXT_STYLE_CARD_DAY_SECTION_TITLE,
            ),
          ) : Container(),

          // card
          GestureDetector(
            onTap: () => _navigateToNotificationDetailsPage(widget.relatedReminderId, widget.notificationId, widget.notificationDateTime),
            child: Container(
              width: screenWidth - (screenWidth * 0.035) * 2,
              height: screenHeight * 0.098,
              margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
              padding: EdgeInsets.only(right: screenWidth * 0.03),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.0),
                color: widget.messageRead ? Constants.COLOR_CULTURED : Constants.COLOR_MAGNOLIA,
                boxShadow: [
                  BoxShadow(
                    color: Constants.COLOR_GRAY_BOX_SHADOW,
                    offset: Offset(0.0, 5.0),
                    blurRadius: 4.0,
                    spreadRadius: 1.0,
                  ),
                ],
              ),
              child: Row(
                children: [
                  // left icon
                  Hero(
                    tag: widget.notificationId,
                    child: Container(
                      height: screenHeight * 0.098,
                      width: screenWidth * 0.12,
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.025),
                      margin: EdgeInsets.only(right: screenWidth * 0.03),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(6.0), bottomLeft: Radius.circular(6.0)),
                        color: widget.messageRead ? Constants.COLOR_WHITE
                            : widget.relatedReminderId.substring(0, 2) == 'LR'
                            ? Constants.COLOR_BLUE_MEDIUM_STATE : Constants.COLOR_MIDNIGHT_BLUE,
                      ),
                      child: Icon(
                        widget.relatedReminderId.substring(0, 2) == 'LR' ? Icons.auto_stories : Icons.event_available_rounded,
                        color: !widget.messageRead ? Constants.COLOR_WHITE
                            : widget.relatedReminderId.substring(0, 2) == 'LR'
                            ? Constants.COLOR_BLUE_MEDIUM_STATE : Constants.COLOR_MIDNIGHT_BLUE,
                      ),
                    ),
                  ),

                  // room text details
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Text(
                                widget.relatedReminderId.substring(0, 2) == 'LR' ? 'Due Date Reminder' : 'Booking Reminder',
                                style: Constants.TEXT_STYLE_CARD_TITLE_1,
                              ),
                            ),
                            Container(
                              child: Text(
                                _timeFormatter.format(DateTime.fromMillisecondsSinceEpoch(int.parse(widget.notificationDateTime + '000'))).padLeft(8, '0'),
                                style: Constants.TEXT_STYLE_CARD_DATE_4,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.only(top: screenHeight * 0.002),
                          child: widget.relatedReminderId.substring(0, 2) == 'LR' ? RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'You have an upcoming loaning due date for the book title of "',
                                  style: Constants.TEXT_STYLE_CARD_SUB_TITLE_6,
                                ),
                                TextSpan(
                                  text: widget.descriptionMessage,
                                  style: Constants.TEXT_STYLE_CARD_SUB_TITLE_BOLD_6,
                                ),
                                TextSpan(
                                  text: '"',
                                  style: Constants.TEXT_STYLE_CARD_SUB_TITLE_6,
                                ),
                              ],
                            ),
                          ) : RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'You have an upcoming room booking at \n',
                                  style: Constants.TEXT_STYLE_CARD_SUB_TITLE_6,
                                ),
                                TextSpan(
                                  text: _timeFormatter.format(DateTime.fromMillisecondsSinceEpoch(int.parse(widget.descriptionMessage + '000'))),
                                  style: Constants.TEXT_STYLE_CARD_SUB_TITLE_BOLD_6,
                                ),
                                TextSpan(
                                  text: ' (' + _dateFormatter.format(DateTime.fromMillisecondsSinceEpoch(int.parse(widget.descriptionMessage + '000'))) + ')',
                                  style: Constants.TEXT_STYLE_CARD_SUB_TITLE_BOLD_6,
                                ),
                              ],
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
        ],
      ),
    );

  }

}