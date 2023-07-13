import 'package:ap_lib/authenticate/authentication_handler.dart';
import 'package:ap_lib/booking/room_data_fetcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:progress_state_button/progress_button.dart';
import 'complete_booking_page.dart';

import '../constants.dart';

class CreateBookingPage extends StatefulWidget {
  final String roomId;

  CreateBookingPage({
    this.roomId
  });

  @override
  _CreateBookingPageState createState() => _CreateBookingPageState();
}

class _CreateBookingPageState extends State<CreateBookingPage> {
  DateFormat _dateFormatter;
  DateFormat _dayFormatter;
  DateFormat _timeFormatter;
  DateTime _currentTime;

  String _selectedTime;
  String _selectedDuration;
  String _selectedNumberOfPerson;
  String _selectedRoom;

  // List<DateTime> _timeSlotList = [];
  List<DropdownMenuItem<String>> _timeSlotItemList = [];
  List<DropdownMenuItem<String>> _durationItemList = [];
  List<DropdownMenuItem<String>> _numOfPersonItemList = [];
  List<DropdownMenuItem<String>> _roomItemList = [];

  TextEditingController _descriptionFieldController = new TextEditingController();
  var _formKey = GlobalKey<FormState>();

  ButtonState _confirmState = ButtonState.idle;

  _back(BuildContext context) {
    Navigator.pop(context);
  }

  Widget _dotBuilder(double screenWidth, double screenHeight) {
    return Container(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(bottom: screenHeight * 0.002),
            width: 27,
            child: Icon(
              Icons.circle,
              size: 6,
              color: Constants.COLOR_BLUE_SECONDARY,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: screenHeight * 0.002),
            width: 27,
            child: Icon(
              Icons.circle,
              size: 6,
              color: Constants.COLOR_BLUE_SECONDARY,
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: screenHeight * 0.002),
            width: 27,
            child: Icon(
              Icons.circle,
              size: 6,
              color: Constants.COLOR_BLUE_SECONDARY,
            ),
          ),
        ],
      ),
    );
  }

  DateTime roundWithin30Minutes(DateTime d) {
    int deltaMinute;
    if (d.minute < 15) {
      deltaMinute = -d.minute; // go back to zero
    } else if (d.minute < 45) {
      deltaMinute = 30 - d.minute; // go to 30 minutes
    } else {
      deltaMinute = 60 - d.minute;
    }
    return d.add(Duration(
        milliseconds: -d.millisecond,
        // reset milliseconds to zero
        microseconds: -d.microsecond,
        // reset microseconds to zero,
        seconds: -d.second,
        // reset seconds to zero
        minutes: deltaMinute));
  }

  List<DateTime> _timeSlotGenerator() {
    List<DateTime> _listOfTimeGenerated = [];
    DateTime _initialTime = roundWithin30Minutes(_currentTime);
    DateTime _currentGeneratedTime;
    DateTime _lastSession;

    if (_dayFormatter.format(_initialTime) == 'Sat') {
      _lastSession = DateTime.parse(
          _dateFormatter.format(_currentTime) + " 12:00:00.000");
    } else {
      _lastSession = DateTime.parse(
          _dateFormatter.format(_currentTime) + " 23:00:00.000");
    }

    // if (_initialTime.isBefore(DateTime.parse(_dateFormatter.format(_currentTime) + " 08:00:00.000"))) {
    //   _currentGeneratedTime = DateTime.parse(_dateFormatter.format(_currentTime) + " 08:00:00.000");
    // } else {
    //   _currentGeneratedTime = _initialTime;
    // }

    // set the initial time with the current time (round off to 30 minutes)
    _currentGeneratedTime = _initialTime;

    if (_initialTime.isAfter(DateTime.parse(_dateFormatter.format(_currentTime) + " 00:00:00.000")) &&
        _initialTime.isBefore(_lastSession)) {
      _listOfTimeGenerated.add(_currentGeneratedTime);
    }

    // generate a list of time slot to the last session (11:00 PM)
    while(_currentGeneratedTime != _lastSession && _currentGeneratedTime.isBefore(_lastSession)) {
      _currentGeneratedTime = _currentGeneratedTime.add(Duration(minutes: 30));
      _listOfTimeGenerated.add(_currentGeneratedTime);
    }

    return _listOfTimeGenerated;
  }

  void _generateTimeSlotItems() {
    List<DateTime> _timeSlotList = _timeSlotGenerator();
    // if (_timeSlotList.length == 0) {
    //   _timeSlotItemList.add(
    //     new DropdownMenuItem(
    //       value: "",
    //       child: Text(
    //         "-",
    //         style: Constants.TEXT_STYLE_DROPDOWN_HINT_2,
    //       ),
    //     )
    //   );
    // }

    _timeSlotList.forEach((element) {
      _timeSlotItemList.add(
        new DropdownMenuItem(
          value: element.toString(),
          child: Text(
            _timeFormatter.format(element),
            style: Constants.TEXT_STYLE_DROPDOWN_HINT_2,
          ),
        )
      );
    });
  }

  void _generateDurationItems() {
    for (int counter = 1; counter <= 4; counter++) {
      _durationItemList.add(
        new DropdownMenuItem(
          value: counter.toString(),
          child: Text(
            counter == 1 ? counter.toString() + " Hour" : counter.toString() + " Hours",
            style: Constants.TEXT_STYLE_DROPDOWN_HINT_2,
          ),
        )
      );
    }
  }

  void _generateNumOfPersonItems() {
    for (int counter = 3; counter <= 8; counter++) {
      _numOfPersonItemList.add(
        new DropdownMenuItem(
          value: counter.toString(),
          child: Text(
            counter.toString(),
            style: Constants.TEXT_STYLE_DROPDOWN_HINT_2,
          ),
        )
      );
    }
  }

  void _generateRoomItems() {
    for (int counter = 1; counter <= 8; counter++) {
      _roomItemList.add(
        new DropdownMenuItem(
          value: 'DR' + counter.toString().padLeft(3, '0'),
          child: Text(
            'Room ' + counter.toString(),
            style: Constants.TEXT_STYLE_DROPDOWN_HINT_2,
          ),
        )
      );
    }
  }

  void _updateTimeField(String newValue) {
    setState(() {
      _selectedTime = newValue;
      print(_selectedTime);
    });
  }

  void _updateDurationField(String newValue) {
    setState(() {
      _selectedDuration = newValue;
    });
  }

  void _updateNumOfPerson(String newValue) {
    setState(() {
      _selectedNumberOfPerson = newValue;
    });
  }

  void _updateRoom(String newValue) {
    setState(() {
      _selectedRoom = newValue;
    });
  }

  void _confirmBookingButtonHandler(String startingTime, String duration,
      String numOfPerson, String roomId, String description) async {
    RoomDataFetcher _roomDataFetcher = new RoomDataFetcher();
    String userToken = await new AuthenticationHandler().getToken();
    print(startingTime);
    print(duration);

    if (_formKey.currentState.validate()) {
      switch (_confirmState) {
        case ButtonState.idle:
          setState(() {
            _confirmState = ButtonState.loading;
          });
          // Navigator.push(
          //   context,
          //   CupertinoPageRoute(builder: (context) => CompleteBookingPage(
          //     startingTime: startingTime,
          //     duration: duration,
          //     room: _selectedRoom,
          //   )),
          // );
          _roomDataFetcher.createBooking(
              startingTime, duration, numOfPerson, roomId, description,
              userToken).then((status) =>
          {
            print(status.statusString),

            if (status.statusString == "success") {
              setState(() {
                _confirmState = ButtonState.success;
              }),
              Navigator.push(
                context,
                CupertinoPageRoute(builder: (context) =>
                    CompleteBookingPage(
                      startingTime: startingTime,
                      duration: duration,
                      room: _selectedRoom,
                      bookingId: status.bookingId,
                      roomId: status.roomId,
                    )),
              )
            } else
              if (status.statusString == "slot not available") {
                setState(() {
                  _confirmState = ButtonState.fail;
                  showDialog(
                      context: context,
                      builder: (context) =>
                          AlertDialog(
                            title: Text(
                              "Booking Failed",
                              style: Constants
                                  .TEXT_STYLE_DIALOG_TITLE_AND_ACTION_1,
                            ),
                            content: Text(
                              "The slot has been booked. Kindly select another slot.",
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
                          )
                  );
                }),
              } else
                if (status.statusString == "duplication found") {
                  setState(() {
                    _confirmState = ButtonState.fail;
                    showDialog(
                      context: context,
                      builder: (context) =>
                          AlertDialog(
                            title: Text(
                              "Booking Failed",
                              style: Constants
                                  .TEXT_STYLE_DIALOG_TITLE_AND_ACTION_1,
                            ),
                            content: Text(
                              "You are not allowed to place more than one booking at a time.",
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
                    );
                  }),
                } else
                  if (status.statusString == "out of operation") {
                    setState(() {
                      _confirmState = ButtonState.fail;
                      showDialog(
                        context: context,
                        builder: (context) =>
                            AlertDialog(
                              title: Text(
                                "Booking Failed",
                                style: Constants
                                    .TEXT_STYLE_DIALOG_TITLE_AND_ACTION_1,
                              ),
                              content: Text(
                                "The room is out of operation now.",
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
                      );
                    }),
                  }
          });
          break;
        case ButtonState.loading:
          break;
        case ButtonState.success:
          _confirmState = ButtonState.idle;
          break;
        case ButtonState.fail:
          _confirmState = ButtonState.idle;
          Future.delayed(Duration(seconds: 1), () {
            setState(() {
              _confirmState = ButtonState.idle;
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

  @override
  void initState() {
    super.initState();
    _currentTime = DateTime.now();
    _dateFormatter = new DateFormat('yyyy-MM-dd');
    _timeFormatter = new DateFormat.jm();
    _dayFormatter = new DateFormat('E');
    print(roundWithin30Minutes(DateTime.now()));
    _selectedRoom = widget.roomId == null ? null : widget.roomId;
    // _timeSlotList = _timeSlotGenerator();
    _generateTimeSlotItems();
    _generateDurationItems();
    _generateNumOfPersonItems();
    _generateRoomItems();
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
      body: Container(
        child: Stack(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              physics: BouncingScrollPhysics(),
              child: Container(
                padding: EdgeInsets.fromLTRB(screenWidth * 0.05, screenHeight * 0.02, screenWidth * 0.05, 0.0),
                margin: EdgeInsets.only(bottom: screenHeight * 0.15),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // page title
                      Container(
                        child: Text(
                          'Create Booking',
                          style: Constants.TEXT_STYLE_HEADING_1,
                        ),
                      ),

                      // page instructions
                      Container(
                        padding: EdgeInsets.only(top: screenHeight * 0.015),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Please select the time and number of person. Each booking is limited to ',
                                style: Constants.TEXT_STYLE_SUB_HEADING_1,
                              ),
                              TextSpan(
                                text: '4 hours',
                                style: Constants.TEXT_STYLE_SUB_HEADING_BOLD_1,
                              ),
                              TextSpan(
                                text: ' only. For special booking, kindly seek for librarian\'s assistance.',
                                style: Constants.TEXT_STYLE_SUB_HEADING_1,
                              ),
                            ]
                          ),
                        ),
                      ),

                      Container(
                        padding: EdgeInsets.only(top: screenHeight * 0.03),
                        child: Text(
                          'Details',
                          style: Constants.TEXT_STYLE_HEADING_2,
                        ),
                      ),

                      // 1st - starting time
                      Container(
                        padding: EdgeInsets.only(top: screenHeight * 0.005),
                        child: Row(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              width: screenWidth * 0.1,
                              child: Icon(
                                Icons.event_rounded,
                                size: 27,
                                color: Constants.COLOR_ILLUMINATING_EMERALD,
                              ),
                            ),

                            Expanded(
                              child: DropdownButtonFormField(
                                value: _selectedTime,
                                items: _timeSlotItemList,
                                onChanged: (newValue) => _updateTimeField(newValue),
                                hint: Text(
                                  'Starting Time',
                                  style: Constants.TEXT_STYLE_INPUT_HINT_2,
                                ),
                                validator: (value) {
                                  if (_selectedTime == null) {
                                    return '* Required';
                                  }

                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintStyle: Constants.TEXT_STYLE_INPUT_HINT_2,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),

                      _dotBuilder(screenWidth, screenHeight),

                      // 2nd - duration
                      Container(
                        child: Row(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              width: screenWidth * 0.1,
                              child: Icon(
                                Icons.timelapse_rounded,
                                size: 27,
                                color: Constants.COLOR_ORANGE_PANTONE,
                              ),
                            ),

                            Expanded(
                              child: DropdownButtonFormField(
                                value: _selectedDuration,
                                items: _durationItemList,
                                onChanged: (newValue) => _updateDurationField(newValue),
                                hint: Text(
                                  'Duration',
                                  style: Constants.TEXT_STYLE_INPUT_HINT_2,
                                ),
                                validator: (value) {
                                  if (_selectedDuration == null) {
                                    return '* Required';
                                  }

                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintStyle: Constants.TEXT_STYLE_INPUT_HINT_2,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),

                      _dotBuilder(screenWidth, screenHeight),

                      // 3rd - number of person
                      Container(
                        child: Row(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              width: screenWidth * 0.1,
                              child: Icon(
                                Icons.group_rounded,
                                size: 27,
                                color: Constants.COLOR_ROYAL_PURPLE,
                              ),
                            ),

                            Expanded(
                              child: DropdownButtonFormField(
                                value: _selectedNumberOfPerson,
                                items: _numOfPersonItemList,
                                onChanged: (newValue) => _updateNumOfPerson(newValue),
                                hint: Text(
                                  'Number of Person',
                                  style: Constants.TEXT_STYLE_INPUT_HINT_2,
                                ),
                                validator: (value) {
                                  if (_selectedNumberOfPerson == null) {
                                    return '* Required';
                                  }

                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintStyle: Constants.TEXT_STYLE_INPUT_HINT_2,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),

                      widget.roomId == null ? _dotBuilder(screenWidth, screenHeight) : Container(),

                      // 4th  - room
                      widget.roomId == null ? Container(
                        child: Row(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              width: screenWidth * 0.1,
                              child: Icon(
                                Icons.meeting_room_rounded,
                                size: 27,
                                color: Constants.COLOR_MIDNIGHT_BLUE,
                              ),
                            ),

                            Expanded(
                              child: DropdownButtonFormField(
                                value: _selectedRoom,
                                items: _roomItemList,
                                onChanged: (newValue) => _updateRoom(newValue),
                                hint: Text(
                                  'Room',
                                  style: Constants.TEXT_STYLE_INPUT_HINT_2,
                                ),
                                validator: (value) {
                                  if (_selectedRoom == null) {
                                    return '* Required';
                                  }

                                  if (int.parse(_selectedNumberOfPerson) > 4
                                      && (_selectedRoom == 'DR006' ||
                                      _selectedRoom == 'DR007') ||
                                  _selectedRoom == 'DR008') {
                                    return 'Exceed seat limit';
                                  }

                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintStyle: Constants.TEXT_STYLE_INPUT_HINT_2,
                                ),
                              ),
                            )
                          ],
                        ),
                      ) : Container(),

                      _dotBuilder(screenWidth, screenHeight),

                      // 5th - description
                      Container(
                        child: Row(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              width: screenWidth * 0.1,
                              child: Icon(
                                Icons.description_rounded,
                                size: 27,
                                color: Constants.COLOR_MEDIUM_SLATE_BLUE,
                              ),
                            ),

                            Expanded(
                              child: TextFormField(
                                controller: _descriptionFieldController,
                                decoration: InputDecoration(
                                  hintText: 'Description (Optional)',
                                  hintStyle: Constants.TEXT_STYLE_INPUT_HINT_2,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Positioned(
              bottom: screenHeight * 0.05,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.07),
                  width: screenWidth,
                  child: ProgressButton(
                    onPressed: () => _formKey.currentState.validate() ? _confirmBookingButtonHandler(
                      _selectedTime == ""
                      ? DateTime.parse(_dateFormatter.format(_currentTime) + " 08:00:00.000").toUtc().millisecondsSinceEpoch.toString().substring(0, 10)
                      : DateTime.parse(_selectedTime).toUtc().millisecondsSinceEpoch.toString().substring(0, 10),
                      _selectedDuration,
                      _selectedNumberOfPerson,
                      _selectedRoom,
                      _descriptionFieldController.text,
                    ) : ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Invalid input.',
                          style: Constants.TEXT_STYLE_SNACK_BAR_CONTENT,
                        ),
                        backgroundColor: Constants.COLOR_RED,
                      ),
                    ),
                    progressIndicatorAligment: MainAxisAlignment.center,
                    progressIndicatorSize: 25.0,
                    state: _confirmState,
                    padding: EdgeInsets.all(8.0),
                    stateWidgets: {
                      ButtonState.idle: Text(
                        "Confirm Booking",
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
          ]
        ),
      ),
    );
  }
}