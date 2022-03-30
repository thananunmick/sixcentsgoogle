import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sixcents/screens/draw_screen.dart';
import 'package:sixcents/text_recognition.dart';
import 'package:sixcents/textbox.dart';
import 'package:vibration/vibration.dart';
import 'communication.dart';
import 'search.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(MyApp()));
  // runApp(const MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      home: BootupPage()
    );
  }
}

Future<void> waittohome(int dur, BuildContext ctxt) async {
  await Future.delayed(Duration(milliseconds: dur));
  Navigator.pushReplacement(
    ctxt,
    // MaterialPageRoute(builder: (context) => const MyHomePage(title: "HOME_PAGE")),
    MaterialPageRoute(builder: (context) => TextBox()),
    // MaterialPageRoute(builder: (context) => TextRecognition()),
  );
}

class BootupPage extends StatelessWidget {
  @override
  Widget build(BuildContext ctxt) {
    Vibration.vibrate(pattern: [0, 1000, 200, 500, 200, 500, 200, 1000]);
    waittohome(4000, ctxt);
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child:
            Image.asset(
           'images/SixCents_logo.png',
           scale: 1.5
           ),
        ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  Future<void> doubleVibrate() async {
    Vibration.vibrate(amplitude: 50, duration: 200);
    await Future.delayed(Duration(milliseconds: 400));
    Vibration.vibrate(amplitude: 50, duration: 200);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: 
              Container(
                child: Material(
                  color: const Color(0xff815839),
                  child: InkWell(
                    onLongPress: () {
                      Vibration.vibrate(amplitude: 50, duration: 200);
                      // Clipboard.setData(ClipboardData(text: "Vibrate"));
                      // HapticFeedback.vibrate();
                    },
                    onDoubleTap: () {
                      Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context) => Search()));
                    },
                  )
                ),
              ),
            ),
            Expanded(child: 
              Container(
                child: Material(
                  color: const Color(0xff143642),
                  child: InkWell(
                    onLongPress: () {
                      doubleVibrate();
                      // Clipboard.setData(ClipboardData(text: "Vibrate"));
                      // HapticFeedback.vibrate();
                    },
                    onDoubleTap: () {
                      Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context) => Braille(text: "",)));
                    },
                  )
                ),
              ),
            )
          ]
          ), 
      ),
    );
  }
}
