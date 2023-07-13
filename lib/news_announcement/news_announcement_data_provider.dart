import 'dart:convert';
import 'package:http/http.dart' as http;
import 'news_announcement_model.dart';

class NewsAnnouncementDataProvider {
  List<NewsAnnouncementModel> _parseNewsAnnouncementList(String responseBody) {
    print(responseBody);
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

    return parsed.map<NewsAnnouncementModel>((json) => NewsAnnouncementModel.fromJson(json)).toList();
  }

  Future<List<NewsAnnouncementModel>> getNewsAnnouncementList() async {
    var url = Uri.parse(
      "https://zj9ohmm9uh.execute-api.us-east-1.amazonaws.com/dev/news-announcement/all",
    );

    var response = await http.get(url,
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
        'Connection': 'keep-alive',
      },
    );

    return _parseNewsAnnouncementList(response.body);
  }
}