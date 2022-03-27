// import 'dart:async';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:vibration/vibration.dart';
// import 'package:perfect_volume_control/perfect_volume_control.dart';
// import 'textbox.dart';

// class Keys {
//  static final GlobalKey key1 = GlobalKey();
//  static final GlobalKey key2 = GlobalKey();
//  static final GlobalKey key3 = GlobalKey();
//  static final GlobalKey key4 = GlobalKey();
//  static final GlobalKey key5 = GlobalKey();
//  static final GlobalKey key6 = GlobalKey();
// }

// class Braille extends StatefulWidget {
//   final String text;
//   const Braille({Key? key, required this.text}) : super(key: key);

//   @override
//   State<Braille> createState() => _BrailleState();

//   static _BrailleState? of(BuildContext context) => context.findAncestorStateOfType<_BrailleState>();
// }

// class _BrailleState extends State<Braille>{
//   double posX = 0.0;
//   double posY = 0.0;
//   double circleWidth = 0.0;
//   var circlePosX = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
//   var circlePosY = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
//   var shouldVibrate = [true, true, false, true, true, false];
//   double currentvol = 0.5;
//   String buttontype = "none";
//   late StreamSubscription _volumeButton;

//   void changePage() {
//     if (buttontype == "up") {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => TextBox())
//       );
//     } 
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _volumeButton.cancel();
//   }
  
//   @override
//   void initState() {
//     Future.delayed(Duration.zero,() async {
//         currentvol = await PerfectVolumeControl.getVolume();
//         //get current volume

//         setState(() {
//             //refresh UI
//         });
//     });

//     _volumeButton = PerfectVolumeControl.stream.listen((volume) {  
//       //volume button is pressed, 
//       // this listener will be triggeret 3 times at one button press
        
//        if(volume != currentvol){ //only execute button type check once time
//            if(volume > currentvol){ //if new volume is greater, then it up button
//               buttontype = "up";
//            }else{ //else it is down button
//               buttontype = "down";
//            }
//        }

//        setState(() {
//           currentvol = volume;
//        });
//     });

//     super.initState();
//   }

//   void _updateLocation(PointerEvent details) {
//     setState(() {
//       posX = details.position.dx;
//       posY = details.position.dy;
//     });

//     if (posX >= circlePosX[0] && posX <= circlePosX[0] + circleWidth) {
//       if (posY >= circlePosY[0] && posY <= circlePosY[0] + circleWidth) {
//         if (shouldVibrate[0]) {
//           Vibration.vibrate(amplitude: 50, duration: 200);
//         }
//       }
//     }

//     if (posX >= circlePosX[1] && posX <= circlePosX[1] + circleWidth) {
//       if (posY >= circlePosY[1] && posY <= circlePosY[1] + circleWidth) {
//         if (shouldVibrate[1]) {
//           Vibration.vibrate(amplitude: 50, duration: 200);
//         }
//       }
//     }

//     if (posX >= circlePosX[2] && posX <= circlePosX[2] + circleWidth) {
//       if (posY >= circlePosY[2] && posY <= circlePosY[2] + circleWidth) {
//         if (shouldVibrate[2]) {
//           Vibration.vibrate(amplitude: 50, duration: 200);
//         }
//       }
//     }

//     if (posX >= circlePosX[3] && posX <= circlePosX[3] + circleWidth) {
//       if (posY >= circlePosY[3] && posY <= circlePosY[3] + circleWidth) {
//         if (shouldVibrate[3]) {
//           Vibration.vibrate(amplitude: 50, duration: 200);
//         }
//       }
//     }

//     if (posX >= circlePosX[4] && posX <= circlePosX[4] + circleWidth) {
//       if (posY >= circlePosY[4] && posY <= circlePosY[4] + circleWidth) {
//         if (shouldVibrate[4]) {
//           Vibration.vibrate(amplitude: 50, duration: 200);
//         }
//       }
//     }

//     if (posX >= circlePosX[5] && posX <= circlePosX[5] + circleWidth) {
//       if (posY >= circlePosY[5] && posY <= circlePosY[5] + circleWidth) {
//         if (shouldVibrate[5]) {
//           Vibration.vibrate(amplitude: 50, duration: 200);
//         }
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     WidgetsBinding.instance?.addPostFrameCallback((_) => changePage());
//     return Listener(
//       onPointerDown: _updateLocation,
//       onPointerMove: _updateLocation,
//       // appBar: AppBar(
//       //   title: const Text('Braille Page'),
//       // ),
//       child: Scaffold(
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,

//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   Circle(circleKey: Keys.key1, shouldVibrate: true, posX: posX, posY: posY),
//                   Circle(circleKey: Keys.key2, shouldVibrate: true, posX: posX, posY: posY),
//                 ],
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   Circle(circleKey: Keys.key3, shouldVibrate: false, posX: posX, posY: posY),
//                   Circle(circleKey: Keys.key4, shouldVibrate: true, posX: posX, posY: posY),
//                 ],
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   Circle(circleKey: Keys.key5, shouldVibrate: true, posX: posX, posY: posY),
//                   Circle(circleKey: Keys.key6, shouldVibrate: false, posX: posX, posY: posY),
//                 ],
//               ),
//             ],
//           ) 

//         )
//       ),
//     );
//   }
// }

// class Circle extends StatefulWidget {
//   final GlobalKey circleKey;
//   final bool shouldVibrate;
//   double posX;
//   double posY;
//   Circle({Key? key, required this.circleKey, required this.shouldVibrate, required this.posX, required this.posY}) : super(key: key);

//   @override
//   CircleState createState() => CircleState();
// }

// class CircleState extends State<Circle>{
//   var size;
//   var position;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance?.addPostFrameCallback((_) => _initInformation());
//   }

//   _initInformation() {
//     setState(() {
//      size = _getSizes(); 
//      position = _getPosition();
//     });

//     Braille.of(context)?.circleWidth = size;

//     if (widget.circleKey == Keys.key1) {
//       Braille.of(context)?.circlePosX[0] = position.dx;
//       Braille.of(context)?.circlePosY[0] = position.dy;
//     } else if (widget.circleKey == Keys.key2) {
//       Braille.of(context)?.circlePosX[1] = position.dx;
//       Braille.of(context)?.circlePosY[1] = position.dy;
//     } else if (widget.circleKey == Keys.key3) {
//       Braille.of(context)?.circlePosX[2] = position.dx;
//       Braille.of(context)?.circlePosY[2] = position.dy;
//     } else if (widget.circleKey == Keys.key4) {
//       Braille.of(context)?.circlePosX[3] = position.dx;
//       Braille.of(context)?.circlePosY[3] = position.dy;
//     } else if (widget.circleKey == Keys.key5) {
//       Braille.of(context)?.circlePosX[4] = position.dx;
//       Braille.of(context)?.circlePosY[4] = position.dy;
//     } else if (widget.circleKey == Keys.key6) {
//       Braille.of(context)?.circlePosX[5] = position.dx;
//       Braille.of(context)?.circlePosY[5] = position.dy;
//     }
//   }

//   _getSizes() {
//     if (widget.circleKey!= null) {
//       final RenderBox box = widget.circleKey.currentContext?.findRenderObject() as RenderBox; 
//       final size = box.size.width;
//       return size;
//     }
//   }

//   _getPosition() {
//     if (widget.circleKey!=null) {
//       final RenderBox box = widget.circleKey.currentContext?.findRenderObject() as RenderBox; 
//       final position = box.localToGlobal(Offset.zero);
//       return position;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       key: widget.circleKey,
//       width: 150,
//       height: 150,
//       decoration: BoxDecoration(
//         color: widget.shouldVibrate ? Colors.black : Colors.white,
//         shape: BoxShape.circle
//       ),
//     );
//   }
// }