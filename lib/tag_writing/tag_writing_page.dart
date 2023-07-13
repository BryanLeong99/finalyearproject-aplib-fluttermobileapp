import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:flutter_nfc_mifare/MF1.dart';
import 'package:smart_flare/actors/smart_flare_actor.dart';
import '../constants.dart';
import 'package:flutter_nfc_reader/flutter_nfc_reader.dart';
import 'package:nfc_in_flutter/nfc_in_flutter.dart';
import 'tag_model.dart';
import 'tag_data_provider.dart';
// import 'package:flutter_nfc_mifare/flutter_nfc_mifare.dart';
// import 'package:flutter_nfc_mifare/MF1.dart';

class TagWritingPage extends StatefulWidget {
  final String barcode;

  TagWritingPage({
    @required this.barcode,
  });

  @override
  _TagWritingPageState createState() => _TagWritingPageState();
}

class _TagWritingPageState extends State<TagWritingPage> {
  TagDataProvider _tagDataProvider;

  void _back(BuildContext context) {
    Navigator.pop(context);
  }

  // void readTag() async {
  //   NDEFMessage message = await NFC.readNDEF(once: true).first;
  //   print("payload: ${message.payload}");
  // }
  //
  // void writeTag() async {
  //   List<NDEFRecord> ndefList =  [];
  //   ndefList.add(NDEFRecord.type("text/plain", "hello world"));
  //   ndefList.add(NDEFRecord.type("", "123456"));
  //   NDEFMessage newMessage = NDEFMessage.withRecords(
  //       ndefList
  //   );
  //
  //   await NFC.writeNDEF(newMessage, once: true).first;
  // }
  // var _nfcData;

  // Future<void> startNFC() async {
  //   setState(() {
  //     _nfcData = NfcData();
  //     _nfcData.status = NFCStatus.reading;
  //   });
  //
  //   print('NFC: Scan started');
  //
  //   print('NFC: Scan readed NFC tag');
  //   FlutterNfcReader.read.listen((response) {
  //     setState(() {
  //       _nfcData = response;
  //     });
  //   });
  // }
  // bool _nfcHere = false;
  // MF1 _currentMF1;
  // Uint8List _showBlock;

  void _recordTag(String tag) {
    print(tag);
    EasyLoading.show(
      status: 'Updating...',
      maskType: EasyLoadingMaskType.black,
    );
    _tagDataProvider.updateItemTag(tag.substring(2,10), widget.barcode).then((status) => {
      EasyLoading.dismiss(),
      if (status == 'success') {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              "Tag Recorded",
              style: Constants.TEXT_STYLE_DIALOG_TITLE_AND_ACTION_1,
            ),
            content: Text(
              "The tag has been recorded in the system.",
              style: Constants.TEXT_STYLE_DIALOG_CONTENT,
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "OK",
                  style: Constants.TEXT_STYLE_DIALOG_TITLE_AND_ACTION_1,
                ),
              ),
            ],
          ),
        ),
      } else if (status == 'not found') {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              "Invalid barcode",
              style: Constants.TEXT_STYLE_DIALOG_TITLE_AND_ACTION_1,
            ),
            content: Text(
              "The barcode is not found.",
              style: Constants.TEXT_STYLE_DIALOG_CONTENT,
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "OK",
                  style: Constants.TEXT_STYLE_DIALOG_TITLE_AND_ACTION_1,
                ),
              ),
            ],
          ),
        ),
      } else if (status == 'duplicated') {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              "Duplicated Entry",
              style: Constants.TEXT_STYLE_DIALOG_TITLE_AND_ACTION_1,
            ),
            content: Text(
              "The tag has been registered.",
              style: Constants.TEXT_STYLE_DIALOG_CONTENT,
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "OK",
                  style: Constants.TEXT_STYLE_DIALOG_TITLE_AND_ACTION_1,
                ),
              ),
            ],
          ),
        ),
      }
    });

  }

  String _tag = "";

  @override
  void initState() {
    super.initState();
    print("Barcode: " + widget.barcode);
    _tagDataProvider = new TagDataProvider();
    // isMF1Here();

    // FlutterNfcMifare.channel.setMethodCallHandler((MethodCall call) async {
    //   switch (call.method) {
    //     case 'iamhere':
    //       setState(() {
    //         _nfcHere = true;
    //       });
    //       _currentMF1 = MF1.fromMap(call.arguments);
    //       return true;
    //   }
    // });

    // readMF1(1, 1).then((value) => print(value));
    // startNFC();
    // writeTag();
    // writeTag();
    //
    // FlutterNfcReader.write("", "000550008").then((value) => {
    //   print(value.content),
    // });


    FlutterNfcReader.onTagDiscovered().listen((onData) {
      print(onData.id);
      print(onData.content);
      setState(() {
        _tag = onData.id;
        _recordTag(_tag);
      });
    });


    // FlutterNfcReader.read().then((response) {
    //   print(response.content);
    // });

    // FlutterNfcReader.write("", "00000008").then((value) => {
    //   print(value.content),
    // });

  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
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
          alignment: Alignment.center,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: screenHeight * 0.15),
                height: screenHeight * 0.29,
                child: SmartFlareActor(
                  filename: 'assets/nfc_scanning.flr',
                  height: screenHeight * 0.35,
                  startingAnimation: "record",
                  playStartingAnimationWhenRebuilt: false,
                ),
              ),

              Container(
                child: Text(
                  'Please tap the new RFID tag \n at the back of your device.',
                  style: Constants.TEXT_STYLE_DETAILS_PASSAGE_CONTENT_2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}