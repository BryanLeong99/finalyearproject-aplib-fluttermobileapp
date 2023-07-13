import 'package:flutter/material.dart';

class NewsAnnouncementModel {
  String newsAnnouncementId;
  String newsAnnouncementTitle;
  String newsAnnouncementUrl;
  String imageUrl;
  String createdDate;
  String author;

  NewsAnnouncementModel({
    @required this.newsAnnouncementId,
    @required this.newsAnnouncementTitle,
    @required this.newsAnnouncementUrl,
    @required this.imageUrl,
    @required this.createdDate,
    @required this.author,
  });

  factory NewsAnnouncementModel.fromJson(Map<String, dynamic> json) => new NewsAnnouncementModel(
    newsAnnouncementId: json['newsAnnouncementId'],
    newsAnnouncementTitle: json['newsAnnouncementTitle'],
    newsAnnouncementUrl: json['newsAnnouncementUrl'],
    imageUrl: json['imageUrl'],
    createdDate: json['createdDate'],
    author: json['author'],
  );
}