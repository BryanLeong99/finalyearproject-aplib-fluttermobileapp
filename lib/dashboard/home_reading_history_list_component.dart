import 'package:ap_lib/enum/enum_state.dart';
import 'package:ap_lib/search_catalogue/book_details_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../constants.dart';

class HomeReadingHistoryListComponent extends StatefulWidget {
  final LoadState loadState;
  final Image image;
  final String itemId;
  final String bookTitle;
  final String bookAuthor;
  final String loanDate;

  HomeReadingHistoryListComponent({
    @required this.loadState,
    @required this.image,
    @required this.itemId,
    @required this.bookTitle,
    @required this.bookAuthor,
    @required this.loanDate,
  });

  @override
  _HomeReadingHistoryListComponentState createState() => _HomeReadingHistoryListComponentState();
}

class _HomeReadingHistoryListComponentState extends State<HomeReadingHistoryListComponent> {
  DateFormat _dateFormatter;

  _viewDetails(String itemId, Image imageData) {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => BookDetailsPage(imageData: imageData, itemId: itemId,)),
    );
  }

  @override
  void initState() {
    super.initState();
    _dateFormatter = new DateFormat('dd MMM yy');
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      child: Row(
        children: [
          widget.loadState == LoadState.Loading ? Shimmer.fromColors(
            baseColor: Constants.COLOR_SILVER_LIGHTER,
            highlightColor: Constants.COLOR_PLATINUM_LIGHT,
            child: Container(
              height: screenHeight * 0.11,
              width: screenWidth * 0.16,
              margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
              decoration: BoxDecoration(
                color: Constants.COLOR_SILVER_LIGHTER,
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ) : GestureDetector(
            onTap: () => _viewDetails(widget.itemId, widget.image),
            child: Hero(
              tag: widget.itemId,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                height: screenHeight * 0.11,
                width: screenWidth * 0.16,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: Constants.COLOR_GRAY_BOX_SHADOW,
                        offset: Offset(0.0, 5.0),
                        blurRadius: 5.0,
                        spreadRadius: 1.0,
                      ),
                    ],
                  ),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                  child: widget.image,
                )
              ),
            ),
          ),

          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                widget.loadState == LoadState.Loading ? Shimmer.fromColors(
                  baseColor: Constants.COLOR_SILVER_LIGHTER,
                  highlightColor: Constants.COLOR_PLATINUM_LIGHT,
                  child: Container(
                    height: screenHeight * 0.02,
                    width: screenWidth * 0.325,
                    margin: EdgeInsets.only(left: screenWidth * 0.04),
                    decoration: BoxDecoration(
                      color: Constants.COLOR_SILVER_LIGHTER,
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                ) : GestureDetector(
                  onTap: () => _viewDetails(widget.itemId, widget.image),
                  child: Container(
                    margin: EdgeInsets.only(left: screenWidth * 0.04),
                    child: Text(
                      widget.bookTitle,
                      style: Constants.TEXT_STYLE_CARD_TITLE_1,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),

                widget.loadState == LoadState.Loading ? Shimmer.fromColors(
                  baseColor: Constants.COLOR_SILVER_LIGHTER,
                  highlightColor: Constants.COLOR_PLATINUM_LIGHT,
                  child: Container(
                    height: screenHeight * 0.02,
                    width: screenWidth * 0.325,
                    margin: EdgeInsets.only(left: screenWidth * 0.04, top: screenHeight * 0.005),
                    decoration: BoxDecoration(
                      color: Constants.COLOR_SILVER_LIGHTER,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                ) : GestureDetector(
                  onTap: () => _viewDetails(widget.itemId, widget.image),
                  child: Container(
                    margin: EdgeInsets.only(left: screenWidth * 0.04, top: screenHeight * 0.005),
                    child: Text(
                      widget.bookAuthor,
                      style: Constants.TEXT_STYLE_CARD_SUB_TITLE_8,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            )
          ),

          Expanded(
            flex: 3,
            child: widget.loadState == LoadState.Loading ? Shimmer.fromColors(
              baseColor: Constants.COLOR_SILVER_LIGHTER,
              highlightColor: Constants.COLOR_PLATINUM_LIGHT,
              child: Container(
                height: screenHeight * 0.02,
                width: screenWidth * 0.01,
                margin: EdgeInsets.only(left: screenWidth * 0.04),
                decoration: BoxDecoration(
                  color: Constants.COLOR_SILVER_LIGHTER,
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ) : GestureDetector(
              onTap: () => _viewDetails(widget.itemId, widget.image),
              child: Container(
                margin: EdgeInsets.only(left: screenWidth * 0.04),
                child: Text(
                  _dateFormatter.format(DateTime.fromMillisecondsSinceEpoch(int.parse(widget.loanDate + '000'))),
                  style: Constants.TEXT_STYLE_CARD_DATE_1,
                ),
              ),
            ),
          ),

          Expanded(
            flex: 1,
            child: widget.loadState == LoadState.Loading ? Container(
              child: Icon(
                Icons.chevron_right_rounded,
                size: 25,
                color: Constants.COLOR_GRAY_LIGHT,
              ),
            ) : GestureDetector(
              onTap: () => _viewDetails(widget.itemId, widget.image),
              child: Container(
                child: Icon(
                  Icons.chevron_right_rounded,
                  size: 25,
                  color: Constants.COLOR_GRAY_LIGHT,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}