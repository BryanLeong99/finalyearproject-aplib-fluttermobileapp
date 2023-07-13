import 'package:flutter/cupertino.dart';

class CreateNewIllResponse {
  String statusString;

  CreateNewIllResponse({
    @required this.statusString,
  });

  factory CreateNewIllResponse.fromJson(Map<String, dynamic> json) => new CreateNewIllResponse(
    statusString: json['status']
  );

  @override
  String toString() {
    return 'CreateNewIllResponse{statusString: $statusString}';
  }
}