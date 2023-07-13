import 'package:flutter/cupertino.dart';

class DiscussionRoomList {
  String roomId;
  String roomName;
  int capacity;
  bool availability;

  DiscussionRoomList({
    @required this.roomId,
    @required this.roomName,
    @required this.capacity,
    @required this.availability,
  });

  factory DiscussionRoomList.fromJson(Map<String, dynamic> json) => new DiscussionRoomList(
    roomId: json['roomId'],
    roomName: json['roomName'],
    capacity: json['capacity'],
    availability: json['bookingStatus'] == 1 ? true : false,
  );

  @override
  String toString() {
    return 'DiscussionRoomList{roomId: $roomId, roomName: $roomName, capacity: $capacity, availability: $availability}';
  }
}