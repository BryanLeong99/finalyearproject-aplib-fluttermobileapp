import 'dart:convert';

import 'package:http/http.dart' as http;
import 'setting_model.dart';

class SettingDataProvider {
  List<SettingModel> _parseDiscussionRoomList(String responseBody) {
    print(responseBody);
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

    return parsed.map<SettingModel>((json) => SettingModel.fromJson(json)).toList();
  }

  Future<List<SettingModel>> getUserSetting(String userToken) async {
    var url = Uri.parse('https://zj9ohmm9uh.execute-api.us-east-1.amazonaws.com/dev/setting/user?'
        'user_token=$userToken'
    );

    var response = await http.get(url,
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
        'Connection': 'keep-alive',
      },
    );
    print(response.body);

    return _parseDiscussionRoomList(response.body);
  }

  Future<String> updateUserSetting(String settingId, String enabledNotification) async {
    String status;
    await updateUserSettingAPICall(settingId, enabledNotification).then((response) async => {
      status = response.statusString,
    });
    return status;
  }

  Future<SettingModel> updateUserSettingAPICall(String settingId, String enabledNotification) async {
    var url = Uri.parse('https://zj9ohmm9uh.execute-api.us-east-1.amazonaws.com/dev/setting/update?'
      'setting_id=$settingId'
      '&enabled_notification=$enabledNotification'
    );

    var response = await http.put(url,
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
        'Connection': 'keep-alive',
      },
    );
    print(response.body);

    return SettingModel.fromJson(jsonDecode(response.body));
  }
}