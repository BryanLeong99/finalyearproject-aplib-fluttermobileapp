import 'package:flutter/cupertino.dart';

class BookList {
  final String resultFound;
  final String itemId;
  final String bookTitle;
  final String bookAuthor;
  final String collectionName;
  final String edition;
  final String publishingYear;
  final String availabilityStatus;
  final String libraryName;
  final String callNumber;
  final String imageUrl;
  final String tagName;

  BookList({
    @required this.resultFound,
    @required this.itemId,
    @required this.bookTitle,
    @required this.bookAuthor,
    @required this.collectionName,
    @required this.publishingYear,
    @required this.edition,
    @required this.availabilityStatus,
    @required this.libraryName,
    @required this.callNumber,
    @required this.imageUrl,
    @required this.tagName,
  });

  factory BookList.fromJson(Map<String, dynamic> json) => new BookList(
    resultFound: json['result_found'],
    itemId: json['itemId'],
    bookTitle: json['bookTitle'],
    bookAuthor: json['bookAuthor'],
    collectionName: json['collectionName'],
    edition: json['edition'],
    publishingYear: json['publishingYear'],
    availabilityStatus: json['availabilityStatus'],
    libraryName: json['libraryName'],
    callNumber: json['callNumber'],
    imageUrl: json['imageUrl'],
    tagName: json['tag'],
  );

  @override
  String toString() {
    return 'BookList{resultFound: $resultFound, itemId: $itemId, bookTitle: $bookTitle, bookAuthor: $bookAuthor, collectionName: $collectionName, edition: $edition, publishingYear: $publishingYear, availabilityStatus: $availabilityStatus, libraryName: $libraryName, callNumber: $callNumber, imageUrl: $imageUrl, tagName: $tagName}';
  }
}