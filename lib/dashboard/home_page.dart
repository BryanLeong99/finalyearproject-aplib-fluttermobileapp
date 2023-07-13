import 'package:ap_lib/enum/enum_state.dart';
import 'package:ap_lib/news_announcement/news_announcement_data_provider.dart';
import 'package:ap_lib/news_announcement/news_announcement_details_webview_page.dart';
import 'package:ap_lib/news_announcement/news_announcement_model.dart';
import 'package:ap_lib/reading_history/reading_history_data_provider.dart';
import 'package:ap_lib/reading_history/reading_history_model.dart';
import 'package:ap_lib/reading_history/reading_history_page.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ap_lib/authenticate/authentication_handler.dart';
import 'package:shimmer/shimmer.dart';
import '../constants.dart';
import 'home_reading_history_list_component.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  NewsAnnouncementDataProvider _newsAnnouncementDataProvider;
  CarouselController _carouselController;
  ReadingHistoryDataProvider _readingHistoryDataProvider;
  AuthenticationHandler _authenticationHandler;

  int _currentSlideIndex = 0;

  List<NewsAnnouncementModel> _newsAnnouncementList;
  List<String> _newsAnnouncementEmptyList = [
    '',
    '',
    '',
    '',
    '',
  ];
  List<ReadingHistoryModel> _allReadingHistoryList;
  LoadState _loadState = LoadState.Loading;

  Future<List<NewsAnnouncementModel>> _fetchNewsAnnouncementList() async {
    return _newsAnnouncementDataProvider.getNewsAnnouncementList();
  }

  Future<List<ReadingHistoryModel>> _fetchAllReadingHistory() async {
    String userToken = await _authenticationHandler.getToken();
    return await _readingHistoryDataProvider.getAllReadingHistoryList(userToken);
  }

  _viewAllReadingHistory() {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => ReadingHistoryPage()),
    );
  }

  _viewNewsAnnouncementDetails(String newsAnnouncementUrl) {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => NewsAnnouncementDetailsWebviewPage(
        newsAnnouncementUrl: newsAnnouncementUrl,
      )),
    );
  }

  @override
  void initState() {
    super.initState();
    _newsAnnouncementDataProvider = new NewsAnnouncementDataProvider();
    _carouselController = new CarouselController();
    _readingHistoryDataProvider = new ReadingHistoryDataProvider();
    _authenticationHandler = new AuthenticationHandler();

    _fetchNewsAnnouncementList().then((list) => {
      if (mounted) {
        setState(() {
          _newsAnnouncementList = list;
          if (_allReadingHistoryList != null) {
            _loadState = LoadState.Done;
          }
        }),
      }
    });

    _fetchAllReadingHistory().then((list) => {
      if (mounted) {
        setState(() {
          _allReadingHistoryList = list;
          if (_newsAnnouncementList != null) {
            _loadState = LoadState.Done;
          }
        }),
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        padding: EdgeInsets.fromLTRB(screenWidth * 0.035, screenHeight * 0.02, screenWidth * 0.035, 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // page title
            Container(
              padding: EdgeInsets.only(bottom: screenHeight * 0.005),
              child: Text(
                "Welcome back",
                style: Constants.TEXT_STYLE_HEADING_1,
              ),
            ),

            // announcement banner carousel
            Container(
              child: CarouselSlider(
                carouselController: _carouselController,
                options: CarouselOptions(
                  height: screenHeight * 0.25,
                  enableInfiniteScroll: true,
                  autoPlay: true,
                  autoPlayCurve: Curves.easeInOutCubic,
                  onPageChanged: (index, reason) => {
                    setState(() {
                      _currentSlideIndex = index;
                    }),
                  },
                ),
                // _newsAnnouncementEmptyList
                items: _loadState == LoadState.Loading ? _newsAnnouncementEmptyList.map((emptyElement) => Shimmer.fromColors(
                  baseColor: Constants.COLOR_SILVER_LIGHTER,
                  highlightColor: Constants.COLOR_PLATINUM_LIGHT,
                  child: Container(
                    width: screenWidth * 0.7,
                    margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.025, vertical: 15),
                    decoration: BoxDecoration(
                      color: Constants.COLOR_SILVER_LIGHTER,
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                  ),
                )).toList() : _newsAnnouncementList.map((newsAnnouncement) => GestureDetector(
                  onTap: () => _viewNewsAnnouncementDetails(newsAnnouncement.newsAnnouncementUrl),
                  child: Container(
                    width: screenWidth * 0.7,
                    margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.025, vertical: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32.0),
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
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(32.0),
                      child: Image.network(
                        newsAnnouncement.imageUrl,
                        fit: BoxFit.cover,
                      )),
                    ),
                ),
                ).toList(),
              ),
            ),

            // slide indicator
            Container(
              alignment: Alignment.center,
              child: DotsIndicator(
                dotsCount: _loadState == LoadState.Loading ? 5 : _newsAnnouncementList.length,
                position: _currentSlideIndex.toDouble(),
                decorator: DotsDecorator(
                  size: const Size.square(9.0),
                  activeSize: const Size(18.0, 9.0),
                  activeColor: Constants.COLOR_BLUE_SECONDARY,
                  activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                ),
              ),
            ),

            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // reading history section title
                Container(
                  margin: EdgeInsets.only(top: screenHeight * 0.02, bottom: screenHeight * 0.01),
                  child: Text(
                    'Reading History',
                    style: Constants.TEXT_STYLE_HEADING_3,
                  ),
                ),

                // view all button
                GestureDetector(
                  onTap: () => _viewAllReadingHistory(),
                  child: Container(
                    child: Text(
                      'View All',
                      style: Constants.TEXT_STYLE_TEXT_BUTTON,
                    ),
                  ),
                ),
              ],
            ),

            Expanded(
              child: _loadState == LoadState.Loading ? ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: 2,
                itemBuilder: (BuildContext context, int index) => HomeReadingHistoryListComponent(
                  loadState: _loadState,
                ),
              ) : _allReadingHistoryList.length == 0 ? Container(
                child: Text(
                  'No reading history found.',
                  style: Constants.TEXT_STYLE_NON_ALTERNATIVE_TEXT,
                ),
              ) : ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: _allReadingHistoryList.length,
                itemBuilder: (BuildContext context, int index) => HomeReadingHistoryListComponent(
                  loadState: _loadState,
                  image: Image.network(
                    _allReadingHistoryList[index].imageUrl,
                    fit: BoxFit.cover,
                  ),
                  itemId: _allReadingHistoryList[index].itemId,
                  bookTitle: _allReadingHistoryList[index].bookTitle,
                  bookAuthor: _allReadingHistoryList[index].bookAuthor,
                  loanDate: _allReadingHistoryList[index].loanDateTime,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}