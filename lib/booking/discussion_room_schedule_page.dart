import 'package:ap_lib/booking/discussion_room_list.dart';
import 'package:ap_lib/booking/discussion_room_schedule.dart';
import 'package:ap_lib/booking/room_data_fetcher.dart';
import 'package:ap_lib/booking/schedule_list_component.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shimmer/shimmer.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import '../constants.dart';
import 'create_booking_page.dart';

class DiscussionRoomSchedulePage extends StatefulWidget {
  final DiscussionRoomList discussionRoomList;


  DiscussionRoomSchedulePage({
    @required this.discussionRoomList
  });

  @override
  _DiscussionRoomSchedulePageState createState() => _DiscussionRoomSchedulePageState();
}

class _DiscussionRoomSchedulePageState extends State<DiscussionRoomSchedulePage> {
  RoomDataFetcher _roomDataFetcher;
  List<DiscussionRoomSchedule> _discussionRoomSchedule = [];

  List<String> _roomIdList = [
    'DR001',
    'DR002',
    'DR003',
    'DR004',
    'DR005',
    'DR006',
    'DR007',
    'DR008',
  ];

  Future<List<DiscussionRoomSchedule>> _fetchRoomSchedule(String _roomId) async {
    return await _roomDataFetcher.getRoomSchedule(_roomId);
  }


  List<DiscussionRoomSchedule> _processSchedule(List<DiscussionRoomSchedule> _unprocessedSchedule) {
    var currentTime = new DateTime.now();
    var dateFormatter = new DateFormat('yyyy-MM-dd');
    String formattedDate = dateFormatter.format(currentTime);
    String epochOfFirstSession = DateTime.parse(formattedDate + ' 00:00:00').toUtc().millisecondsSinceEpoch.toString().substring(0, 10);
    String epochOfLastSession = DateTime.parse(formattedDate + ' 23:00:00').toUtc().millisecondsSinceEpoch.toString().substring(0, 10);
    print(epochOfFirstSession);
    print(epochOfLastSession);
    List<DiscussionRoomSchedule> _processedSchedule = [];

    if (_unprocessedSchedule.length != 0) {
      if (_unprocessedSchedule[0].startingTime != epochOfFirstSession) {
        _processedSchedule.add(
            new DiscussionRoomSchedule(startingTime: "free"));
      }

      for (int counter = 0; counter < _unprocessedSchedule.length; counter++) {
        _processedSchedule.add(_unprocessedSchedule[counter]);

        if (counter != _unprocessedSchedule.length - 1) {
          if ((int.parse(_unprocessedSchedule[counter + 1].startingTime)
              != (int.parse(_unprocessedSchedule[counter].startingTime)
                  + (_unprocessedSchedule[counter].duration * 3600)))) {
            _processedSchedule.add(
                new DiscussionRoomSchedule(startingTime: "free"));
          }
        } else if ((int.parse(_unprocessedSchedule[counter].startingTime)
            + (_unprocessedSchedule[counter].duration * 3600)) !=
            int.parse(epochOfLastSession)) {
          _processedSchedule.add(
              new DiscussionRoomSchedule(startingTime: "free"));
        }
      }
    } else {
      _processedSchedule.add(new DiscussionRoomSchedule(startingTime: "free"));
    }

    return _processedSchedule;
  }

  void _scanCodeButtonHandler() async {
    // Navigator.push(
    //   context,
    //   CupertinoPageRoute(builder: (context) => CodeScannerPage()),
    // );
    await Permission.camera.request();
    String cameraScanResult = await scanner.scan();
    if (cameraScanResult == null) {
      print('nothing return.');
    } else {
      if (_roomIdList.contains(cameraScanResult)) {
        Navigator.push(
          context,
          CupertinoPageRoute(builder: (context) => CreateBookingPage(roomId: cameraScanResult,)),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              "Invalid Code",
              style: Constants.TEXT_STYLE_DIALOG_TITLE_AND_ACTION_1,
            ),
            content: Text(
              "Invalid room ID.",
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

    }
  }

  _back(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    _roomDataFetcher = new RoomDataFetcher();
    _fetchRoomSchedule(widget.discussionRoomList.roomId).then((list) => {
      setState(() {
        _discussionRoomSchedule = _processSchedule(list);
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
        actions: [
          GestureDetector(
            onTap: () => _scanCodeButtonHandler(),
            child: Container(
              padding: EdgeInsets.fromLTRB(screenWidth * 0.03, screenHeight * 0.005,
                screenWidth * 0.05, 0.0
              ),
              child: Icon(
                Icons.qr_code_scanner_rounded,
                color: Constants.COLOR_BLACK,
                size: 35,
              ),
            ),
          )
        ],
      ),
      body: SizedBox.expand(
        child: Container(
          padding: EdgeInsets.fromLTRB(screenWidth * 0.05, screenHeight * 0.02, screenWidth * 0.05, 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // page title
              Container(
                child: Text(
                  widget.discussionRoomList.roomName,
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

              // schedule section title
              Container(
                padding: EdgeInsets.only(top: screenHeight * 0.03),
                child: Text(
                  'Schedule',
                  style: Constants.TEXT_STYLE_HEADING_2,
                ),
              ),

              // schedule list
              Container(
                child: _discussionRoomSchedule.length == 0 ? Shimmer.fromColors(
                  baseColor: Constants.COLOR_SILVER_LIGHTER,
                  highlightColor: Constants.COLOR_WHITE,
                  child: Container(
                    margin: EdgeInsets.only(top: screenHeight * 0.01),
                    width: screenWidth - (screenWidth * 0.05) * 2,
                    height: screenHeight * 0.097,
                    decoration: BoxDecoration(
                      color: Constants.COLOR_SILVER_LIGHTER,
                      borderRadius: BorderRadius.circular(13.0)
                    ),
                  )
                ) :
                ScheduleListComponent(
                  discussionRoomSchedule: _discussionRoomSchedule
                )
              ),
            ],
          ),
        ),
      ),

    );
  }

}