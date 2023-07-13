import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../constants.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final String appLogoFilePath = 'assets/app-logo-full.svg';
  final String apuLogoFilePath = 'assets/apu-logo.svg';

  _back(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

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
      body: SizedBox.expand(
        child: Container(
          padding: EdgeInsets.fromLTRB(screenWidth * 0.05, screenHeight * 0.02, screenWidth * 0.05, 0.0),
          child: Column(
            children: [
              // page title
              Container(
                width: screenWidth,
                child: Text(
                  'About',
                  style: Constants.TEXT_STYLE_HEADING_1,
                ),
              ),

              // app logo
              Container(
                margin: EdgeInsets.only(top: screenHeight * 0.04),
                width: screenWidth,
                height: screenHeight * 0.16,
                child: SvgPicture.asset(
                  appLogoFilePath,
                ),
              ),

              // property text
              Container(
                margin: EdgeInsets.only(top: screenHeight * 0.005),
                padding: EdgeInsets.only(right: screenHeight * 0.01), // padding is added here to calibrate the illusion of misalignment
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: screenWidth * 0.015),
                      width: screenHeight * 0.032,
                      height: screenHeight * 0.032,
                      child: SvgPicture.asset(
                        apuLogoFilePath,
                      ),
                    ),

                    Text(
                      'Property of APU',
                      style: Constants.TEXT_STYLE_PROPERTY_TEXT,
                    ),
                  ],
                ),
              ),

              // version text
              Container(
                margin: EdgeInsets.only(top: screenHeight * 0.015),
                child: Text(
                  'version: 1.0.1',
                  style: Constants.TEXT_STYLE_VERSION_TEXT,
                ),
              ),

              // content card
              Container(
                margin: EdgeInsets.only(top: screenHeight * 0.04),
                width: screenWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.0),
                  color: Constants.COLOR_WHITE,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: screenWidth,
                      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.015, horizontal: screenWidth * 0.04),
                      decoration: BoxDecoration(
                        color: Constants.COLOR_MAGNOLIA,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(6.0)),
                      ),
                      child: Text(
                        'What is AP Lib?',
                        style: Constants.TEXT_STYLE_HEADING_3,
                      ),
                    ),

                    Container(
                      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.015, horizontal: screenWidth * 0.04),
                      child: Text(
                        'AP Lib is a Final Year Project that aims to introduce the '
                            'staff-less and 24-hour concept to the APU Library as part '
                            'of the contribution towards the institution\'s digital '
                            'transformation.',
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