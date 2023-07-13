import 'package:ap_lib/booking/discussion_room_schedule_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants.dart';
import 'discussion_room_list.dart';

class RoomListComponent extends StatefulWidget {
  final List<DiscussionRoomList> discussionRoomList;
  final bool availability;

  RoomListComponent({
    @required this.discussionRoomList,
    @required this.availability
  });

  @override
  _RoomListComponentState createState() => _RoomListComponentState();
}

class _RoomListComponentState extends State<RoomListComponent> {
  final String iconFilePath = 'assets/meeting-room-icon.svg';
  final String capacityIconFilePath = 'assets/group-icon.svg';

  _viewSchedule(DiscussionRoomList _discussionRoomList) {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => DiscussionRoomSchedulePage(discussionRoomList: _discussionRoomList,))
    );
  }

  _buildRoomList(BuildContext context, int index, double screenWidth, double screenHeight) {
    return GestureDetector(
      onTap: () => _viewSchedule(widget.discussionRoomList[index]),
      child: Container(
        width: screenWidth - (screenWidth * 0.05) * 2,
        height: screenHeight * 0.098,
        margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01, horizontal: screenWidth * 0.01),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
          color: Constants.COLOR_MAGNOLIA,
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
            Container(
              height: screenHeight * 0.098,
              width: screenWidth * 0.12,
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.025),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(6.0), bottomLeft: Radius.circular(6.0)),
                color: widget.availability == true ? Constants.COLOR_GREEN_LIGHT : Constants.COLOR_RED,
              ),
              child: SvgPicture.asset(
                iconFilePath,
                color: Constants.COLOR_WHITE,
              ),
            ),

            // room text details
            Container(
              padding: EdgeInsets.only(left: screenWidth * 0.03),
              height: screenHeight * 0.1,
              width: screenWidth - ((screenWidth * 0.05) * 2) - (screenWidth * 0.2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Text(
                      widget.discussionRoomList[index].roomName,
                      style: Constants.TEXT_STYLE_CARD_TITLE_1,
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        child: SvgPicture.asset(
                          capacityIconFilePath,
                          color: Constants.COLOR_GRAY_LIGHT,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: screenWidth * 0.015, top: screenHeight * 0.002),
                        child: Text(
                          widget.discussionRoomList[index].capacity.toString() + " People",
                          style: Constants.TEXT_STYLE_CARD_SUB_TITLE_1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              child: Icon(
                Icons.chevron_right_rounded,
                size: 25
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return widget.discussionRoomList.length == 0
        ? Container(
            height: screenHeight * 0.1,
            padding: EdgeInsets.only(top: screenHeight * 0.015),
            child: Text(
              widget.availability == true ? "No available room found." : "No booked room found.",
              style: Constants.TEXT_STYLE_NON_ALTERNATIVE_TEXT,
            ),
          )
        : Container(
            height: screenHeight * 0.24,
            padding: EdgeInsets.only(top: screenHeight * 0.005),
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: widget.discussionRoomList.length,
              itemBuilder: (BuildContext context, int index) => _buildRoomList(context, index, screenWidth, screenHeight),
            ),
          );
  }

}