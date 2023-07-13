import 'package:ap_lib/booking/booking_details.dart';
import 'package:ap_lib/reading_history/reading_history_model.dart';
import 'package:flutter/cupertino.dart';

class NotificationModel {
  String notificationId;
  String notificationDateTime;
  String descriptionMessage;
  String relatedReminderId;
  bool messageRead;
  BookingDetails bookingDetails;
  ReadingHistoryModel readingHistoryDetails;

  NotificationModel({
    @required this.notificationId,
    @required this.notificationDateTime,
    @required this.descriptionMessage,
    @required this.relatedReminderId,
    @required this.messageRead,
    @required this.bookingDetails,
    @required this.readingHistoryDetails,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) => new NotificationModel(
    notificationId: json['notificationId'],
    notificationDateTime: json['notificationDateTime'],
    descriptionMessage: json['descriptionMessage'],
    relatedReminderId: json['relatedReminderId'],
    messageRead: json['messageRead'] == 1 ? true : false,
    bookingDetails: new BookingDetails(
      startingTime: json['startingTime'],
      duration: json['duration'],
      roomName: json['roomName'],
      roomId: json['roomId'],
      description: json['description'],
      numOfPerson: json['numOfPerson'],
    ),
    readingHistoryDetails: new ReadingHistoryModel(
      itemId: json['itemId'],
      dueDate: json['dueDate'],
      bookTitle: json['bookTitle'],
      bookAuthor: json['bookAuthor'],
      loanDateTime: json['loanDateTime'],
      imageUrl: json['imageUrl'],
    ),
  );
}