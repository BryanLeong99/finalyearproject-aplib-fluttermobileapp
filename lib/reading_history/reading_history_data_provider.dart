import 'dart:convert';

import 'package:http/http.dart' as http;
import 'reading_history_model.dart';

class ReadingHistoryDataProvider {
  List<ReadingHistoryModel> _parseActiveReadingHistoryList(String responseBody) {
    print(responseBody);
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

    return parsed.map<ReadingHistoryModel>((json) => ReadingHistoryModel.fromJson(json)).toList();
  }

  Future<List<ReadingHistoryModel>> getActiveReadingHistoryList(String userToken) async {
    var url = Uri.parse(
        "https://zj9ohmm9uh.execute-api.us-east-1.amazonaws.com/dev/reading-history/active?" +
            "user_token=$userToken"
    );

    var response = await http.get(url,
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
        'Connection': 'keep-alive',
      },
    );

    return _parseActiveReadingHistoryList(response.body);
  }

  List<ReadingHistoryModel> _parseAllReadingHistoryList(String responseBody) {
    print(responseBody);
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

    return parsed.map<ReadingHistoryModel>((json) => ReadingHistoryModel.fromJson(json)).toList();
  }

  Future<List<ReadingHistoryModel>> getAllReadingHistoryList(String userToken) async {
    var url= Uri.parse(
        "https://zj9ohmm9uh.execute-api.us-east-1.amazonaws.com/dev/reading-history/all?" +
            "user_token=$userToken"
    );

    var response = await http.get(url,
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
        'Connection': 'keep-alive',
      },
    );

    return _parseAllReadingHistoryList(response.body);
  }

  Future<ReadingHistoryModel> createLoanRecordAPICall(String userToken,
      String itemId, String loanDateTime, String dueDateTime, String tag) async {
    var url = Uri.parse('https://zj9ohmm9uh.execute-api.us-east-1.amazonaws.com/dev/loan/new?' +
        'user_token=$userToken' +
        '&item_id=$itemId' +
        '&loan_datetime=$loanDateTime' +
        '&due_datetime=$dueDateTime' +
        '&tag=$tag'
    );

    var response = await http.post(url,
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
        'Connection': 'keep-alive',
      },
    );
    print(response.body);

    return ReadingHistoryModel.fromJson(jsonDecode(response.body));
  }

  Future<String> createLoanRecord(String userToken,
      String itemId, String loanDateTime, String dueDateTime, String tag) async {
    var status;
    await createLoanRecordAPICall(userToken, itemId, loanDateTime, dueDateTime, tag).then((response) async => {
      status = response.statusString
    });

    return status;
  }

  List<ReadingHistoryModel> _parseRenewLoanResponse(String responseBody) {
    print(responseBody);
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

    return parsed.map<ReadingHistoryModel>((json) => ReadingHistoryModel.fromJson(json)).toList();
  }

  Future<List<ReadingHistoryModel>> renewLoan(String loanRecordId) async {
    var url = Uri.parse('https://zj9ohmm9uh.execute-api.us-east-1.amazonaws.com/dev/loan/renew?' +
        'loan_record_id=$loanRecordId'
    );

    var response = await http.put(url,
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
        'Connection': 'keep-alive',
      },
    );

    return _parseRenewLoanResponse(response.body);
  }
}