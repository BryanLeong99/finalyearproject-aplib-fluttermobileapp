import 'package:flutter/cupertino.dart';

import '../constants.dart';

class BookModel {
  final String bookTitle;
  final String bookAuthor;
  final String availabilityStatusName;
  final String publicationInfo;
  final String isbn;
  final String physicalDescription;
  final String circulationName;
  final String collectionName;
  final String copyNumber;
  final String libraryName;
  final String callNumber;
  final String contentSummary;
  final String bookContent;
  final String coordinateCode;
  final int xCoordinate;
  final int yCoordinate;
  final List subjects;

  BookModel({
    @required this.bookTitle,
    @required this.bookAuthor,
    @required this.availabilityStatusName,
    @required this.publicationInfo,
    @required this.isbn,
    @required this.physicalDescription,
    @required this.circulationName,
    @required this.collectionName,
    @required this.copyNumber,
    @required this.libraryName,
    @required this.callNumber,
    @required this.contentSummary,
    @required this.bookContent,
    @required this.coordinateCode,
    @required this.xCoordinate,
    @required this.yCoordinate,
    @required this.subjects,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) => new BookModel(
    bookTitle: json['bookDetails'][0]['bookTitle'],
    bookAuthor: json['bookDetails'][0]['bookAuthor'],
    availabilityStatusName: json['bookDetails'][0]['availabilityStatusName'],
    publicationInfo: json['bookDetails'][0]['publicationInfo'],
    isbn: json['bookDetails'][0]['isbn'],
    physicalDescription: json['bookDetails'][0]['physicalDescription'],
    circulationName: json['bookDetails'][0]['circulationName'],
    collectionName: json['bookDetails'][0]['collectionName'],
    copyNumber: json['bookDetails'][0]['copyNumber'].toString(),
    libraryName: json['bookDetails'][0]['libraryName'],
    callNumber: json['bookDetails'][0]['callNumber'],
    contentSummary: json['bookDetails'][0]['contentSummary'],
    bookContent: json['bookDetails'][0]['bookContent'],
    coordinateCode: json['bookDetails'][0]['coordinateCode'],
    xCoordinate: json['bookDetails'][0]['xCoordinate'],
    yCoordinate: json['bookDetails'][0]['yCoordinate'],
    subjects: json['subjects']
  );

  @override
  String toString() {
    return 'BookModel{bookTitle: $bookTitle, bookAuthor: $bookAuthor, availabilityStatusName: $availabilityStatusName, publicationInfo: $publicationInfo, isbn: $isbn, physicalDescription: $physicalDescription, circulationName: $circulationName, collectionName: $collectionName, copyNumber: $copyNumber, libraryName: $libraryName, callNumber: $callNumber, contentSummary: $contentSummary, bookContent: $bookContent, coordinateCode: $coordinateCode, xCoordinate: $xCoordinate, yCoordinate: $yCoordinate, subjects: $subjects}';
  }

  List<Widget> generateSubjectTextWidget() {
    int _iteration = 0;

    List<Widget> _textSpanList = [];

    this.subjects.forEach((element) {
      _textSpanList.add(
        Text(
          element['subjectName'],
          // style: Constants.TEXT_STYLE_DETAILS_TABLE_CONTENT_HIGHLIGHT,
          style: Constants.TEXT_STYLE_DETAILS_TABLE_CONTENT,
        )
      );
      if (_iteration != this.subjects.length - 1) {
        _textSpanList.add(
          Text(
            " | ",
            style: Constants.TEXT_STYLE_DETAILS_TABLE_CONTENT,
          )
        );
      }
      _iteration++;
    });

    return _textSpanList;
  }
}