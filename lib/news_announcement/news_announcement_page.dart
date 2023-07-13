import 'package:ap_lib/enum/enum_state.dart';
import 'package:ap_lib/news_announcement/news_announcement_list_component.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import 'news_announcement_model.dart';
import 'news_announcement_data_provider.dart';

class NewsAnnouncementPage extends StatefulWidget {
  @override
  _NewsAnnouncementPageState createState() => _NewsAnnouncementPageState();
}

class _NewsAnnouncementPageState extends State<NewsAnnouncementPage> {
  NewsAnnouncementDataProvider _newsAnnouncementDataProvider;

  List<NewsAnnouncementModel> _newsAnnouncementList = [];
  LoadState _loadState = LoadState.Loading;

  Future<List<NewsAnnouncementModel>> _fetchNewsAnnouncementList() async {
    return _newsAnnouncementDataProvider.getNewsAnnouncementList();
  }

  @override
  void initState() {
    super.initState();

    _newsAnnouncementDataProvider = new NewsAnnouncementDataProvider();

    _fetchNewsAnnouncementList().then((list) => {
      if (mounted) {
        setState(() {
          _newsAnnouncementList = list;
          _loadState = LoadState.Done;
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
                "News & Announcements",
                style: Constants.TEXT_STYLE_HEADING_1,
              ),
            ),

            // news and announcement list component
            _loadState == LoadState.Loading ? Expanded(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: 4,
                itemBuilder: (BuildContext context, int index) => NewsAnnouncementListComponent(
                  loadState: LoadState.Loading,
                ),
              ),
            ) : _newsAnnouncementList.length == 0 ? Container(
              margin: EdgeInsets.only(top: screenHeight * 0.01),
              child: Text(
                'No news and announcement found.',
                style: Constants.TEXT_STYLE_NON_ALTERNATIVE_TEXT,
              ),
            ) : Expanded(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: _newsAnnouncementList.length,
                itemBuilder: (BuildContext context, int index) => NewsAnnouncementListComponent(
                  loadState: _loadState,
                  newsAnnouncementTitle: _newsAnnouncementList[index].newsAnnouncementTitle,
                  author: _newsAnnouncementList[index].author,
                  newsAnnouncementUrl: _newsAnnouncementList[index].newsAnnouncementUrl,
                  imageUrl: _newsAnnouncementList[index].imageUrl,
                  createdDate: _newsAnnouncementList[index].createdDate,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}