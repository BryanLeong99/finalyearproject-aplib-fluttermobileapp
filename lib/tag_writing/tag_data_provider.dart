import 'dart:convert';

import 'tag_model.dart';
import 'package:http/http.dart' as http;

class TagDataProvider {
  Future<String> updateItemTag(String tag, String barcode) async {
    String status;
    await updateItemTagAPICall(tag, barcode).then((response) async => {
      status = response.statusString,
    });
    return status;
  }

  Future<TagModel> updateItemTagAPICall(String tag, String barcode) async {
    var url = Uri.parse('https://zj9ohmm9uh.execute-api.us-east-1.amazonaws.com/dev/barcode/register/rfid-tag?'
        'barcode=$barcode'
        '&rfid_tag=$tag'
    );

    var response = await http.put(url,
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
        'Connection': 'keep-alive',
      },
    );
    print(response.body);

    return TagModel.fromJson(jsonDecode(response.body));
  }
}