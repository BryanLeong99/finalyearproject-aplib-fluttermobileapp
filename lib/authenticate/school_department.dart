import 'package:flutter/cupertino.dart';

class SchoolDepartment {
  String schoolDepartmentId;
  String schoolDepartmentName;

  SchoolDepartment({
    @required this.schoolDepartmentId,
    @required this.schoolDepartmentName
  });

  factory SchoolDepartment.fromJson(Map<String, dynamic> json) => new SchoolDepartment(
    schoolDepartmentId: json['schoolDepartmentId'] as String,
    schoolDepartmentName: json['schoolDepartmentName'] as String
  );

  @override
  String toString() {
    return 'SchoolDepartment{schoolDepartmentId: $schoolDepartmentId, schoolDepartmentName: $schoolDepartmentName}';
  }
}