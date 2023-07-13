import 'package:flutter/material.dart';

class FineHistoryModel {
  String recordId;
  String fineDateTime;
  double amount;
  String description;
  String bookTitle;

  FineHistoryModel({
    @required this.recordId,
    @required this.fineDateTime,
    @required this.amount,
    @required this.description,
    @required this.bookTitle,
  });

  factory FineHistoryModel.fromJson(Map<String, dynamic> json) => new FineHistoryModel(
    recordId: json['recordId'],
    fineDateTime: json['fineDateTime'],
    amount: json['amount'],
    description: json['description'],
    bookTitle: json['bookTitle'],
  );

  @override
  String toString() {
    return 'FineHistoryModel{recordId: $recordId, fineDateTime: $fineDateTime, amount: $amount, description: $description, bookTitle: $bookTitle}';
  }
}