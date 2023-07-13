import 'package:ap_lib/booking/discussion_room_schedule.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constants.dart';

class ScheduleListComponent extends StatefulWidget {
  final List<DiscussionRoomSchedule> discussionRoomSchedule;

  ScheduleListComponent({
    @required this.discussionRoomSchedule
  });

  @override
  _ScheduleListComponentState createState() => _ScheduleListComponentState();
}

class _ScheduleListComponentState extends State<ScheduleListComponent> {
  DateFormat _dateFormatter;

  Widget _buildScheduleList(context, index, screenWidth, screenHeight) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: screenHeight * 0.005),
      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.015, horizontal: screenWidth * 0.04),
      height: screenHeight * 0.097,
      decoration: BoxDecoration(
        color: widget.discussionRoomSchedule[index].startingTime == "free" ? Constants.COLOR_GREEN_LIGHT : Constants.COLOR_RED,
        borderRadius: BorderRadius.circular(13.0)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Text(
              widget.discussionRoomSchedule[index].startingTime == "free" ? 'FREE' : 'BOOKED',
              style: Constants.TEXT_STYLE_CARD_TITLE_2,
            ),
          ),

          Container(
            padding: EdgeInsets.only(top: screenHeight * 0.01),
            child: Row(
              children: [
                Container(
                  width: screenWidth * 0.4,
                  child: Row(
                    children: [
                      Icon(
                        Icons.watch_later_rounded,
                        color: Constants.COLOR_WHITE,
                        size: 16,
                      ),

                      Container(
                        padding: EdgeInsets.only(left: screenWidth * 0.015),
                        child: Text(
                          widget.discussionRoomSchedule[index].startingTime == "free"
                              ? "-"
                              : _dateFormatter.format(new DateTime.fromMillisecondsSinceEpoch(int.parse(widget.discussionRoomSchedule[index].startingTime + '000')))
                               + " - " + _dateFormatter.format(new DateTime.fromMillisecondsSinceEpoch(int.parse(widget.discussionRoomSchedule[index].startingTime + '000')
                                  + widget.discussionRoomSchedule[index].duration * 3600000)),
                          style: Constants.TEXT_STYLE_CARD_SUB_TITLE_2,
                        ),
                      )
                    ],
                  ),
                ),

                Expanded(
                  child: Row(
                    children: [
                      Icon(
                        Icons.account_circle_rounded,
                        color: Constants.COLOR_WHITE,
                        size: 16,
                      ),

                      Container(
                        padding: EdgeInsets.only(left: screenWidth * 0.015),
                        width: screenWidth * 0.3,
                        child: Text(
                          widget.discussionRoomSchedule[index].startingTime == "free"
                              ? "-"
                              : widget.discussionRoomSchedule[index].bookingUserFullName.toUpperCase(),
                          overflow: TextOverflow.ellipsis,
                          style: Constants.TEXT_STYLE_CARD_SUB_TITLE_2,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _dateFormatter = new DateFormat.jm();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Expanded(
      child: Container(
        padding: EdgeInsets.only(top: screenHeight * 0.005),
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: widget.discussionRoomSchedule.length,
          itemBuilder: (BuildContext context, int index) => _buildScheduleList(context, index, screenWidth, screenHeight),
        )
      ),
    );
  }
}