import 'package:flutter/material.dart';
import 'package:flutter_ink_recognizer/screens/draw_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Handwritten Recognition',
      theme: ThemeData(
          appBarTheme: const AppBarTheme(color: Colors.brown),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Colors.brown,
          )),
      home: DrawScreen(),
    );
  }
}
