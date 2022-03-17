import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child:
            Image.asset(
                'images/SixCents_logo.png',
              scale: 1.5
            ),
        )
      ),
    ),
  );
}
