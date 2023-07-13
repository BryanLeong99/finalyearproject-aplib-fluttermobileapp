import 'package:ap_lib/enum/enum_state.dart';
import 'package:ap_lib/news_announcement/news_announcement_details_webview_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter/cupertino.dart';
import '../constants.dart';

class NewsAnnouncementListComponent extends StatefulWidget {
  final LoadState loadState;
  final String newsAnnouncementTitle;
  final String author;
  final String createdDate;
  final String newsAnnouncementUrl;
  final String imageUrl;

  NewsAnnouncementListComponent({
    @required this.loadState,
    @required this.newsAnnouncementTitle,
    @required this.author,
    @required this.createdDate,
    @required this.newsAnnouncementUrl,
    @required this.imageUrl,
  });

  @override
  _NewsAnnouncementListComponentState createState() => _NewsAnnouncementListComponentState();
}

class _NewsAnnouncementListComponentState extends State<NewsAnnouncementListComponent> {
  DateFormat _dateFormatter;

  void _navigateToDetailsWebViewPage(String newsAnnouncementUrl) {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => NewsAnnouncementDetailsWebviewPage(newsAnnouncementUrl: newsAnnouncementUrl)),
    );
  }

  @override
  void initState() {
    super.initState();
    _dateFormatter = new DateFormat('dd MMM yyyy');
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return widget.loadState == LoadState.Loading ? Shimmer.fromColors(
      baseColor: Constants.COLOR_SILVER_LIGHTER,
      highlightColor: Constants.COLOR_PLATINUM_LIGHT,
      child: Container(
        width: screenWidth - (screenWidth * 0.035) * 2,
        height: screenHeight * 0.15,
        margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
        decoration: BoxDecoration(
          color: Constants.COLOR_SILVER_LIGHTER,
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    ) : Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // card
          GestureDetector(
            onTap: () => _navigateToDetailsWebViewPage(widget.newsAnnouncementUrl),
            child: Container(
              width: screenWidth - (screenWidth * 0.035) * 2,
              // height: screenHeight * 0.098,
              margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01, horizontal: screenWidth * 0.01),
              padding: EdgeInsets.only(right: screenWidth * 0.03),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
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
                  // left image
                  Container(
                    height: screenHeight * 0.11,
                    width: screenWidth * 0.18,
                    margin: EdgeInsets.fromLTRB(screenWidth * 0.04, screenHeight * 0.02, screenWidth * 0.04, screenHeight * 0.02),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      color: Constants.COLOR_WHITE,
                      boxShadow: [
                        BoxShadow(
                          color: Constants.COLOR_GRAY_BOX_SHADOW,
                          offset: Offset(0.0, 5.0),
                          blurRadius: 4.0,
                          spreadRadius: 1.0,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: Image.network(
                        widget.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  // room text details
                  Expanded(
                    flex: 9,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // title
                        Container(
                          child: Text(
                            widget.newsAnnouncementTitle,
                            style: Constants.TEXT_STYLE_CARD_TITLE_1,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        // author
                        Container(
                          margin: EdgeInsets.only(bottom: screenHeight * 0.01),
                          child: Text(
                            widget.author,
                            style: Constants.TEXT_STYLE_CARD_SUB_TITLE_7,
                          ),
                        ),

                        // date created
                        Row(
                          children: [
                            Container(
                              child: Icon(
                                Icons.event_note_rounded,
                                size: 20,
                              ),
                            ),

                            Container(
                              padding: EdgeInsets.only(left: screenWidth * 0.01),
                              child: Text(
                                _dateFormatter.format(DateTime.fromMillisecondsSinceEpoch(int.parse(widget.createdDate + '000'))),
                                style: Constants.TEXT_STYLE_CARD_DATE_5,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Expanded(
                    flex: 1,
                    child: Icon(
                      Icons.chevron_right_rounded,
                      size: 25,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

}