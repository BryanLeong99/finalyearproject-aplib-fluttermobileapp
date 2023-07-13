import 'package:flutter/cupertino.dart';

class BookingDetails {
  String bookingId;
  String startingTime;
  int duration;
  int numOfPerson;
  String description;
  String roomId;
  String roomName;
  bool accessed;

  BookingDetails({
    @required this.bookingId,
    @required this.startingTime,
    @required this.duration,
    @required this.numOfPerson,
    @required this.description,
    @required this.roomId,
    @required this.roomName,
    @required this.accessed
  });

  factory BookingDetails.fromJson(Map<String, dynamic> json) => new BookingDetails(
    bookingId: json['bookingId'],
    startingTime: json['startingTime'],
    duration: json['duration'],
    numOfPerson: json['numOfPerson'],
    description: json['description'],
    roomId: json['roomId'],
    roomName: json['room'],
    accessed: json['accessed'] == 1 ? true : false
  );

  @override
  String toString() {
    return 'BookingDetails{bookingId: $bookingId, startingTime: $startingTime, duration: $duration, numOfPerson: $numOfPerson, description: $description, roomId: $roomId, roomName: $roomName, accessed: $accessed}';
  }


}