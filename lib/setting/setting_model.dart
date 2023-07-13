import 'package:flutter/cupertino.dart';

class SettingModel {
  final String settingId;
  final String buildOs;
  final String deviceName;
  final bool enabledNotification;
  final String statusString;

  SettingModel({
    @required this.settingId,
    @required this.buildOs,
    @required this.deviceName,
    @required this.enabledNotification,
    @required this.statusString,
  });

  factory SettingModel.fromJson(Map<String, dynamic> json) => new SettingModel(
    settingId: json['settingId'],
    buildOs: json['buildOs'],
    deviceName: json['deviceName'],
    enabledNotification: json['enabledNotification'] == 1 ? true : false,
    statusString: json['status'],
  );

  @override
  String toString() {
    return 'SettingModel{settingId: $settingId, buildOs: $buildOs, deviceName: $deviceName, enabledNotification: $enabledNotification, statusString: $statusString}';
  }
}