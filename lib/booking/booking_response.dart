import 'package:flutter/cupertino.dart';

class BookingResponse {
  String statusString;
  String bookingId;
  String roomId;

  BookingResponse({
    @required this.statusString,
    @required this.bookingId,
    @required this.roomId,
  });

  factory BookingResponse.fromJson(Map<String, dynamic> json) => new BookingResponse(
    statusString: json['status'],
    bookingId: json['bookingId'],
    roomId: json['roomId'],
  );

  @override
  String toString() {
    return 'BookingResponse{statusString: $statusString}';
  }
}