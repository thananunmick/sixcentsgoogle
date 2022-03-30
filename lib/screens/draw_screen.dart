import 'dart:typed_data';
import 'dart:ui';
import 'dart:async';
import 'package:sixcents/textbox.dart';
import 'package:perfect_volume_control/perfect_volume_control.dart';

import 'package:flutter/material.dart';
import 'package:sixcents/models/prediction.dart';
import 'package:sixcents/screens/drawing_painter.dart';
import 'package:sixcents/screens/prediction_widget.dart';
import 'package:sixcents/services/recognizer.dart';
import 'package:sixcents/utils/constants.dart';
import 'package:requests/requests.dart';
import 'package:vibration/vibration.dart';

class DrawScreen extends StatefulWidget {
  @override
  _DrawScreenState createState() => _DrawScreenState();
}

class _DrawScreenState extends State<DrawScreen> {
  // ignore: deprecated_member_use
  final _points = List<Offset>();
  final _recognizer = Recognizer();
  List<Prediction> _prediction;
  bool initialize = false;
  static var padding;
  var height;
  var deviceHeight;
  var width;
  var firstClock;
  String predResults = "";
  String wordBreakResults = "";
  double currentvol = 0.5;
  String buttontype = "none";
  StreamSubscription _volumeButton;

  void changePage() {
    if (buttontype == "down") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => TextBox())
      );
    } 
  }
  
  Future<void> doubleVibrate() async {
    Vibration.vibrate(amplitude: 50, duration: 200);
    await Future.delayed(Duration(milliseconds: 400));
    Vibration.vibrate(amplitude: 50, duration: 200);
  }

  @override
  void dispose() {
    super.dispose();
    _volumeButton.cancel();
  }

  @override
  void initState() {
    doubleVibrate();
    Future.delayed(Duration.zero,() async {
        currentvol = await PerfectVolumeControl.getVolume();
        //get current volume

        setState(() {
            //refresh UI
        });
    });

    _volumeButton = PerfectVolumeControl.stream.listen((volume) {  
      //volume button is pressed, 
      // this listener will be triggeret 3 times at one button press
        
       if(volume != currentvol){ //only execute button type check once time
           if(volume > currentvol){ //if new volume is greater, then it up button
              buttontype = "up";
           }else{ //else it is down button
              buttontype = "down";
           }
       }

       setState(() {
          currentvol = volume;
       });
    });

    super.initState();
    _initModel();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((_) => changePage());
    //Size in logical pixels
    padding = MediaQuery.of(context).viewPadding;
    width = MediaQuery.of(context).size.width;
    // Height (without status(padding.top) and toolbar(kToolbarHeight))
    height = MediaQuery.of(context).size.height -
        padding.top -
        kToolbarHeight -
        (MediaQuery.of(context).size.height / 6) -
        Constants.spaceBetweenCanvas -
        Constants.predictionWidgetHeight;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      // appBar: AppBar(
      //   title: Text('Monomer'),
      // ),
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(padding: EdgeInsets.only(top: 150.0)),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        predResults,
                      ),
                    ],
                  ),
                ),
              ),
              // _alphabetPreviewImage(),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          _drawCanvasWidget(),
          SizedBox(
            height: 10,
          ),
          // PredictionWidget(
          //   predictions: _prediction,
          // ),
        ],
      ),
      // floatingActionButton: Container(
      //   padding: EdgeInsets.only(
      //       bottom: Constants.predictionWidgetHeight +
      //           Constants.spaceBetweenCanvas),
      //   child: Align(
      //     alignment: Alignment.bottomRight,
      //     child: FloatingActionButton.extended(
      //       icon: Icon(Icons.clear),
      //       onPressed: () async {
      //         setState(() {
      //           _points.clear();
      //           _prediction.clear();
      //           predResults = "";
      //         });
      //       },
      //       label: Text('clear'),
      //     ),
      //   ),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.miniEndDocked,
    );
  }

  Color hexToColor(String code) {
    return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }

  Widget _drawCanvasWidget() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: Border.all(
          color: hexToColor("#9c6644"),
          width: Constants.borderSize,
        ),
      ),
      child: GestureDetector(
        onPanUpdate: (DragUpdateDetails details) {
          Offset _localPosition = details.localPosition;
          setState(() {
            _points.add(_localPosition);
            firstClock = DateTime.now();
          });
        },
        onPanEnd: (DragEndDetails details) {
          _points.add(null);
          var cpyTime = firstClock.microsecondsSinceEpoch;
          Future.delayed(Duration(milliseconds: 400), () {
            if (firstClock.microsecondsSinceEpoch == cpyTime) {
              _recognize();
              _points.clear();
              if (_prediction != null) {
                _prediction.clear();
              }
            }
          });
          Future.delayed(Duration(milliseconds: 2000), () async {
            if (firstClock.microsecondsSinceEpoch == cpyTime) {
              wordBreakResults = await getWord(predResults);
              if (wordBreakResults != null) {
                setState(() {
                  predResults = wordBreakResults;
                });
              }
            }
          });
        },
        child: CustomPaint(
          painter: DrawingPainter(_points),
        ),
      ),
    );
  }

  Widget _alphabetPreviewImage() {
    //size in logical pixles
    var logicalScreenSize = window.physicalSize / pixelRatio;
    var logicalWidth = logicalScreenSize.width;
    var logicalHeight = logicalScreenSize.height;
    return Container(
      width: logicalWidth / 3,
      height: logicalHeight / 6,
      color: Colors.black,
      child: FutureBuilder(
        future: _previewImage(),
        builder: (BuildContext _, snapshot) {
          if (snapshot.hasData) {
            return Image.memory(
              snapshot.data,
              fit: BoxFit.fill,
            );
          } else {
            return Center(
              child: Text('Error'),
            );
          }
        },
      ),
    );
  }

  void _initModel() async {
    // ignore: unused_local_variable
    var res = await _recognizer.loadModel();
  }

  Future<Uint8List> _previewImage() async {
    return await _recognizer.previewImage(_points);
  }

  void _recognize() async {
    List<dynamic> pred = await _recognizer.recognize(_points);
    setState(() {
      _prediction = pred.map((json) => Prediction.fromJson(json)).toList();
      predResults += pred[0]["label"].toLowerCase();
    });
  }

  Future<String> getWord(String wordToBreak) async {
    try {
      var r = await Requests.get(
          'https://break-word.herokuapp.com/arrange?text=${wordToBreak}');
      if (r.success) {
        var body = r.json();
        return body["Text"];
      }
    } catch (e) {
      return null;
    }
    return null;
  }
}