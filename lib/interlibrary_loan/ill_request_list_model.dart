import 'package:flutter/cupertino.dart';

class IllRequestListModel {
  String requestId;
  String title;
  String status;
  String dateTime;

  IllRequestListModel({
    @required this.requestId,
    @required this.title,
    @required this.status,
    @required this.dateTime
  });

  factory IllRequestListModel.fromJson(Map<String, dynamic> json) => new IllRequestListModel(
    requestId: json['requestId'],
    title: json['title'],
    status: json['status'],
    dateTime: json['dateTime']
  );

  @override
  String toString() {
    return 'IllRequestListModel{requestId: $requestId, title: $title, status: $status, dateTime: $dateTime}';
  }
}