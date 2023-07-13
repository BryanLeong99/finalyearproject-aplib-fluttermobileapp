import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:ap_lib/user/user_details_model.dart';

class UserDataFetcher {
  List<UserDetailsModel> _parseUserDetailsList(String responseBody) {
    print(responseBody);
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

    return parsed.map<UserDetailsModel>((json) => UserDetailsModel.fromJson(json)).toList();
  }

  Future<List<UserDetailsModel>> getUserDetails(String userToken) async {
    var url = Uri.parse(
      "https://zj9ohmm9uh.execute-api.us-east-1.amazonaws.com/dev/user/details?" +
          "user_token=$userToken"
    );

    var response = await http.get(url,
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
        'Connection': 'keep-alive',
      },
    );

    return _parseUserDetailsList(response.body);
  }

  Future<String> updateUserDetails(String userToken, String name, String email, String contactNumber, String schoolDepartmentId) async {
    var status;
    await _updateUserDetailsAPICall(userToken, name, email, contactNumber, schoolDepartmentId).then((response) async =>
      status = response.updateResponse
    );
    return status;
  }

  Future<UserDetailsModel> _updateUserDetailsAPICall(String userToken, String name, String email, String contactNumber, String schoolDepartmentId) async {
    var url = Uri.parse(
        "https://zj9ohmm9uh.execute-api.us-east-1.amazonaws.com/dev/user/update?" +
            "user_token=$userToken" +
            "&name=$name" +
            "&email=$email" +
            "&contact_number=$contactNumber" +
            "&school_department=$schoolDepartmentId"
    );

    var response = await http.put(url,
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
        'Connection': 'keep-alive',
      },
    );

    print(response.body);

    return UserDetailsModel.fromJson(jsonDecode(response.body));
  }

  Future<String> verifyEmailPhone(String email, String phoneNumber, String userToken) async {
    var status;
    await _verifyEmailPhoneAPICall(email, phoneNumber, userToken).then((response) async => {
      status = response.updateResponse,
    });
    return status;
  }

  Future<UserDetailsModel> _verifyEmailPhoneAPICall(String email, String phoneNumber, String userToken) async {
    var url = Uri.parse(
      "https://zj9ohmm9uh.execute-api.us-east-1.amazonaws.com/dev/user/verify?"
          "contact_number=$phoneNumber"
          "&email=$email"
          "&user_token=$userToken"
    );

    var response = await http.get(url,
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
        'Connection': 'keep-alive',
      },
    );

    print(response.body);

    return UserDetailsModel.fromJson(jsonDecode(response.body));
  }
}