import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext ctxt) {
    return MaterialApp(
        home: BootupPage());
  }
}


class BootupPage extends StatelessWidget {
  @override
  Widget build(BuildContext ctxt) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child:
            Image.asset(
           'images/SixCents_logo.png',
           scale: 1.5
           ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              ctxt,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
          backgroundColor: Colors.green,
          child: const Icon(Icons.navigation),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build (BuildContext ctxt) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Home"),
      ),
      body: new Text("testtesttest"),
    );
  }
}