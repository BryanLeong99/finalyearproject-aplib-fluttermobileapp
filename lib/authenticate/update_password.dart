import 'package:flutter/cupertino.dart';

class UpdatePassword{
  String updateStatus;

  UpdatePassword({
    @required this.updateStatus,
  });

  factory UpdatePassword.fromJson(Map<String, dynamic> json) => new UpdatePassword(
    updateStatus: json['status'],
  );

  @override
  String toString() {
    return 'UpdatePassword{updateStatus: $updateStatus}';
  }
}