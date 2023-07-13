import 'package:ap_lib/book_loan/complete_loan_page.dart';
import 'package:ap_lib/enum/enum_state.dart';
import 'package:ap_lib/reading_history/reading_history_data_provider.dart';
import 'package:ap_lib/search_catalogue/book_details_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../constants.dart';


class ReadingHistoryBookListComponent extends StatefulWidget {
  final LoadState loadState;
  final String itemId;
  final String imageUrl;
  final String bookTitle;
  final String bookAuthor;
  final String loanDateTime;
  final String dueDateTime;
  final String returnDateTime;
  final bool activeList;
  final int renew;
  final String loanRecordId;

  ReadingHistoryBookListComponent({
    this.loadState,
    this.itemId,
    this.imageUrl,
    this.bookTitle,
    this.bookAuthor,
    this.loanDateTime,
    this.dueDateTime,
    this.returnDateTime,
    this.activeList,
    this.renew,
    this.loanRecordId,
  });

  @override
  _ReadingHistoryBookListComponentState createState() => _ReadingHistoryBookListComponentState();
}

class _ReadingHistoryBookListComponentState extends State<ReadingHistoryBookListComponent> {
  DateFormat _dateFormatter;

  ReadingHistoryDataProvider _readingHistoryDataProvider;

  void _confirmRenew(String loanRecordId) {
    EasyLoading.show(
      status: 'Processing Request...',
      maskType: EasyLoadingMaskType.black,
    );

    _readingHistoryDataProvider.renewLoan(loanRecordId).then((response) => {
      EasyLoading.dismiss(),
      if (response[0].statusString == 'success') {
        Navigator.push(
          context,
          CupertinoPageRoute(builder: (context) => CompleteLoanPage(
            title: widget.bookTitle,
            dueDateTime: DateTime.fromMillisecondsSinceEpoch(int.parse(response[0].dueDate + '000')),
            loanDateTime: DateTime.fromMillisecondsSinceEpoch(int.parse(response[0].loanDateTime + '000')),
          )),
        ),
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              "Renew Failed",
              style: Constants.TEXT_STYLE_DIALOG_TITLE_AND_ACTION_1,
            ),
            content: Text(
              "Unexpected error occurred.",
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
        ),
      }
    });
  }
  
  void _renewButtonHandler(String loanRecordId, String bookTitle) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Confirm Renew?",
          style: Constants.TEXT_STYLE_DIALOG_TITLE_AND_ACTION_1,
        ),
        content: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Press ',
                style: Constants.TEXT_STYLE_DIALOG_CONTENT,
              ),
              TextSpan(
                text: 'Confirm',
                style: Constants.TEXT_STYLE_DIALOG_CONTENT_BOLD,
              ),
              TextSpan(
                text: ' to complete the loan renewal of ',
                style: Constants.TEXT_STYLE_DIALOG_CONTENT,
              ),
              TextSpan(
                text: bookTitle,
                style: Constants.TEXT_STYLE_DIALOG_CONTENT_BOLD,
              ),
              TextSpan(
                text: '.',
                style: Constants.TEXT_STYLE_DIALOG_CONTENT,
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              "Cancel",
              style: Constants.TEXT_STYLE_DIALOG_TITLE_AND_ACTION_2,
            ),
          ),
          TextButton(
            onPressed: () {
              _confirmRenew(loanRecordId);
            },
            child: Text(
              "Confirm",
              style: Constants.TEXT_STYLE_DIALOG_TITLE_AND_ACTION_1,
            ),
          ),
        ],
      ),
    );
  }

  void _viewDetails(String itemId, Image imageData) {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => BookDetailsPage(imageData: imageData, itemId: itemId,))
    );
  }

  @override
  void initState() {
    super.initState();
    _dateFormatter = new DateFormat.yMMMd('en_US');
    _readingHistoryDataProvider = new ReadingHistoryDataProvider();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final Image _bookImage =  widget.imageUrl == null ? null : Image.network(widget.imageUrl, fit: BoxFit.cover,);

    return Container(
      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.019),
      child: Row(
        children: [
          // book image
          Hero(
            tag: widget.itemId == null ? '' : widget.itemId,
            child: widget.loadState == LoadState.Loading ? Shimmer.fromColors(
              baseColor: Constants.COLOR_SILVER_LIGHTER,
              highlightColor: Constants.COLOR_PLATINUM_LIGHT,
              child: Container(
                width: screenWidth * 0.25,
                height: screenHeight * 0.16,
                decoration: BoxDecoration(
                  color: Constants.COLOR_SILVER_LIGHTER,
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
            ) :
            Container(
              width: screenWidth * 0.25,
              height: screenHeight * 0.16,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
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
                borderRadius: BorderRadius.circular(16.0),
                child: _bookImage,
              ),
            ),
          ),

          // book details
          Container(
            width: screenWidth - (screenWidth * 0.4),
            padding: EdgeInsets.only(left: screenWidth * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => _viewDetails(widget.itemId, _bookImage),
                  child: widget.loadState == LoadState.Loading ? Shimmer.fromColors(
                      baseColor: Constants.COLOR_SILVER_LIGHTER,
                      highlightColor: Constants.COLOR_PLATINUM_LIGHT,
                      child: Container(
                        color: Constants.COLOR_SILVER_LIGHTER,
                        width: screenWidth - (screenWidth * 0.05) * 2,
                        height: screenHeight * 0.022,
                      )
                  ) : Container(
                    child: Text(
                      widget.bookTitle,
                      style: Constants.TEXT_STYLE_BOOK_LIST_TITLE,
                      maxLines: widget.activeList ? 1 : 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),

                // author
                widget.loadState == LoadState.Loading ? Shimmer.fromColors(
                  baseColor: Constants.COLOR_SILVER_LIGHTER,
                  highlightColor: Constants.COLOR_PLATINUM_LIGHT,
                  child: Container(
                    color: Constants.COLOR_SILVER_LIGHTER,
                    width: screenWidth - (screenWidth * 0.05) * 2,
                    height: screenHeight * 0.015,
                    margin: EdgeInsets.only(top: screenHeight * 0.003),
                  ),
                ) : Container(
                  padding: EdgeInsets.only(top: screenHeight * 0.003),
                  child: Text(
                    'by ' + widget.bookAuthor,
                    style: Constants.TEXT_STYLE_BOOK_LIST_SUB_TITLE_1,
                    maxLines: widget.activeList ? 1 : 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                // material type, edition, publishing date, availability status
                widget.loadState == LoadState.Loading ? Shimmer.fromColors(
                  baseColor: Constants.COLOR_SILVER_LIGHTER,
                  highlightColor: Constants.COLOR_PLATINUM_LIGHT,
                  child: Container(
                    color: Constants.COLOR_SILVER_LIGHTER,
                    width: screenWidth - (screenWidth * 0.05) * 2,
                    height: screenHeight * 0.01,
                    margin: EdgeInsets.only(top: screenHeight * 0.01),
                  ),
                ) : Container(
                  padding: EdgeInsets.only(top: screenHeight * 0.01),
                  child: RichText(
                    // _resultBookList[index].collectionName + (_resultBookList[index].edition == "0" ? "" : " (${humanize.ordinal(int.parse(_resultBookList[index].edition))} ed)")  + ", " + _resultBookList[index].publishingYear + " (" + _resultBookList[index].availabilityStatus + ")",
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Loaning Date: ',
                          style: Constants.TEXT_STYLE_BOOK_LIST_SUB_TITLE_BOLD_3,
                        ),
                        TextSpan(
                          text: _dateFormatter.format(DateTime.fromMillisecondsSinceEpoch(int.parse(widget.loanDateTime + '000'))),
                          style: Constants.TEXT_STYLE_BOOK_LIST_SUB_TITLE_3,
                        ),
                      ],
                    ),

                  ),
                ),

                // library, call number
                widget.loadState == LoadState.Loading ? Shimmer.fromColors(
                  baseColor: Constants.COLOR_SILVER_LIGHTER,
                  highlightColor: Constants.COLOR_PLATINUM_LIGHT,
                  child: Container(
                    color: Constants.COLOR_SILVER_LIGHTER,
                    width: screenWidth - (screenWidth * 0.05) * 2,
                    height: screenHeight * 0.01,
                    margin: EdgeInsets.only(top: screenHeight * 0.0015),
                  ),
                ) : Container(
                  padding: EdgeInsets.only(top: screenHeight * 0.0015),
                  child: RichText(
                    // _resultBookList[index].callNumber == ""
                    //     ? _resultBookList[index].libraryName + ""
                    //     : _resultBookList[index].libraryName + ", " + _resultBookList[index].callNumber,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: widget.activeList ? 'Returning Due Date: ' : 'Returning Date: ',
                          style: Constants.TEXT_STYLE_BOOK_LIST_SUB_TITLE_BOLD_3,
                        ),
                        TextSpan(
                          text: (!widget.activeList && widget.returnDateTime == ' ') ? '-' : _dateFormatter.format(
                            DateTime.fromMillisecondsSinceEpoch(
                              int.parse(
                                (widget.activeList
                                  ? widget.dueDateTime
                                  : widget.returnDateTime) + '000'
                              )
                            )
                          ),
                          style: Constants.TEXT_STYLE_BOOK_LIST_SUB_TITLE_3,
                        ),
                      ],
                    ),
                  ),
                ),

                widget.loadState == LoadState.Loading ? Shimmer.fromColors(
                    baseColor: Constants.COLOR_SILVER_LIGHTER,
                    highlightColor: Constants.COLOR_PLATINUM_LIGHT,
                    child: Container(
                      color: Constants.COLOR_SILVER_LIGHTER,
                      width: screenWidth - (screenWidth * 0.05) * 2,
                      height: screenHeight * 0.022,
                    )
                ) : widget.renew != null && widget.renew < 3 ? Container(
                  padding: EdgeInsets.only(top: screenHeight * 0.0025),
                  child: ElevatedButton.icon(
                    onPressed: () => _renewButtonHandler(widget.loanRecordId, widget.bookTitle),
                    label: Text(
                      'Renew Period',
                      style: Constants.TEXT_STYLE_DETAILS_ACTION_BUTTON_TEXT,
                    ),
                    icon: Icon(
                      Icons.cached_rounded,
                      color: Constants.COLOR_WHITE,
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Constants.COLOR_BLUE_MEDIUM_STATE),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                      ),
                    ),
                  ),
                ) : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }

}