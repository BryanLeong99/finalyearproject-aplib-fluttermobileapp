import 'package:ap_lib/enum/enum_state.dart';
import 'package:ap_lib/fine/fine_history_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../constants.dart';

class FineHistoryListComponent extends StatefulWidget {
  final LoadState loadState;
  final String bookTitle;
  final String fineDateTime;
  final double amount;
  final bool lastElement;

  FineHistoryListComponent({
    @required this.loadState,
    @required this.bookTitle,
    @required this.fineDateTime,
    @required this.amount,
    @required this.lastElement,
  });

  @override
  _FineHistoryListComponentState createState() => _FineHistoryListComponentState();
}

class _FineHistoryListComponentState extends State<FineHistoryListComponent> {
  DateFormat _dateFormatter;

  @override
  void initState() {
    super.initState();
    _dateFormatter = new DateFormat.yMMMd('en_US');
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: widget.loadState == LoadState.Loading ? Shimmer.fromColors(
                        baseColor: Constants.COLOR_SILVER_LIGHTER,
                        highlightColor: Constants.COLOR_WHITE,
                        child: Container(
                          width: screenWidth * 0.6,
                          height: screenHeight * 0.037,
                          decoration: BoxDecoration(
                            color: Constants.COLOR_SILVER_LIGHTER,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ) : Container(
                        height: screenHeight * 0.038,
                        child: Text(
                          'Overdue fine of loan title: "' + widget.bookTitle + '"',
                          style: Constants.TEXT_STYLE_CARD_TITLE_4,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),

                    Container(
                      padding: EdgeInsets.only(top: screenHeight * 0.007),
                      child: widget.loadState == LoadState.Loading ? Shimmer.fromColors(
                        baseColor: Constants.COLOR_SILVER_LIGHTER,
                        highlightColor: Constants.COLOR_WHITE,
                        child: Container(
                          width: screenWidth * 0.15,
                          height: screenHeight * 0.017,
                          decoration: BoxDecoration(
                            color: Constants.COLOR_SILVER_LIGHTER,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ) : Text(
                        'RM ' + widget.amount.toStringAsFixed(2),
                        style: Constants.TEXT_STYLE_CARD_DATE_1,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                flex: 3,
                child: Container(
                  alignment: Alignment.centerRight,
                  child: widget.loadState == LoadState.Loading ? Shimmer.fromColors(
                    baseColor: Constants.COLOR_SILVER_LIGHTER,
                    highlightColor: Constants.COLOR_WHITE,
                    child: Container(
                      width: screenWidth * 0.25,
                      height: screenHeight * 0.015,
                      decoration: BoxDecoration(
                        color: Constants.COLOR_SILVER_LIGHTER,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ) : Text(
                    _dateFormatter.format(DateTime.fromMillisecondsSinceEpoch(int.parse(widget.fineDateTime + '000'))),
                    style: Constants.TEXT_STYLE_CARD_DATE_3,
                  ),
                ),
              ),
            ],
          ),

          !widget.lastElement ? Container(
            padding: EdgeInsets.symmetric(vertical: screenHeight * 0.008),
            child: Divider(
              color: Constants.COLOR_GRAY_LIGHT,
            ),
          ) : Container(),
        ],
      ),
    );
  }

}
