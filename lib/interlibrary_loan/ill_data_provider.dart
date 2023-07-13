import 'dart:async';
import 'dart:convert';

import 'create_new_ill_response.dart';
import 'ill_request_list_model.dart';
import 'ill_request_model.dart';
import 'package:http/http.dart' as http;

class IllDataProvider {
  Future<CreateNewIllResponse> createNewIllRequestAPICall(String requestDateTime,
      String email, String contactNumber, String title, String author, String year,
      String city, String publisher, String edition, String isbn, String callNumber,
      String organisation, String userToken) async {
    var url = Uri.parse('https://zj9ohmm9uh.execute-api.us-east-1.amazonaws.com/dev/ill/new?' +
      'date_time=$requestDateTime' +
      '&email=$email' +
      '&contact_number=$contactNumber' +
      '&title=$title' +
      '&author=$author' +
      '&year=$year' +
      '&city=$city' +
      '&publisher=$publisher' +
      '&edition=$edition' +
      '&isbn=$isbn' +
      '&call_number=$callNumber' +
      '&organisation=$organisation' +
      '&user_token=$userToken'
    );

    var response = await http.post(url,
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
        'Connection': 'keep-alive',
      },
    );

    print(response.body);

    return CreateNewIllResponse.fromJson(jsonDecode(response.body));
  }

  Future<String> createNewIllRequest(String requestDateTime,
      String email, String contactNumber, String title, String author, String year,
      String city, String publisher, String edition, String isbn, String callNumber,
      String organisation, String userToken) async {
    var status;
    await createNewIllRequestAPICall(requestDateTime, email, contactNumber, title,
        author, year, city, publisher, edition, isbn, callNumber, organisation, userToken).then((response) async => {
      status = response.statusString
    });

    return status;
  }

  List<IllRequestListModel> parseIllRequestList(String responseBody) {
    print(responseBody);
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

    return parsed.map<IllRequestListModel>((json) => IllRequestListModel.fromJson(json)).toList();
  }

  Future<List<IllRequestListModel>> getAllRequest(String userToken) async {
    var url = Uri.parse(
      "https://zj9ohmm9uh.execute-api.us-east-1.amazonaws.com/dev/ill/user?" +
          "user_token=$userToken"
    );

    var response = await http.get(url,
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
        'Connection': 'keep-alive',
      },
    );

    return parseIllRequestList(response.body);
  }

  List<IllRequestModel> parseIllRequestDetailsList(String responseBody) {
    print(responseBody);
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

    return parsed.map<IllRequestModel>((json) => IllRequestModel.fromJson(json)).toList();
  }

  Future<List<IllRequestModel>> getRequestDetails(String requestId) async {
    var url = Uri.parse(
        "https://zj9ohmm9uh.execute-api.us-east-1.amazonaws.com/dev/ill/details?" +
            "request_id=$requestId"
    );

    var response = await http.get(url,
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
        'Connection': 'keep-alive',
      },
    );

    return parseIllRequestDetailsList(response.body);
  }
}