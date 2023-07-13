import 'dart:convert';
import 'package:http/http.dart' as http;
import 'notification_model.dart';

class NotificationDataProvider {
  List<NotificationModel> _parseNotificationModelList(String responseBody) {
    print(responseBody);
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

    return parsed.map<NotificationModel>((json) => NotificationModel.fromJson(json)).toList();
  }

  Future<List<NotificationModel>> getNotificationList(String userToken) async {
    var url = Uri.parse(
      "https://zj9ohmm9uh.execute-api.us-east-1.amazonaws.com/dev/notification/user?" +
          "user_token=$userToken"
    );

    var response = await http.get(url,
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
        'Connection': 'keep-alive',
      },
    );

    return _parseNotificationModelList(response.body);
  }

  List<NotificationModel> _parseNotificationDetailsBooking(String responseBody) {
    print(responseBody);
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

    return parsed.map<NotificationModel>((json) => NotificationModel.fromJson(json)).toList();
  }

  Future<List<NotificationModel>> getNotificationDetailsBooking(String bookingId, String notificationId) async {
    var url = Uri.parse(
        "https://zj9ohmm9uh.execute-api.us-east-1.amazonaws.com/dev/booking/id?" +
            "booking_id=$bookingId" +
            "&notification_id=$notificationId"
    );

    var response = await http.put(url,
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
        'Connection': 'keep-alive',
      },
    );

    return _parseNotificationDetailsBooking(response.body);
  }

  List<NotificationModel> _parseNotificationDetailsLoan(String responseBody) {
    print(responseBody);
    final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

    return parsed.map<NotificationModel>((json) => NotificationModel.fromJson(json)).toList();
  }

  Future<List<NotificationModel>> getNotificationDetailsLoan(String loanId, String notificationId) async {
    var url = Uri.parse(
        "https://zj9ohmm9uh.execute-api.us-east-1.amazonaws.com/dev/reading-history/id?" +
            "loan_id=$loanId" +
            "&notification_id=$notificationId"
    );

    var response = await http.put(url,
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
        'Connection': 'keep-alive',
      },
    );

    return _parseNotificationDetailsLoan(response.body);
  }
}