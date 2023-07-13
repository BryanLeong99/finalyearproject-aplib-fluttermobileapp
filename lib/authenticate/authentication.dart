import 'package:flutter/cupertino.dart';

class Authentication {
  String authenticationToken;
  String authenticationStatus;
  String password;
  String userRole;

  Authentication({
    @required this.authenticationToken,
    @required this.authenticationStatus,
    @required this.password,
    @required this.userRole,
  });

  factory Authentication.fromJson(Map<String, dynamic> json) => new Authentication(
    authenticationToken: json["authenticationToken"],
    authenticationStatus: json['status'],
    password: json["password"],
    userRole: json["roleName"],
  );

  @override
  String toString() {
    return 'Authentication{authenticationToken: $authenticationToken, authenticationStatus: $authenticationStatus, password: $password, userRole: $userRole}';
  }
}