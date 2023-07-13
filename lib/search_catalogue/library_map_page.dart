import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:photo_view/photo_view.dart';
import 'dart:ui' as ui;
import '../constants.dart';

class LibraryMapPage extends StatefulWidget {
  final int xCoordinate;
  final int yCoordinate;

  LibraryMapPage({
    @required this.xCoordinate,
    @required this.yCoordinate,
  });

  @override
  _LibraryMapPageState createState() => _LibraryMapPageState();
}

class _LibraryMapPageState extends State<LibraryMapPage> {
  bool _isImageloaded = false;

  // decode image from an 8-bit integer list to a computable object
  Future<ui.Image> loadImage(List<int> img) async {
    final Completer<ui.Image> completer = new Completer();
    ui.decodeImageFromList(img, (ui.Image img) {
      setState(() {
        _isImageloaded = true;
      });
      return completer.complete(img);
    });
    return completer.future;
  }

  Image _mapGenerated;

  // generate a map with a point plotted
  void _generateMap(int xCoordinate, int yCoordinate) async {
    // initialise necessary variables
    // initiate the picture recorder to capture changes made on the canvas
    var _pictureRecorder = ui.PictureRecorder();
    var _canvas = Canvas(_pictureRecorder);
    var _paint = Paint();
    ByteData _data = await rootBundle.load('assets/library-map.png');
    ui.Image _image = await loadImage(new Uint8List.view(_data.buffer));

    _paint.isAntiAlias = true;
    _paint.color = Constants.COLOR_RED;

    // draw the plain map image and the red dot on the canvas
    _canvas.drawImage(_image, new Offset(0.5, 0.5), _paint);
    _canvas.drawCircle(new Offset(xCoordinate.toDouble(), yCoordinate.toDouble()), 40.0, _paint);

    // end the recording of the canvas
    var pic = _pictureRecorder.endRecording();

    // generate the recorded data into an image
    ui.Image img = await pic.toImage(_image.width, _image.height);
    var byteData = await img.toByteData(format: ui.ImageByteFormat.png);

    // convert the byte data to a buffer of 8-bit integer list
    var buffer = byteData.buffer.asUint8List();

    // load the image into the device's memory
    setState(() {
      _mapGenerated = Image.memory(buffer);
      EasyLoading.dismiss();
    });
  }

  _back(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    EasyLoading.show(
      status: 'Generating Map...',
      maskType: EasyLoadingMaskType.black,
    );
    _generateMap(widget.xCoordinate, widget.yCoordinate);
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
                  'Library Map',
                  style: Constants.TEXT_STYLE_HEADING_1,
                ),
              ),

              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.04),
                  child: _mapGenerated != null ? PhotoView(
                    backgroundDecoration: BoxDecoration(
                      color: Constants.COLOR_WHITE,
                    ),
                    imageProvider: _mapGenerated.image,
                  ) : Container(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}