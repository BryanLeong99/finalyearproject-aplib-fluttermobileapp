import 'dart:convert';

import 'package:http/http.dart' as http;
import 'fine_history_model.dart';

class FineHistoryDataProvider {
  List<FineHistoryModel> _parseFineHistoryList(String responseBody) {
    print(responseBody);
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

    return parsed.map<FineHistoryModel>((json) => FineHistoryModel.fromJson(json)).toList();
  }

  Future<List<FineHistoryModel>> getFineHistoryModelList(int paid, String userToken) async {
    var url = Uri.parse(
        "https://zj9ohmm9uh.execute-api.us-east-1.amazonaws.com/dev/fine-history?" +
            "user_token=$userToken"
            "&paid=$paid"
    );

    var response = await http.get(url,
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
        'Connection': 'keep-alive',
      },
    );

    return _parseFineHistoryList(response.body);
  }
}