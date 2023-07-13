import 'dart:math';

import 'package:ap_lib/authenticate/authentication_handler.dart';
import 'package:ap_lib/authenticate/cryptography_handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'dart:async';
import '../constants.dart';
import 'package:screen/screen.dart';

class MyQrPage extends StatefulWidget {
  final String name;
  final String tpNumber;

  MyQrPage({
    @required this.name,
    @required this.tpNumber,
  });

  @override
  _MyQrPageState createState() => _MyQrPageState();
}

class _MyQrPageState extends State<MyQrPage> {
  AuthenticationHandler _authenticationHandler;
  CryptographyHandler _cryptographyHandler;
  Timer _timer;
  String token = '';
  List<String> tokenPartArray = [];
  String tokenPart1 = '';
  String tokenPart2 = '';
  String qrCodeText = '';

  bool _isKeptOn = false;
  double _brightness = 1.0;

  String _generateRandomSalt() {
    var random = new Random();
    var next = random.nextDouble() * 1000000;
    while (next < 100000) {
      next *= 10;
    }
    return next.toInt().toString();
  }

  void initPlatformState() async {
    bool keptOn = await Screen.isKeptOn;
    double brightness = await Screen.brightness;
    setState((){
      _isKeptOn = keptOn;
      _brightness = brightness;
    });
    Screen.setBrightness(1.0);
    Screen.keepOn(true);
  }

  void disposePlatformState() {
    Screen.setBrightness(_brightness);
    Screen.keepOn(_isKeptOn);
  }


  _back(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
    _authenticationHandler = new AuthenticationHandler();
    _cryptographyHandler = new CryptographyHandler();

    _authenticationHandler.getToken().then((token) => {
      if (mounted) {
        setState(() {
          this.token = token;
          this.tokenPartArray = token.contains('tp') ? token.split('tp') : token.split('ap');
          this.tokenPart1 = token.contains('tp') ? this.tokenPartArray[0] : 'aa' +  this.tokenPartArray[0];
          this.tokenPart2 = this.tokenPartArray[1];
          print(this.token);
          qrCodeText = tokenPart1 + _generateRandomSalt() + tokenPart2 + DateTime
              .now()
              .toUtc()
              .millisecondsSinceEpoch
              .toString()
              .substring(0, 10);
          print(qrCodeText);
        }),
      }
    });

    _timer = new Timer.periodic(Duration(minutes: 1), (timer) {
      if (mounted) {
        setState(() {
          qrCodeText = tokenPart1 + _generateRandomSalt() + tokenPart2 + DateTime
              .now()
              .toUtc()
              .millisecondsSinceEpoch
              .toString()
              .substring(0, 10);
          print(qrCodeText);
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
    print(_brightness);
    print(_isKeptOn);
    disposePlatformState();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Constants.COLOR_MAGNOLIA,
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
      body: SizedBox.expand(
        child: Container(
          padding: EdgeInsets.fromLTRB(screenWidth * 0.05, screenHeight * 0.02, screenWidth * 0.05, 0.0),
          child: Column(
            children: [
              // page title
              Container(
                width: screenWidth,
                child: Text(
                  'My QR Code',
                  style: Constants.TEXT_STYLE_HEADING_1,
                ),
              ),

              Container(
                width: screenWidth,
                margin: EdgeInsets.only(top: screenHeight * 0.08),
                padding: EdgeInsets.symmetric(vertical: screenHeight * 0.03, horizontal: screenWidth * 0.04),
                decoration: BoxDecoration(
                  color: Constants.COLOR_WHITE,
                  borderRadius: BorderRadius.circular(11.0),
                  boxShadow: [
                    BoxShadow(
                      color: Constants.COLOR_GRAY_BOX_SHADOW,
                      offset: Offset(0.0, 5.0),
                      blurRadius: 4.0,
                      spreadRadius: 1.0,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.name,
                        style: Constants.TEXT_STYLE_HEADING_4,
                      ),
                    ),

                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.tpNumber,
                        style: Constants.TEXT_STYLE_SUB_HEADING_1,
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(top: screenHeight * 0.03),
                      alignment: Alignment.center,
                      width: screenWidth,
                      child: PrettyQr(
                        roundEdges: true,
                        typeNumber: 3,
                        size: 295,
                        data: qrCodeText,
                        errorCorrectLevel: QrErrorCorrectLevel.M,
                        image: AssetImage('assets/app_icon_big.png'),
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(top: screenHeight * 0.03),
                      alignment: Alignment.center,
                      child: Text(
                        'Scan the QR Code to enter the library',
                        style: Constants.TEXT_STYLE_DETAILS_PASSAGE_CONTENT_2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}