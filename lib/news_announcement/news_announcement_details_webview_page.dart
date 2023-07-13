import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../constants.dart';

class NewsAnnouncementDetailsWebviewPage extends StatefulWidget {
  final String newsAnnouncementUrl;

  NewsAnnouncementDetailsWebviewPage({
    @required this.newsAnnouncementUrl,
  });
  @override
  _NewsAnnouncementDetailsWebviewPageState createState() => _NewsAnnouncementDetailsWebviewPageState();
}

class _NewsAnnouncementDetailsWebviewPageState extends State<NewsAnnouncementDetailsWebviewPage> {
  _back(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () => _back(context),
          child: Icon(
            Icons.arrow_back_outlined,
            color: Constants.COLOR_BLACK,
          ),
        ),
      ),
      body: WebView(
        initialUrl: widget.newsAnnouncementUrl,
      ),
    );
  }
}