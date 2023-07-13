import 'package:flutter/cupertino.dart';

class ReadingHistoryModel {
  String itemId;
  String bookTitle;
  String bookAuthor;
  String loanDateTime;
  String returnDateTime;
  String imageUrl;
  String dueDate;
  String loanRecordId;
  String statusString;
  int renew;

  ReadingHistoryModel({
    @required this.itemId,
    @required this.bookTitle,
    @required this.bookAuthor,
    @required this.loanDateTime,
    @required this.returnDateTime,
    @required this.imageUrl,
    @required this.dueDate,
    @required this.loanRecordId,
    @required this.statusString,
    @required this.renew,
  });

  factory ReadingHistoryModel.fromJson(Map<String, dynamic> json) => new ReadingHistoryModel(
    itemId: json['itemId'],
    bookTitle: json['bookTitle'],
    bookAuthor: json['bookAuthor'],
    loanDateTime: json['loanDateTime'],
    returnDateTime: json['returnDateTime'],
    imageUrl: json['imageUrl'],
    dueDate: json['dueDate'],
    loanRecordId: json['loanRecordId'],
    statusString: json['status'],
    renew: json['renew'],
  );

  @override
  String toString() {
    return 'ReadingHistoryModel{itemId: $itemId, bookTitle: $bookTitle, bookAuthor: $bookAuthor, loanDateTime: $loanDateTime, returnDateTime: $returnDateTime, imageUrl: $imageUrl, dueDate: $dueDate, loanRecordId: $loanRecordId, statusString: $statusString, renew: $renew}';
  }
}