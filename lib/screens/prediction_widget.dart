import 'package:flutter/material.dart';
import 'package:sixcents/models/prediction.dart';

class PredictionWidget extends StatelessWidget {
  final List<Prediction> predictions;
  const PredictionWidget({Key key, this.predictions}) : super(key: key);

  Widget _numberWidget(String char, Prediction prediction) {
    return Column(
      children: <Widget>[
        Text(
          char,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: prediction == null
                ? Colors.black
                : Colors.red.withOpacity(
                    (prediction.confidence * 2).clamp(0, 1).toDouble(),
                  ),
          ),
        ),
        Text(
          '${prediction == null ? '' : prediction.confidence.toStringAsFixed(3)}',
          style: TextStyle(
            fontSize: 12,
          ),
        )
      ],
    );
  }

  List<dynamic> getPredictionStyles(List<Prediction> predictions) {
    List<dynamic> data = [
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null,
      null
    ];
    predictions?.forEach((prediction) {
      data[prediction.index] = prediction;
    });

    return data;
  }

  @override
  Widget build(BuildContext context) {
    var styles = getPredictionStyles(this.predictions);
    List alphabets = [
      'A',
      'B',
      'C',
      'D',
      'E',
      'F',
      'G',
      'H',
      'I',
      'J',
      'K',
      'L',
      'M',
      'N',
      'O',
      'P',
      'Q',
      'R',
      'S',
      'T',
      'U',
      'V',
      'W',
      'X',
      'Y',
      'Z'
    ];
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            for (var i = 0; i < 13; i++) _numberWidget(alphabets[i], styles[i])
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            for (var i = 13; i < 26; i++) _numberWidget(alphabets[i], styles[i])
          ],
        )
      ],
    );
    // }
  }
}