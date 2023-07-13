import 'dart:convert';

import 'package:ap_lib/authenticate/authentication.dart';
import 'package:ap_lib/authenticate/sign_up.dart';
import 'package:ap_lib/authenticate/cryptography_handler.dart';
import 'package:ap_lib/authenticate/update_password.dart';
import 'package:ap_lib/firebase/push_notification_service_provider.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:progress_state_button/progress_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationHandler {
  static CryptographyHandler _cryptographyHandler = new CryptographyHandler();
  static PushNotificationServiceProvider _pushNotificationServiceProvider = new PushNotificationServiceProvider();

  Future<Authentication> authenticateCredential(String username, String password, String buildOs, String deviceName) async {
    var token;
    var deviceToken = await _pushNotificationServiceProvider.getDeviceToken();
    await authenticateAPICall(username, password, deviceToken, buildOs, deviceName).then((response) async {
      token = response;
    });
    return token;
  }

  Future<Authentication> authenticateAPICall(String username, String password, String deviceToken, String buildOs, String deviceName) async {
    var encryptedPassword = Uri.encodeQueryComponent(_cryptographyHandler.encryptString(
      _cryptographyHandler.hashString(password),
    ));

    print(_cryptographyHandler.hashString(password));
    print(encryptedPassword);

    var url = Uri.parse('https://zj9ohmm9uh.execute-api.us-east-1.amazonaws.com/dev/authenticate?'
        'username=$username'
        '&password=$encryptedPassword'
        '&device_token=$deviceToken'
        '&build_os=$buildOs'
        '&device_name=$deviceName'
    );
    var response = await http.post(url,
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
        'Connection': 'keep-alive',
      },
    );

    print(response.body);

    // final response = await http.get(Uri.https('dwg5udsqoi.execute-api.us-east-1.amazonaws.com', '/Test/transactions', {
    //       'transactionId': "5",
    //         'type': "PURCHASE",
    //         'amount': "500"}));

    // final response = await new http.Client().get(Uri.parse("https://dwg5udsqoi.execute-api.us-east-1.amazonaws.com/Test/transactions?transactionId=5&type=PURCHASE&amount=500"));
    return Authentication.fromJson(jsonDecode(response.body));

    // return compute(parseAuthentication, response.body);
  }

  Future<String> signUp(String phoneNumber, String tpNumber, String fullName,
      String email, String password, String schoolDepartment, String role) async {
    var status;
    await signUpAPICall(phoneNumber, tpNumber, fullName, email, password, schoolDepartment, role).then((response) async {
      status = response.signUpStatus;
    });

    return status;
  }

  Future<SignUp> signUpAPICall(String phoneNumber, String tpNumber, String fullName,
      String email, String password, String schoolDepartment, String role) async {
    var encryptedPassword = Uri.encodeQueryComponent(_cryptographyHandler.encryptString(
        _cryptographyHandler.hashString(password)
    ));

    var url = Uri.parse('https://zj9ohmm9uh.execute-api.us-east-1.amazonaws.com/dev/sign-up?fullName=$fullName&tpNumber=$tpNumber' +
    '&email=$email&contactNumber=$phoneNumber&schoolDepartment=$schoolDepartment&userRole=$role&password=$encryptedPassword');
    var response = await http.post(url,
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
        'Connection': 'keep-alive',
      },
    );

    return SignUp.fromJson(jsonDecode(response.body));
  }

  Future<String> updatePassword(String password, String contactDetails, String method) async {
    var status;
    await updatePasswordAPICall(password, contactDetails, method).then((response) async =>
      status = response.updateStatus
    );

    return status;
  }

  Future<UpdatePassword> updatePasswordAPICall(String password, String contactDetails, String method) async {
    var encryptedPassword = Uri.encodeQueryComponent(_cryptographyHandler.encryptString(
        _cryptographyHandler.hashString(password)
    ));

    var url = Uri.parse('https://zj9ohmm9uh.execute-api.us-east-1.amazonaws.com/dev/update-password?newPassword=$encryptedPassword' +
      '&contactDetails=$contactDetails&method=$method'
    );
    // var url = Uri.parse('https://y8r6m9vci4.execute-api.us-east-1.amazonaws.com/dev/update-password?newPassword=$encryptedPassword' +
    //   '&contactDetails=$contactDetails&method=$method'
    // );
    var response = await http.post(url,
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
        'Connection': 'keep-alive',
      },
    );

    return UpdatePassword.fromJson(jsonDecode(response.body));
  }

  Future<Authentication> signOut() async {
    String userToken = await getToken();
    var url = Uri.parse('https://zj9ohmm9uh.execute-api.us-east-1.amazonaws.com/dev/sign-out?'
        'user_token=$userToken'
    );

    var response = await http.put(url,
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
        'Connection': 'keep-alive',
      },
    );

    print(response.body);

    return Authentication.fromJson(jsonDecode(response.body));
  }

  Future<SignUp> verifyContactNumber(String contactNumber) async {
    var url = Uri.parse('https://zj9ohmm9uh.execute-api.us-east-1.amazonaws.com/dev/sign-up/verify/contact-number?'
        'contact_number=$contactNumber'
    );

    var response = await http.get(url,
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
        'Connection': 'keep-alive',
      },
    );

    print(response.body);

    return SignUp.fromJson(jsonDecode(response.body));
  }

  Future<String> verifyTpNumber(String tpNumber, String email) async {
    String status;
    await verifyTpNumberAPICall(tpNumber, email).then((response) async => {
      status = response.signUpStatus,
    });
    return status;
  }

  Future<SignUp> verifyTpNumberAPICall(String tpNumber, String email) async {
    var url = Uri.parse('https://zj9ohmm9uh.execute-api.us-east-1.amazonaws.com/dev/sign-up/verify/tp-number?'
        'tp_number=$tpNumber'
        '&email=$email'
    );

    var response = await http.get(url,
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
        'Connection': 'keep-alive',
      },
    );
    print(response.body);

    return SignUp.fromJson(jsonDecode(response.body));
  }

  Future<bool> saveToken(String authenticationToken, String userRole) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('authenticationToken', authenticationToken);
    sharedPreferences.setString('userRole', userRole);
    return true;
  }

  Future<String> getToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String authenticationToken = sharedPreferences.getString('authenticationToken');
    return authenticationToken == null ? '' : authenticationToken;
  }

  Future<String> getRole() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String userRole = sharedPreferences.getString('userRole');
    return userRole == null ? '' : userRole;
  }

  void clearToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.clear();
  }

  // List<Authentication> parseAuthentication(String responseBody) {
  //   final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  //
  //   return parsed.map<Authentication>((json) => Authentication.fromJson(json)).toList();
  // }
}