import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ap_lib/enum/enum_state.dart';
import '../constants.dart';
import 'package:ap_lib/authenticate/authentication_handler.dart';
import 'fine_history_data_provider.dart';
import 'fine_history_model.dart';
import 'fine_history_list_component.dart';
import 'fine_outstanding_history_page.dart';

class FinePaidHistoryPage extends StatefulWidget {
  @override
  _FinePaidHistoryPageState createState() => _FinePaidHistoryPageState();
}

class _FinePaidHistoryPageState extends State<FinePaidHistoryPage> {
  AuthenticationHandler _authenticationHandler;
  FineHistoryDataProvider _fineHistoryDataProvider;
  LoadState _loadState = LoadState.Loading;

  List<FineHistoryModel> _paidFineHistoryList;
  List<FineHistoryModel> _outstandingFineHistoryList;

  Future<List<FineHistoryModel>> _fetchPaidFineHistoryList() async {
    String userToken = await _authenticationHandler.getToken();
    return await _fineHistoryDataProvider.getFineHistoryModelList(1, userToken);
  }

  Future<List<FineHistoryModel>> _fetchOutstandingFineHistoryList() async {
    String userToken = await _authenticationHandler.getToken();
    return await _fineHistoryDataProvider.getFineHistoryModelList(0, userToken);
  }

  String _getOutstandingFine() {
    String _totalOutstanding = '0.00';
    if (_outstandingFineHistoryList != null && _outstandingFineHistoryList.length != 0) {
      _totalOutstanding = _outstandingFineHistoryList.reduce((a, b)
      => new FineHistoryModel(amount: a.amount + b.amount)).amount.toStringAsFixed(2);
    }
    return _totalOutstanding;
  }

  void _navigateToFineOutstandingHistoryPage() {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => FineOutstandingHistoryPage(outstandingFineHistoryList: _outstandingFineHistoryList,)),
    );
  }

  _back(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    _fineHistoryDataProvider = new FineHistoryDataProvider();
    _authenticationHandler = new AuthenticationHandler();

    _fetchPaidFineHistoryList().then((list) => {
      _paidFineHistoryList = list,
      if (_outstandingFineHistoryList != null) {
        setState(() {
          _loadState = LoadState.Done;
        }),
      }
    });

    _fetchOutstandingFineHistoryList().then((list) => {
      _outstandingFineHistoryList = list,
      if (_paidFineHistoryList != null) {
        setState(() {
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // page title
              Container(
                width: screenWidth,
                child: Text(
                  'Fine',
                  style: Constants.TEXT_STYLE_HEADING_1,
                ),
              ),

              GestureDetector(
                onTap: () => _navigateToFineOutstandingHistoryPage(),
                child: Container(
                  width: screenWidth - (screenWidth * 0.05) * 2,
                  height: screenHeight * 0.098,
                  margin: EdgeInsets.only(top: screenHeight * 0.03),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.0),
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
                      // left icon
                      Container(
                        height: screenHeight * 0.098,
                        width: screenWidth * 0.12,
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.025),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(6.0), bottomLeft: Radius.circular(6.0)),
                          color: Constants.COLOR_GREEN_LIGHT,
                        ),
                        child: Icon(
                          Icons.attach_money_rounded,
                          color: Constants.COLOR_WHITE,
                        ),
                      ),

                      // room text details
                      Container(
                        padding: EdgeInsets.only(left: screenWidth * 0.03),
                        height: screenHeight * 0.1,
                        width: screenWidth - ((screenWidth * 0.05) * 2) - (screenWidth * 0.2),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Text(
                                'Outstanding Fine',
                                style: Constants.TEXT_STYLE_CARD_TITLE_3,
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.only(top: screenHeight * 0.007),
                                  child: Text(
                                    'RM ' + _getOutstandingFine(),
                                    style: Constants.TEXT_STYLE_CARD_SUB_TITLE_5,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Icon(
                          Icons.chevron_right_rounded,
                          size: 25,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // paid history section title
              Container(
                padding: EdgeInsets.only(top: screenHeight * 0.03, bottom: screenHeight * 0.015),
                child: Text(
                  'Paid History',
                  style: Constants.TEXT_STYLE_HEADING_3,
                ),
              ),

              // history list
              Expanded(
                child: _loadState == LoadState.Loading ? ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: 1,
                  itemBuilder: (BuildContext context, int index) {
                    return FineHistoryListComponent(
                      loadState: _loadState,
                      lastElement: true,
                    );
                  },
                ) : _paidFineHistoryList.length == 0 ? Container(
                  child: Text(
                    'No paid fine history found.',
                    style: Constants.TEXT_STYLE_NON_ALTERNATIVE_TEXT,
                  ),
                ) : ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: _paidFineHistoryList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return FineHistoryListComponent(
                      loadState: _loadState,
                      bookTitle: _paidFineHistoryList[index].bookTitle,
                      amount: _paidFineHistoryList[index].amount,
                      fineDateTime: _paidFineHistoryList[index].fineDateTime,
                      lastElement: index + 1 != _paidFineHistoryList.length ? false : true,
                    );
                  },
                )
              ),
            ],
          ),
        ),
      ),
    );
  }

}