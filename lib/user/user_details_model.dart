import 'package:flutter/cupertino.dart';

class UserDetailsModel {
  String fullName;
  String tpNumber;
  String email;
  String contactNumber;
  String schoolDepartment;
  String schoolDepartmentId;
  String role;
  String updateResponse;

  UserDetailsModel({
    @required this.fullName,
    @required this.tpNumber,
    @required this.email,
    @required this.contactNumber,
    @required this.schoolDepartment,
    @required this.schoolDepartmentId,
    @required this.role,
    @required this.updateResponse,
  });

  factory UserDetailsModel.fromJson(Map<String, dynamic> json) => new UserDetailsModel(
    fullName: json['fullName'],
    tpNumber: json['tpNumber'],
    email: json['email'],
    contactNumber: json['contactNumber'],
    schoolDepartment: json['department'],
    schoolDepartmentId: json['departmentId'],
    role: json['role'],
    updateResponse: json['status']
  );

  @override
  String toString() {
    return 'UserDetailsModel{fullName: $fullName, tpNumber: $tpNumber, email: $email, contactNumber: $contactNumber, schoolDepartment: $schoolDepartment, schoolDepartmentId: $schoolDepartmentId, role: $role, updateResponse: $updateResponse}';
  }
}