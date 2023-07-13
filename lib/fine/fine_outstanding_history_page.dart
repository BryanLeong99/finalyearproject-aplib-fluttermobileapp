import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ap_lib/enum/enum_state.dart';
import '../constants.dart';
import 'package:ap_lib/authenticate/authentication_handler.dart';
import 'fine_history_data_provider.dart';
import 'fine_history_model.dart';
import 'fine_history_list_component.dart';

class FineOutstandingHistoryPage extends StatefulWidget {
  final List<FineHistoryModel> outstandingFineHistoryList;

  FineOutstandingHistoryPage({
    @required this.outstandingFineHistoryList,
  });

  @override
  _FineOutstandingHistoryPageState createState() => _FineOutstandingHistoryPageState();
}

class _FineOutstandingHistoryPageState extends State<FineOutstandingHistoryPage> {
  _back(BuildContext context) {
    Navigator.pop(context);
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
                padding: EdgeInsets.only(bottom: screenHeight * 0.03),
                width: screenWidth,
                child: Text(
                  'Outstanding Fine',
                  style: Constants.TEXT_STYLE_HEADING_1,
                ),
              ),

              // history list
            widget.outstandingFineHistoryList.length == 0 ? Container(
              child: Text(
                'No outstanding fine found.',
                style: Constants.TEXT_STYLE_NON_ALTERNATIVE_TEXT,
              ),
            ) : Expanded(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: widget.outstandingFineHistoryList.length,
                itemBuilder: (BuildContext context, int index) {
                  return FineHistoryListComponent(
                    loadState: LoadState.Done,
                    bookTitle: widget.outstandingFineHistoryList[index].bookTitle,
                    amount: widget.outstandingFineHistoryList[index].amount,
                    fineDateTime: widget.outstandingFineHistoryList[index].fineDateTime,
                    lastElement: index + 1 != widget.outstandingFineHistoryList.length ? false : true,
                  );
                },
              ),
            ),
            ],
          ),
        ),
      ),
    );
  }

}