import 'package:flutter/cupertino.dart';

class TagModel {
  final String statusString;

  TagModel({
    @required this.statusString,
  });

  factory TagModel.fromJson(Map<String, dynamic> json) => new TagModel(
    statusString: json['status'],
  );

  @override
  String toString() {
    return 'TagModel{statusString: $statusString}';
  }
}