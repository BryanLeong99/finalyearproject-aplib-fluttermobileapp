import 'dart:ffi';

import 'package:ap_lib/search_catalogue/book_data_fetcher.dart';
import 'package:ap_lib/search_catalogue/book_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:shimmer/shimmer.dart';
import 'library_map_page.dart';

import '../constants.dart';

class BookDetailsPage extends StatefulWidget {
  final Image imageData;
  final String itemId;

  BookDetailsPage({
    @required this.imageData,
    @required this.itemId
  });

  @override
  _BookDetailsPageState createState() => _BookDetailsPageState();
}

class _BookDetailsPageState extends State<BookDetailsPage> with TickerProviderStateMixin {
  TabController _tabController;
  BookDataFetcher _bookDataFetcher = new BookDataFetcher();
  BookModel _bookModel;
  int _selectedTabIndex = 0;

  Future<BookModel> _fetchData() async {
    return await _bookDataFetcher.getBookDetails(widget.itemId);
  }

  _viewMap(int xCoordinate, int yCoordinate) {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => LibraryMapPage(
        xCoordinate: xCoordinate,
        yCoordinate: yCoordinate,
      )),
    );
  }

  _back(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    _fetchData().then((bookModel) => {
      setState(() {
        _bookModel = bookModel;
      }),
    });
    _tabController = TabController(length: 3, vsync: this);

    _tabController.addListener(() {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
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
      body: Container(
        height: screenHeight,
        width: screenWidth,
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
        child: Column(
          children: [
            // top (title, author) section
            Container(
              padding: EdgeInsets.only(top: screenHeight * 0.03),
              child: Row(
                children: [
                  // book image
                  Hero(
                    tag: widget.itemId,
                    child: Container(
                      width: screenWidth * 0.32,
                      height: screenHeight * 0.23,
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
                        child: widget.imageData,
                      ),
                    ),
                  ),

                  // book title, author and locate button
                  Container(
                    width: screenWidth - (screenWidth * 0.05 * 2) - (screenWidth * 0.32),
                    height: screenHeight * 0.22,
                    padding: EdgeInsets.only(left: screenWidth * 0.035),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // book title
                        Container(
                          child: _bookModel == null ? Shimmer.fromColors(
                            baseColor: Constants.COLOR_SILVER_LIGHTER,
                            highlightColor: Constants.COLOR_WHITE,
                            child: Container(
                              color: Constants.COLOR_SILVER_LIGHTER,
                              height: screenHeight * 0.05
                            )
                          ) :
                          AutoSizeText(
                            _bookModel.bookTitle,
                            minFontSize: 16,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: Constants.TEXT_STYLE_BOOK_DETAILS_TITLE,
                          ),
                        ),

                        // book author
                        Container(
                          padding: EdgeInsets.only(top: screenHeight * 0.005),
                          child: _bookModel == null ? Shimmer.fromColors(
                            baseColor: Constants.COLOR_SILVER_LIGHTER,
                            highlightColor: Constants.COLOR_WHITE,
                            child: Container(
                              color: Constants.COLOR_SILVER_LIGHTER,
                              height: screenHeight * 0.03
                            )
                          ) :
                          Text(
                            _bookModel.bookAuthor,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Constants.TEXT_STYLE_BOOK_DETAILS_AUTHOR,
                          )
                        ),

                        // locate material button
                        _bookModel == null ? Shimmer.fromColors(
                          baseColor: Constants.COLOR_SILVER_LIGHTER,
                          highlightColor: Constants.COLOR_WHITE,
                          child: Container(
                            margin: EdgeInsets.only(top: screenHeight * 0.01),
                            height: screenHeight * 0.04,
                            decoration: BoxDecoration(
                              color: Constants.COLOR_SILVER_LIGHTER,
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                          ),
                        ) : _bookModel.callNumber != '' && _bookModel.libraryName == 'APU Library' && _bookModel.collectionName == 'Print Book'
                            ? Container(
                          padding: EdgeInsets.only(top: screenHeight * 0.01),
                          child: ElevatedButton.icon(
                            onPressed: () => _viewMap(_bookModel.xCoordinate, _bookModel.yCoordinate),
                            label: Text(
                              'Locate Material',
                              style: Constants.TEXT_STYLE_DETAILS_ACTION_BUTTON_TEXT,
                            ),
                            icon: Icon(
                              Icons.map_rounded,
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
                            // style: TextButton.styleFrom(
                            //   backgroundColor: Constants.COLOR_BLUE_MEDIUM_STATE,
                            // ),
                          ),
                        ) : Container(),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // bottom (details) section
            Container(
              alignment: Alignment.center,
              child: Container(
                width: 270.0,
                // padding: EdgeInsets.only(top: screenHeight * 0.04, bottom: screenHeight * 0.03),
                padding: EdgeInsets.only(top: 30.0, bottom: 28.0),
                height: 90.0,
                child: TabBar(
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.label,
                  labelPadding: EdgeInsets.zero,
                  unselectedLabelColor: Constants.COLOR_GRAY_LIGHT,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
                    color: Constants.COLOR_BLUE_SECONDARY,
                  ),
                  tabs: [
                    Tab(
                      child: Container(
                        padding: EdgeInsets.fromLTRB(9.0, 2.0, 9.0, 0.0),
                        child: Text(
                          "About",
                          style: Constants.TEXT_STYLE_DETAILS_TAB_BAR_TEXT_SELECTED,
                        ),
                      ),
                    ),
                    Tab(
                      child: Container(
                        padding: EdgeInsets.fromLTRB(9.0, 2.0, 9.0, 0.0),
                        child: Text(
                          "Summary",
                          style: Constants.TEXT_STYLE_DETAILS_TAB_BAR_TEXT_SELECTED,
                        ),
                      ),
                    ),
                    Tab(
                      child: Container(
                        padding: EdgeInsets.fromLTRB(9.0, 2.0, 9.0, 0.0),
                        child: Text(
                          "Contents",
                          style: Constants.TEXT_STYLE_DETAILS_TAB_BAR_TEXT_SELECTED,
                        ),
                      ),
                    ),
                  ]
                ),
              ),
            ),

            Expanded(
              child: TabBarView(
                physics: BouncingScrollPhysics(),
                controller: _tabController,
                children: [
                  Container(
                    child: Table(
                      columnWidths: {
                        0: FlexColumnWidth(1.4),
                        1: FlexColumnWidth(2),
                      },
                      children: [
                        TableRow(
                          children: [
                            TableCell(
                              child: Container(
                                padding: EdgeInsets.only(bottom: 10.0),
                                child: Text(
                                  'Availability:',
                                  style: Constants.TEXT_STYLE_DETAILS_TABLE_TITLE,
                                )
                              ),
                            ),
                            TableCell(
                              child: Container(
                                padding: EdgeInsets.only(bottom: 10.0),
                                child: _bookModel == null ? Shimmer.fromColors(
                                  baseColor: Constants.COLOR_SILVER_LIGHTER,
                                  highlightColor: Constants.COLOR_WHITE,
                                  child: Container(
                                    color: Constants.COLOR_SILVER_LIGHTER,
                                    height: screenHeight * 0.02
                                  )
                                ) :
                                Text(
                                  _bookModel.availabilityStatusName,
                                  style: Constants.TEXT_STYLE_DETAILS_TABLE_CONTENT,
                                ),
                              ),
                            ),
                          ]
                        ),
                        TableRow(
                          children: [
                            TableCell(
                              child: Container(
                                padding: EdgeInsets.only(bottom: 10.0),
                                child: Text(
                                  'ISBN:',
                                  style: Constants.TEXT_STYLE_DETAILS_TABLE_TITLE,
                                )
                              ),
                            ),
                            TableCell(
                              child: Container(
                                padding: EdgeInsets.only(bottom: 10.0),
                                child: _bookModel == null ? Shimmer.fromColors(
                                  baseColor: Constants.COLOR_SILVER_LIGHTER,
                                  highlightColor: Constants.COLOR_WHITE,
                                  child: Container(
                                    color: Constants.COLOR_SILVER_LIGHTER,
                                    height: screenHeight * 0.02
                                  )
                                ) :
                                Text(
                                  _bookModel.isbn,
                                  style: Constants.TEXT_STYLE_DETAILS_TABLE_CONTENT,
                                ),
                              ),
                            ),
                          ]
                        ),
                        TableRow(
                          children: [
                            TableCell(
                              child: Container(
                                padding: EdgeInsets.only(bottom: 10.0),
                                child: Text(
                                  'Physical Description:',
                                  style: Constants.TEXT_STYLE_DETAILS_TABLE_TITLE,
                                )
                              ),
                            ),
                            TableCell(
                              child: Container(
                                padding: EdgeInsets.only(bottom: 10.0),
                                child: _bookModel == null ? Shimmer.fromColors(
                                  baseColor: Constants.COLOR_SILVER_LIGHTER,
                                  highlightColor: Constants.COLOR_WHITE,
                                  child: Container(
                                    color: Constants.COLOR_SILVER_LIGHTER,
                                    height: screenHeight * 0.02
                                  )
                                ) :
                                Text(
                                  _bookModel.physicalDescription,
                                  style: Constants.TEXT_STYLE_DETAILS_TABLE_CONTENT,
                                ),
                              ),
                            ),
                          ]
                        ),
                        TableRow(
                          children: [
                            TableCell(
                              child: Container(
                                padding: EdgeInsets.only(bottom: 10.0),
                                child: Text(
                                  'Subject(s):',
                                  style: Constants.TEXT_STYLE_DETAILS_TABLE_TITLE,
                                )
                              ),
                            ),
                            TableCell(
                              child: Container(
                                padding: EdgeInsets.only(bottom: 10.0),
                                child: _bookModel == null ? Shimmer.fromColors(
                                  baseColor: Constants.COLOR_SILVER_LIGHTER,
                                  highlightColor: Constants.COLOR_WHITE,
                                  child: Container(
                                      color: Constants.COLOR_SILVER_LIGHTER,
                                      height: screenHeight * 0.02
                                  )
                                ) :
                                Container(
                                  child: Wrap(
                                    children: _bookModel.generateSubjectTextWidget(),
                                  ),
                                )
                              ),
                            ),
                          ]
                        ),
                        TableRow(
                          children: [
                            TableCell(
                              child: Container(
                                padding: EdgeInsets.only(bottom: 10.0),
                                child: Text(
                                  'Circulation Type:',
                                  style: Constants.TEXT_STYLE_DETAILS_TABLE_TITLE,
                                )
                              ),
                            ),
                            TableCell(
                              child: Container(
                                padding: EdgeInsets.only(bottom: 10.0),
                                child: _bookModel == null ? Shimmer.fromColors(
                                  baseColor: Constants.COLOR_SILVER_LIGHTER,
                                  highlightColor: Constants.COLOR_WHITE,
                                  child: Container(
                                    color: Constants.COLOR_SILVER_LIGHTER,
                                    height: screenHeight * 0.02
                                  )
                                ) :
                                Text(
                                  _bookModel.circulationName,
                                  style: Constants.TEXT_STYLE_DETAILS_TABLE_CONTENT,
                                )
                              ),
                            ),
                          ]
                        ),
                        TableRow(
                          children: [
                            TableCell(
                              child: Container(
                                padding: EdgeInsets.only(bottom: 10.0),
                                child: Text(
                                  'Collection Type:',
                                  style: Constants.TEXT_STYLE_DETAILS_TABLE_TITLE,
                                )
                              ),
                            ),
                            TableCell(
                              child: Container(
                                padding: EdgeInsets.only(bottom: 10.0),
                                child: _bookModel == null ? Shimmer.fromColors(
                                  baseColor: Constants.COLOR_SILVER_LIGHTER,
                                  highlightColor: Constants.COLOR_WHITE,
                                  child: Container(
                                    color: Constants.COLOR_SILVER_LIGHTER,
                                    height: screenHeight * 0.02
                                  )
                                ) :
                                Text(
                                  _bookModel.collectionName,
                                  style: Constants.TEXT_STYLE_DETAILS_TABLE_CONTENT,
                                )
                              ),
                            ),
                          ]
                        ),
                        TableRow(
                          children: [
                            TableCell(
                              child: Container(
                                padding: EdgeInsets.only(bottom: 10.0),
                                child: Text(
                                  'Copy Number:',
                                  style: Constants.TEXT_STYLE_DETAILS_TABLE_TITLE,
                                )
                              ),
                            ),
                            TableCell(
                              child: Container(
                                padding: EdgeInsets.only(bottom: 10.0),
                                child: _bookModel == null ? Shimmer.fromColors(
                                  baseColor: Constants.COLOR_SILVER_LIGHTER,
                                  highlightColor: Constants.COLOR_WHITE,
                                  child: Container(
                                    color: Constants.COLOR_SILVER_LIGHTER,
                                    height: screenHeight * 0.02
                                  )
                                ) :
                                Text(
                                  _bookModel.copyNumber,
                                  style: Constants.TEXT_STYLE_DETAILS_TABLE_CONTENT,
                                )
                              ),
                            ),
                          ]
                        ),
                        TableRow(
                          children: [
                            TableCell(
                              child: Container(
                                padding: EdgeInsets.only(bottom: 10.0),
                                child: Text(
                                  'Library:',
                                  style: Constants.TEXT_STYLE_DETAILS_TABLE_TITLE,
                                )
                              ),
                            ),
                            TableCell(
                              child: Container(
                                padding: EdgeInsets.only(bottom: 10.0),
                                child: _bookModel == null ? Shimmer.fromColors(
                                  baseColor: Constants.COLOR_SILVER_LIGHTER,
                                  highlightColor: Constants.COLOR_WHITE,
                                  child: Container(
                                    color: Constants.COLOR_SILVER_LIGHTER,
                                    height: screenHeight * 0.02
                                  )
                                ) :
                                Text(
                                  _bookModel.libraryName,
                                  style: Constants.TEXT_STYLE_DETAILS_TABLE_CONTENT,
                                )
                              ),
                            ),
                          ]
                        ),
                        TableRow(
                          children: [
                            TableCell(
                              child: Container(
                                padding: EdgeInsets.only(bottom: 10.0),
                                child: Text(
                                  'Call Number:',
                                  style: Constants.TEXT_STYLE_DETAILS_TABLE_TITLE,
                                )
                              ),
                            ),
                            TableCell(
                              child: Container(
                                padding: EdgeInsets.only(bottom: 10.0),
                                child: _bookModel == null ? Shimmer.fromColors(
                                  baseColor: Constants.COLOR_SILVER_LIGHTER,
                                  highlightColor: Constants.COLOR_WHITE,
                                  child: Container(
                                    color: Constants.COLOR_SILVER_LIGHTER,
                                    height: screenHeight * 0.02
                                  )
                                ) :
                                Text(
                                  _bookModel.callNumber == '' ? '-' : _bookModel.callNumber,
                                  style: Constants.TEXT_STYLE_DETAILS_TABLE_CONTENT,
                                )
                              ),
                            ),
                          ]
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: _bookModel == null ? Shimmer.fromColors(
                      baseColor: Constants.COLOR_SILVER_LIGHTER,
                      highlightColor: Constants.COLOR_WHITE,
                      child: Container(
                        color: Constants.COLOR_SILVER_LIGHTER,
                        height: screenHeight * 0.02
                      )
                    ) :
                    SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      physics: BouncingScrollPhysics(),
                      child: Text(
                        _bookModel.contentSummary == " " || _bookModel.contentSummary == ""
                            ? "No summary is found."
                            : _bookModel.contentSummary,
                        style: Constants.TEXT_STYLE_DETAILS_PASSAGE_CONTENT_1,
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: _bookModel == null ? Shimmer.fromColors(
                      baseColor: Constants.COLOR_SILVER_LIGHTER,
                      highlightColor: Constants.COLOR_WHITE,
                      child: Container(
                        color: Constants.COLOR_SILVER_LIGHTER,
                        height: screenHeight * 0.02
                      )
                    ) :
                    SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      physics: BouncingScrollPhysics(),
                      child: Text(
                        _bookModel.bookContent == " " || _bookModel.bookContent == ""
                            ? "No preview contents are found."
                            : _bookModel.bookContent,
                        style: Constants.TEXT_STYLE_DETAILS_PASSAGE_CONTENT_1,
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

}