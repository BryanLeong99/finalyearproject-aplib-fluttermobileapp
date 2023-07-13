import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants.dart';
import 'ill_data_provider.dart';
import 'ill_request_model.dart';

class IllRequestDetailsPage extends StatefulWidget {
  final String illRequestId;
  final String currentStatus;

  IllRequestDetailsPage({
    this.illRequestId,
    this.currentStatus,
  });

  @override
  _IllRequestDetailsPageState createState() => _IllRequestDetailsPageState();
}

class _IllRequestDetailsPageState extends State<IllRequestDetailsPage> {
  IllDataProvider _illDataProvider;
  DateFormat _dateFormatter;
  DateFormat _timeFormatter;

  List<IllRequestModel> _illRequestDetailsList = [];

  List<Color> _statusColorList = [
    Constants.COLOR_BLUE_SECONDARY,
    Constants.COLOR_RAZZLE_DAZZLE_ROSE,
    Constants.COLOR_MEDIUM_BLUE,
    Constants.COLOR_MAXIMUM_YELLOW_RED,
    Constants.COLOR_GREEN_LIGHT,
  ];

  List<Icon> _statusIconList = [
    Icon(
      Icons.fact_check_rounded,
      color: Constants.COLOR_WHITE,
    ),
    Icon(
      Icons.done_rounded,
      color: Constants.COLOR_WHITE,
    ),
    Icon(
      Icons.repeat_rounded,
      color: Constants.COLOR_WHITE,
    ),
    Icon(
      Icons.move_to_inbox_rounded,
      color: Constants.COLOR_WHITE,
    ),
    Icon(
      Icons.done_all_rounded,
      color: Constants.COLOR_WHITE,
    ),
  ];

  List<String> _statusMessageList = [
    'Your request has been received.',
    'Your request has been approved.',
    'Your request are in processing.',
    'Your requested material is ready.',
    'You have returned the material.'
  ];

  Icon _statusIcon(String status) {
    if (status == "Received") {
      return Icon(
        Icons.fact_check_rounded,
        color: Constants.COLOR_WHITE,
      );
    } else if (status == "Approved") {
      return Icon(
        Icons.done_rounded,
        color: Constants.COLOR_WHITE,
      );
    } else if (status == "Processing Request") {
      return Icon(
        Icons.repeat_rounded,
        color: Constants.COLOR_WHITE,
      );
    } else if (status == "Ready to Collect") {
      return Icon(
        Icons.move_to_inbox_rounded,
        color: Constants.COLOR_WHITE,
      );
    } else if (status == "Closed") {
      return Icon(
        Icons.done_all_rounded,
        color: Constants.COLOR_WHITE,
      );
    }

    return Icon(
      Icons.close_rounded,
      color: Constants.COLOR_WHITE,
    );
  }

  Widget _buildRequestStatusList(BuildContext context, int index, double screenWidth, double screenHeight, bool dataExists) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: screenWidth - (screenWidth * 0.05) * 2,
            // height: screenHeight * 0.06,
            margin: EdgeInsets.symmetric(vertical: screenHeight * 0.002),
            child: Row(
              children: [
                Container(
                  width: screenWidth * 0.11,
                  height: screenWidth * 0.11,
                  decoration: BoxDecoration(
                    color: _illRequestDetailsList.length == 0 || !dataExists
                        ? Constants.COLOR_PLATINUM_LIGHT
                        : _illRequestDetailsList[index].statusName == "Rejected"
                        ? Constants.COLOR_RED
                        : _statusColorList[index],
                    shape: BoxShape.circle,
                  ),
                  child:  _illRequestDetailsList.length == 0 || !dataExists
                      ? _statusIconList[index]
                      : _illRequestDetailsList[index].statusName == "Rejected"
                      ? Icon(Icons.close_rounded, color: Constants.COLOR_WHITE,)
                      : _statusIconList[index],
                ),

                Expanded(
                  flex: 10,
                  child: Container(
                    padding: EdgeInsets.only(left: screenWidth * 0.04),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.only(right: screenWidth * 0.03),
                                child: Text(
                                  _illRequestDetailsList.length == 0 || !dataExists ? ''
                                  : _dateFormatter.format(
                                    DateTime.fromMillisecondsSinceEpoch(int.parse(_illRequestDetailsList[index].statusDateTime + '000')),
                                  ),
                                  style: Constants.TEXT_STYLE_CARD_TITLE_1,
                                ),
                              ),

                              Text(
                                _illRequestDetailsList.length == 0 || !dataExists ? ''
                                : _timeFormatter.format(DateTime.fromMillisecondsSinceEpoch(int.parse(_illRequestDetailsList[index].statusDateTime + '000'))).padLeft(8, '0'),
                                style: Constants.TEXT_STYLE_CARD_ADDRESS_DATE_2,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),

                        Container(
                          padding: EdgeInsets.only(top: screenHeight * 0.003),
                          child: Text(
                            _illRequestDetailsList.length == 0 || !dataExists
                                ? '' : _illRequestDetailsList[index].statusName == "Rejected"
                                ? 'Your request has been rejected.'
                                : _statusMessageList[index],
                            style: Constants.TEXT_STYLE_CARD_SUB_TITLE_3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          Container(
            width: screenWidth * 0.11,
            padding: EdgeInsets.symmetric(vertical: screenHeight * 0.008),
            child: index != 4
            ? _dotBuilder(
              screenWidth,
              screenHeight,
              _illRequestDetailsList.length > index + 1
                  ? Constants.COLOR_BLUE_SECONDARY
                  : Constants.COLOR_PLATINUM_LIGHT,
            )
            : Container(),
          ),
        ],
      ),
    );
  }

  Widget _dotBuilder(double screenWidth, double screenHeight, Color dotColor) {
    return Container(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(bottom: screenHeight * 0.003),
            width: 27,
            child: Icon(
              Icons.circle,
              size: 6,
              color: dotColor,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: screenHeight * 0.003),
            width: 27,
            child: Icon(
              Icons.circle,
              size: 6,
              color: dotColor,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: screenHeight * 0.003),
            width: 27,
            child: Icon(
              Icons.circle,
              size: 6,
              color: dotColor,
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: screenHeight * 0.003),
            width: 27,
            child: Icon(
              Icons.circle,
              size: 6,
              color: dotColor,
            ),
          ),
        ],
      ),
    );
  }

  Future<List<IllRequestModel>> _fetchIllRequestDetails() async {
    return await _illDataProvider.getRequestDetails(widget.illRequestId);
  }

  _back(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    _illDataProvider = new IllDataProvider();
    _dateFormatter = new DateFormat.yMMMd('en_US');
    _timeFormatter = new DateFormat.jm();
    _fetchIllRequestDetails().then((list) => {
      setState(() => _illRequestDetailsList = list)
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // status title
                Container(
                  child: Text(
                    'Status: ' + widget.currentStatus,
                    style: Constants.TEXT_STYLE_HEADING_1,
                  ),
                ),

                // book title, organisation
                Container(
                  padding: EdgeInsets.only(top: screenHeight * 0.008, bottom: screenHeight * 0.03),
                  child: Text(
                    'Book: ' + (_illRequestDetailsList.length == 0 ? '' : _illRequestDetailsList[0].title) +
                        ', from ' + (_illRequestDetailsList.length == 0 ? '' : _illRequestDetailsList[0].organisation),
                    style: Constants.TEXT_STYLE_SUB_HEADING_3,
                  ),
                ),

                // 1st - received status
                _buildRequestStatusList(context, 0, screenWidth, screenHeight, true),

                // 2nd - approved status or reject status
                _buildRequestStatusList(context, 1, screenWidth, screenHeight, _illRequestDetailsList.length == 2 ? true : false),

                // 3rd - processing status
                _buildRequestStatusList(context, 2, screenWidth, screenHeight, _illRequestDetailsList.length == 3 ? true : false),

                // 4th - ready to collect status
                _buildRequestStatusList(context, 3, screenWidth, screenHeight, _illRequestDetailsList.length == 4 ? true : false),

                // 5th - closed status
                _buildRequestStatusList(context, 4, screenWidth, screenHeight, _illRequestDetailsList.length == 5 ? true : false),
              ],
            ),
          ),
        ),
      ),
    );
  }
}