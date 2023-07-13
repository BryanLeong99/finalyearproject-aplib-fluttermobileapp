import 'package:flutter/cupertino.dart';

class SignUp {
  String signUpStatus;

  SignUp({
    @required this.signUpStatus,
  });

  factory SignUp.fromJson(Map<String, dynamic> json) => new SignUp(
    signUpStatus: json['status'],
  );

  @override
  String toString() {
    return 'SignUp{signUpStatus: $signUpStatus}';
  }
}