import 'package:ap_lib/booking/room_data_fetcher.dart';
import 'package:ap_lib/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'discussion_room_list.dart';
import 'room_list_component.dart';
import 'create_booking_page.dart';
import 'package:shimmer/shimmer.dart';
import 'my_booking_page.dart';
import 'package:ap_lib/enum/enum_state.dart';

class BookingPage extends StatefulWidget {
  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  RoomDataFetcher _roomDataFetcher;
  List<DiscussionRoomList> _availableRoomList;
  List<DiscussionRoomList> _bookedRoomList;

  LoadState _loadState = LoadState.Loading;

  List<DiscussionRoomList> _discussionRoomList = [
    new DiscussionRoomList(
      roomId: "DR001",
      roomName: "Room 1",
      capacity: 8,
      availability: true,
    ),
    new DiscussionRoomList(
      roomId: "DR002",
      roomName: "Room 2",
      capacity: 8,
      availability: true,
    ),
    new DiscussionRoomList(
      roomId: "DR003",
      roomName: "Room 3",
      capacity: 8,
      availability: true,
    )
  ];

  Future<List<DiscussionRoomList>> _fetchAvailableRoom() async {
    return await _roomDataFetcher.getAllRoom(true);
  }

  Future<List<DiscussionRoomList>> _fetchBookedRoom() async {
    return await _roomDataFetcher.getAllRoom(false);
  }

  void _navigateToCreateBookingPage() {
    DateTime _currentTime = DateTime.now();
    DateFormat _dateFormatter = new DateFormat('yyyy-MM-dd');
    DateFormat _dayFormatter = new DateFormat('E');

    // if (_currentTime.isBefore(DateTime.parse(
    //     _dateFormatter.format(_currentTime) + " 12:00:00.000")) &&
    //     _dayFormatter.format(_currentTime) != 'Sun') {
    //   Navigator.push(
    //     context,
    //     CupertinoPageRoute(builder: (context) => CreateBookingPage()),
    //   );
    // } else {
    //   showDialog(
    //     context: context,
    //     builder: (context) => AlertDialog(
    //       title: Text(
    //         "No Slots Available",
    //         style: Constants.TEXT_STYLE_DIALOG_TITLE_AND_ACTION_1,
    //       ),
    //       content: Text(
    //         "Library is closed at the moment, please visit us on the coming Monday. Thank you.",
    //         style: Constants.TEXT_STYLE_DIALOG_CONTENT,
    //       ),
    //       actions: <Widget>[
    //         TextButton(
    //           onPressed: () {
    //             Navigator.of(context).pop();
    //           },
    //           child: Text(
    //             "OK",
    //             style: Constants.TEXT_STYLE_DIALOG_TITLE_AND_ACTION_1,
    //           ),
    //         ),
    //       ],
    //     ),
    //   );
    // }

    if (_dayFormatter.format(_currentTime) == 'Sun') {
      // Navigator.push(
      //   context,
      //   CupertinoPageRoute(builder: (context) => CreateBookingPage()),
      // );
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            "No Slots Available",
            style: Constants.TEXT_STYLE_DIALOG_TITLE_AND_ACTION_1,
          ),
          content: Text(
            "Library is closed at the moment, please visit us on the coming Monday. Thank you.",
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
    } else if (_dayFormatter.format(_currentTime) == 'Sat') {
      if (_currentTime.isBefore(DateTime.parse(
          _dateFormatter.format(_currentTime) + " 12:00:00.000"))) {
        Navigator.push(
          context,
          CupertinoPageRoute(builder: (context) => CreateBookingPage()),
        );
      }
    } else {
      Navigator.push(
        context,
        CupertinoPageRoute(builder: (context) => CreateBookingPage()),
      );
    }
  }

  void _navigateToMyBookingPage() {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => MyBookingPage()),
    );
  }

  void initState() {
    super.initState();
    _roomDataFetcher = new RoomDataFetcher();

    _fetchAvailableRoom().then((List<DiscussionRoomList> list) => {
      _availableRoomList = list,
      if (_bookedRoomList != null) {
        if (mounted) {
          setState(() {
            _loadState = LoadState.Done;
          })
        }
      }
    });

    _fetchBookedRoom().then((List<DiscussionRoomList> list) => {
      _bookedRoomList = list,
      if (_availableRoomList != null) {
        if (mounted) {
          setState(() {
            _loadState = LoadState.Done;
          })
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: SpeedDial(
        icon: Icons.add_rounded,
        activeIcon: Icons.close_rounded,
        curve: Curves.bounceIn,
        overlayColor: Constants.COLOR_WHITE,
        backgroundColor: Constants.COLOR_BLUE_THEME,
        foregroundColor: Constants.COLOR_WHITE,
        children: [
          SpeedDialChild(
            backgroundColor: Constants.COLOR_BLACK,
            label: "Create Booking",
            labelStyle: Constants.TEXT_STYLE_FLOATING_BUTTON_LIST_TEXT,
            labelBackgroundColor: Constants.COLOR_BLACK,
            onTap: () => _navigateToCreateBookingPage(),
            child: Icon(
              Icons.playlist_add_rounded,
              color: Constants.COLOR_WHITE,
            ),
          ),
          SpeedDialChild(
            backgroundColor: Constants.COLOR_BLACK,
            label: "My Booking",
            labelStyle: Constants.TEXT_STYLE_FLOATING_BUTTON_LIST_TEXT,
            labelBackgroundColor: Constants.COLOR_BLACK,
            onTap: () => _navigateToMyBookingPage(),
            child: Icon(
              Icons.history_rounded,
              color: Constants.COLOR_WHITE,
            ),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(screenWidth * 0.035, screenHeight * 0.02, screenWidth * 0.035, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // page title
            Container(
              child: Text(
                "Discussion Room Booking",
                style: Constants.TEXT_STYLE_HEADING_1,
              ),
            ),

            // page instructions
            Container(
              padding: EdgeInsets.only(top: screenHeight * 0.015),
              child: Text(
                'Kindly press the plus button to create a new booking or press the scan button to access the room immediately.',
                style: Constants.TEXT_STYLE_SUB_HEADING_1,
              ),
            ),

            // rooms section title
            Container(
              padding: EdgeInsets.only(top: screenHeight * 0.03),
              child: Text(
                'Currently Available',
                style: Constants.TEXT_STYLE_HEADING_2,
              ),
            ),

            Container(
              // child: _availableRoomList.length == 0 && _bookedRoomList.length == 0 ? Shimmer.fromColors(
              child: _loadState == LoadState.Loading ? Shimmer.fromColors(
                baseColor: Constants.COLOR_SILVER_LIGHTER,
                highlightColor: Constants.COLOR_WHITE,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01, horizontal: screenWidth * 0.01),
                    width: screenWidth - (screenWidth * 0.05) * 2,
                    height: screenHeight * 0.098,
                    decoration: BoxDecoration(
                      color: Constants.COLOR_SILVER_LIGHTER,
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                  )
              ) :
              RoomListComponent(
                discussionRoomList: _availableRoomList,
                availability: true,
              ),
            ),


            Container(
              padding: EdgeInsets.only(top: screenHeight * 0.025),
              child: Text(
                'Currently Occupied',
                style: Constants.TEXT_STYLE_HEADING_2,
              ),
            ),

            Container(
              child: _loadState == LoadState.Loading ? Shimmer.fromColors(
                baseColor: Constants.COLOR_SILVER_LIGHTER,
                highlightColor: Constants.COLOR_WHITE,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01, horizontal: screenWidth * 0.01),
                  width: screenWidth - (screenWidth * 0.05) * 2,
                  height: screenHeight * 0.098,
                  decoration: BoxDecoration(
                    color: Constants.COLOR_SILVER_LIGHTER,
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                )
              ) :
              RoomListComponent(
                discussionRoomList: _bookedRoomList,
                availability: false,
              ),
            ),
          ],
        ),
      ),
    );
  }

}