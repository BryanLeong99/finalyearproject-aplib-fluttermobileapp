import 'package:flutter/cupertino.dart';

class DiscussionRoomSchedule {
  String roomBookingId;
  String startingTime;
  int duration;
  String bookingUserFullName;

  DiscussionRoomSchedule({
    this.roomBookingId,
    this.startingTime,
    this.duration,
    this.bookingUserFullName
  });

  factory DiscussionRoomSchedule.fromJson(Map<String, dynamic> json) => new DiscussionRoomSchedule(
    roomBookingId: json['roomBookingId'],
    startingTime: json['startingTime'],
    duration: json['duration'],
    bookingUserFullName: json['bookingUserFullName']
  );

  @override
  String toString() {
    return 'DiscussionRoomSchedule{roomBookingId: $roomBookingId, startingTime: $startingTime, duration: $duration, bookingUserFullName: $bookingUserFullName}';
  }
}