import 'package:ap_lib/authenticate/authentication_handler.dart';
import 'package:ap_lib/reading_history/reading_history_book_list_component.dart';
import 'package:ap_lib/reading_history/reading_history_data_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import 'reading_history_model.dart';
import 'package:ap_lib/enum/enum_state.dart';

class ReadingHistoryPage extends StatefulWidget {
  @override
  _ReadingHistoryPageState createState() => _ReadingHistoryPageState();
}

class _ReadingHistoryPageState extends State<ReadingHistoryPage> with TickerProviderStateMixin {
  TabController _tabController;
  ReadingHistoryDataProvider _readingHistoryDataProvider;
  AuthenticationHandler _authenticationHandler;

  int _selectedTabIndex = 0;

  LoadState _loadState = LoadState.Loading;

  List<ReadingHistoryModel> _activeReadingHistoryList = [];
  List<ReadingHistoryModel> _allReadingHistoryList = [];

  Future<List<ReadingHistoryModel>> _fetchActiveReadingHistory() async {
    String userToken = await _authenticationHandler.getToken();
    return await _readingHistoryDataProvider.getActiveReadingHistoryList(userToken);
  }

  Future<List<ReadingHistoryModel>> _fetchAllReadingHistory() async {
    String userToken = await _authenticationHandler.getToken();
    return await _readingHistoryDataProvider.getAllReadingHistoryList(userToken);
  }

  _back(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    _readingHistoryDataProvider = new ReadingHistoryDataProvider();
    _authenticationHandler = new AuthenticationHandler();

    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    });

    _fetchActiveReadingHistory().then((list) => {
      _activeReadingHistoryList = list,
      _fetchAllReadingHistory().then((list) => {
        _allReadingHistoryList = list,
        setState(() {
          _loadState = LoadState.Done;
        }),
      }),
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
        child: Container(
          padding: EdgeInsets.fromLTRB(screenWidth * 0.05, screenHeight * 0.02, screenWidth * 0.05, 0.0),
          child: Column(
            children: [
              // page title
              Container(
                width: screenWidth,
                child: Text(
                  'Reading History',
                  style: Constants.TEXT_STYLE_HEADING_1,
                ),
              ),

              // tab options
              Container(
                alignment: Alignment.center,
                child: Container(
                  width: 150.0,
                  padding: EdgeInsets.only(top: 30.0, bottom: 10.0),
                  height: 70.0,
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
                            "Current",
                            style: Constants.TEXT_STYLE_DETAILS_TAB_BAR_TEXT_SELECTED,
                          ),
                        ),
                      ),
                      Tab(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(9.0, 2.0, 9.0, 0.0),
                          child: Text(
                            "History",
                            style: Constants.TEXT_STYLE_DETAILS_TAB_BAR_TEXT_SELECTED,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // tab view
              Expanded(
                child: TabBarView(
                  physics: BouncingScrollPhysics(),
                  controller: _tabController,
                  children: [
                    Container(
                      height: 10,
                      child: _loadState == LoadState.Loading ? ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: 1,
                        itemBuilder: (BuildContext context, int index) {
                          return ReadingHistoryBookListComponent(
                            loadState: _loadState,
                          );
                        },
                      ) : _activeReadingHistoryList.length == 0 ? Container(
                        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.019),
                        child: Text(
                          'No reading history found.',
                          style: Constants.TEXT_STYLE_NON_ALTERNATIVE_TEXT,
                        ),
                      ) : ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: _activeReadingHistoryList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ReadingHistoryBookListComponent(
                            loadState: _loadState,
                            itemId: _activeReadingHistoryList[index].itemId,
                            imageUrl: _activeReadingHistoryList[index].imageUrl,
                            bookTitle: _activeReadingHistoryList[index].bookTitle,
                            bookAuthor: _activeReadingHistoryList[index].bookAuthor,
                            loanDateTime: _activeReadingHistoryList[index].loanDateTime,
                            dueDateTime: _activeReadingHistoryList[index].dueDate,
                            activeList: true,
                            renew: _activeReadingHistoryList[index].renew,
                            loanRecordId: _activeReadingHistoryList[index].loanRecordId,
                          );
                        },
                      ),
                    ),
                    Container(
                      height: 10,
                      child: _loadState == LoadState.Loading ? ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: 1,
                        itemBuilder: (BuildContext context, int index) {
                          return ReadingHistoryBookListComponent(
                            loadState: _loadState,
                          );
                        },
                      ) : _allReadingHistoryList.length == 0 ? Container(
                        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.019),
                        child: Text(
                          'No reading history found.',
                          style: Constants.TEXT_STYLE_NON_ALTERNATIVE_TEXT,
                        ),
                      ) : ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: _allReadingHistoryList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ReadingHistoryBookListComponent(
                            loadState: _loadState,
                            itemId: _allReadingHistoryList[index].itemId,
                            imageUrl: _allReadingHistoryList[index].imageUrl,
                            bookTitle: _allReadingHistoryList[index].bookTitle,
                            bookAuthor: _allReadingHistoryList[index].bookAuthor,
                            loanDateTime: _allReadingHistoryList[index].loanDateTime,
                            returnDateTime: _allReadingHistoryList[index].returnDateTime == null ? '' : _allReadingHistoryList[index].returnDateTime,
                            activeList: false,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}