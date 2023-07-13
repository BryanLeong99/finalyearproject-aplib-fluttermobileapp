import 'package:ap_lib/enum/enum_state.dart';
import 'package:ap_lib/interlibrary_loan/ill_request_list_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'ill_request_details_page.dart';

import '../constants.dart';

class IllRequestListComponent extends StatefulWidget {
  final List<IllRequestListModel> illRequestList;
  final LoadState loadState;

  IllRequestListComponent({
    @required this.illRequestList,
    @required this.loadState,
  });

  @override
  _IllRequestListComponentState createState() => _IllRequestListComponentState();
}

class _IllRequestListComponentState extends State<IllRequestListComponent> {
  DateFormat _dateFormatter;

  Color _statusColor(String status) {
    if (status == "Received") {
      return Constants.COLOR_BLUE_SECONDARY;
    } else if (status == "Approved") {
      return Constants.COLOR_RAZZLE_DAZZLE_ROSE;
    } else if (status == "Processing Request") {
      return Constants.COLOR_MEDIUM_BLUE;
    } else if (status == "Ready to Collect") {
      return Constants.COLOR_MAXIMUM_YELLOW_RED;
    } else if (status == "Closed") {
      return Constants.COLOR_GREEN_LIGHT;
    }

    return Constants.COLOR_RED;
  }

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

  void _viewDetails(String illRequestID, String currentStatus) {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => IllRequestDetailsPage(illRequestId: illRequestID, currentStatus: currentStatus,))
    );
  }

  Widget _buildRequestList(BuildContext context, int index, double screenWidth, double screenHeight) {
    return GestureDetector(
      onTap: () => _viewDetails(widget.illRequestList[index].requestId, widget.illRequestList[index].status),
      child: Container(
        child: Column(
          children: [
            Container(
              width: screenWidth - (screenWidth * 0.05) * 2,
              // height: screenHeight * 0.06,
              margin: EdgeInsets.symmetric(vertical: screenHeight * 0.005),
              child: Row(
                children: [
                  Container(
                    width: screenWidth * 0.11,
                    height: screenWidth * 0.11,
                    decoration: BoxDecoration(
                      color: _statusColor(widget.illRequestList[index].status),
                      shape: BoxShape.circle,
                    ),
                    child: _statusIcon(widget.illRequestList[index].status),
                  ),

                  Expanded(
                    flex: 9,
                    child: Container(
                      padding: EdgeInsets.only(left: screenWidth * 0.04),
                      // width: screenWidth * 0.72,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            // width: screenWidth * 0.65,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  widget.illRequestList[index].status,
                                  style: Constants.TEXT_STYLE_CARD_TITLE_1,
                                ),

                                Text(
                                  _dateFormatter.format(DateTime.fromMillisecondsSinceEpoch(int.parse(widget.illRequestList[index].dateTime + '000'))),
                                  style: Constants.TEXT_STYLE_CARD_DATE_1,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),

                          Container(
                            padding: EdgeInsets.only(top: screenHeight * 0.003),
                            child: Text(
                              'Title: ' + widget.illRequestList[index].title,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.only(left: screenWidth * 0.03),
                      child: Icon(
                        Icons.chevron_right_rounded,
                        size: 27.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Container(
              padding: EdgeInsets.symmetric(vertical: screenHeight * 0.008),
              child: index + 1 != widget.illRequestList.length ? Divider(
                color: Constants.COLOR_GRAY_LIGHT,
              ) : Container(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _dateFormatter = new DateFormat.yMMMd('en_US');
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return widget.loadState == LoadState.Loading ? Shimmer.fromColors(
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
      ),
    ) : widget.illRequestList.length == 0
      ? Container(
          height: screenHeight * 0.1,
          padding: EdgeInsets.only(top: screenHeight * 0.015),
          child: Text(
            "No request found.",
            style: Constants.TEXT_STYLE_NON_ALTERNATIVE_TEXT,
          ),
        )
      : Expanded(
          // height: screenHeight * 0.4,
          // color: Colors.purple,
          // padding: EdgeInsets.only(top: screenHeight * 0.005),
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: widget.illRequestList.length,
            itemBuilder: (BuildContext context, int index) => _buildRequestList(context, index, screenWidth, screenHeight),
          )
        );
  }

}