import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_ink_recognizer/models/prediction.dart';
import 'package:flutter_ink_recognizer/screens/drawing_painter.dart';
import 'package:flutter_ink_recognizer/screens/prediction_widget.dart';
import 'package:flutter_ink_recognizer/services/recognizer.dart';
import 'package:flutter_ink_recognizer/utils/constants.dart';
import 'package:requests/requests.dart';

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

  @override
  void initState() {
    super.initState();
    _initModel();
  }

  @override
  Widget build(BuildContext context) {
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
      appBar: AppBar(
        title: Text('Monomer'),
      ),
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
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
              _alphabetPreviewImage(),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          _drawCanvasWidget(),
          SizedBox(
            height: 10,
          ),
          PredictionWidget(
            predictions: _prediction,
          ),
        ],
      ),
      floatingActionButton: Container(
        padding: EdgeInsets.only(
            bottom: Constants.predictionWidgetHeight +
                Constants.spaceBetweenCanvas),
        child: Align(
          alignment: Alignment.bottomRight,
          child: FloatingActionButton.extended(
            icon: Icon(Icons.clear),
            onPressed: () async {
              setState(() {
                _points.clear();
                _prediction.clear();
                predResults = "";
              });
            },
            label: Text('clear'),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndDocked,
    );
  }

  Widget _drawCanvasWidget() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
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
          Future.delayed(Duration(milliseconds: 1500), () async {
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
