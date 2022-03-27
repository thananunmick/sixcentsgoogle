// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:vibration/vibration.dart';
// import 'communication.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       // home: const MyHomePage(title: 'Flutter Demo Home Page'),
//       home: BootupPage()
//     );
//   }
// }

// Future<void> waittohome(int dur, BuildContext ctxt) async {
//   await Future.delayed(Duration(milliseconds: dur));
//   Navigator.pushReplacement(
//     ctxt,
//     MaterialPageRoute(builder: (context) => const MyHomePage(title: "HOME_PAGE")),
//   );
// }

// class BootupPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext ctxt) {
//     Vibration.vibrate(pattern: [0, 1000, 200, 1000, 200, 1000, 200, 1000]);
//     waittohome(5000, ctxt);
//     return Scaffold(
//         backgroundColor: Colors.white,
//         body: Center(
//           child:
//             Image.asset(
//            'images/SixCents_logo.png',
//            scale: 1.5
//            ),
//         ),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key, required this.title}) : super(key: key);

//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.

//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;

//   void _incrementCounter() {
//     setState(() {
//       // This call to setState tells the Flutter framework that something has
//       // changed in this State, which causes it to rerun the build method below
//       // so that the display can reflect the updated values. If we changed
//       // _counter without calling setState(), then the build method would not be
//       // called again, and so nothing would appear to happen.
//       _counter++;
//     });
//   }

//   Future<void> doubleVibrate() async {
//     Vibration.vibrate(amplitude: 50, duration: 200);
//     await Future.delayed(Duration(milliseconds: 400));
//     Vibration.vibrate(amplitude: 50, duration: 200);
//   }

//   @override
//   Widget build(BuildContext context) {
//     // This method is rerun every time setState is called, for instance as done
//     // by the _incrementCounter method above.
//     //
//     // The Flutter framework has been optimized to make rerunning build methods
//     // fast, so that you can just rebuild anything that needs updating rather
//     // than having to individually change instances of widgets.
//     return Scaffold(
//       // appBar: AppBar(
//       //   // Here we take the value from the MyHomePage object that was created by
//       //   // the App.build method, and use it to set our appbar title.
//       //   title: Text(widget.title),
//       // ),
//       body: Center(
//         // Center is a layout widget. It takes a single child and positions it
//         // in the middle of the parent.
//         // child: Column(
//         //   // Column is also a layout widget. It takes a list of children and
//         //   // arranges them vertically. By default, it sizes itself to fit its
//         //   // children horizontally, and tries to be as tall as its parent.
//         //   //
//         //   // Invoke "debug painting" (press "p" in the console, choose the
//         //   // "Toggle Debug Paint" action from the Flutter Inspector in Android
//         //   // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
//         //   // to see the wireframe for each widget.
//         //   //
//         //   // Column has various properties to control how it sizes itself and
//         //   // how it positions its children. Here we use mainAxisAlignment to
//         //   // center the children vertically; the main axis here is the vertical
//         //   // axis because Columns are vertical (the cross axis would be
//         //   // horizontal).
//         //   mainAxisAlignment: MainAxisAlignment.center,
//         //   children: <Widget>[
//         //     const Text(
//         //       'You have pushed the button this many times:',
//         //     ),
//         //     Text(
//         //       '$_counter',
//         //       style: Theme.of(context).textTheme.headline4,
//         //     ),
//         //   ],
//         // ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Expanded(child: 
//               Container(
//                 child: Material(
//                   color: const Color(0xff815839),
//                   child: InkWell(
//                     onLongPress: () {
//                       Vibration.vibrate(amplitude: 50, duration: 200);
//                       // Clipboard.setData(ClipboardData(text: "Vibrate"));
//                       // HapticFeedback.vibrate();
//                     },
//                     onDoubleTap: () {

//                     },
//                   )
//                 ),
//               ),
//             ),
//             Expanded(child: 
//               Container(
//                 child: Material(
//                   color: const Color(0xff143642),
//                   child: InkWell(
//                     onLongPress: () {
//                       doubleVibrate();
//                       // Clipboard.setData(ClipboardData(text: "Vibrate"));
//                       // HapticFeedback.vibrate();
//                     },
//                     onDoubleTap: () {
//                       Navigator.push(
//                         context, 
//                         MaterialPageRoute(builder: (context) => Braille(text: "",)));
//                     },
//                   )
//                 ),
//               ),
//             )
//           ]
//           ), 
//       ),
//       // floatingActionButton: FloatingActionButton(
//       //   onPressed: _incrementCounter,
//       //   tooltip: 'Increment',
//       //   child: const Icon(Icons.add),
//       // ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
