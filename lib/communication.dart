import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import 'package:perfect_volume_control/perfect_volume_control.dart';
import 'textbox.dart';
import 'string_to_braille.dart';

class Keys {
 static final GlobalKey key1 = GlobalKey();
 static final GlobalKey key2 = GlobalKey();
 static final GlobalKey key3 = GlobalKey();
 static final GlobalKey key4 = GlobalKey();
 static final GlobalKey key5 = GlobalKey();
 static final GlobalKey key6 = GlobalKey();
}

class Braille extends StatefulWidget {
  final String text;
  const Braille({Key key, this.text}) : super(key: key);

  @override
  State<Braille> createState() => _BrailleState();

  static _BrailleState of(BuildContext context) => context.findAncestorStateOfType<_BrailleState>();
}

class _BrailleState extends State<Braille>{
  double posX = 0.0;
  double posY = 0.0;
  double circleWidth = 0.0;
  int count = 0;
  var circlePosX = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
  var circlePosY = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
  var shouldVibrate = [[false, false, false, false, false, false]];
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

  Future<void> tripleVibrate() async {
    Vibration.vibrate(amplitude: 50, duration: 200);
    await Future.delayed(Duration(milliseconds: 400));
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
    tripleVibrate();
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

    shouldVibrate = textToBraille(widget.text);
    shouldVibrate.add([false, false, false, false, false, false]);

    super.initState();
  }

  void _updateLocation(PointerEvent details) {
    setState(() {
      posX = details.position.dx;
      posY = details.position.dy;
    });

    if (posX >= circlePosX[0] && posX <= circlePosX[0] + circleWidth) {
      if (posY >= circlePosY[0] && posY <= circlePosY[0] + circleWidth) {
        if (shouldVibrate[count][0]) {
          Vibration.vibrate(amplitude: 50, duration: 200);
        }
      }
    }

    if (posX >= circlePosX[1] && posX <= circlePosX[1] + circleWidth) {
      if (posY >= circlePosY[1] && posY <= circlePosY[1] + circleWidth) {
        if (shouldVibrate[count][1]) {
          Vibration.vibrate(amplitude: 50, duration: 200);
        }
      }
    }

    if (posX >= circlePosX[2] && posX <= circlePosX[2] + circleWidth) {
      if (posY >= circlePosY[2] && posY <= circlePosY[2] + circleWidth) {
        if (shouldVibrate[count][2]) {
          Vibration.vibrate(amplitude: 50, duration: 200);
        }
      }
    }

    if (posX >= circlePosX[3] && posX <= circlePosX[3] + circleWidth) {
      if (posY >= circlePosY[3] && posY <= circlePosY[3] + circleWidth) {
        if (shouldVibrate[count][3]) {
          Vibration.vibrate(amplitude: 50, duration: 200);
        }
      }
    }

    if (posX >= circlePosX[4] && posX <= circlePosX[4] + circleWidth) {
      if (posY >= circlePosY[4] && posY <= circlePosY[4] + circleWidth) {
        if (shouldVibrate[count][4]) {
          Vibration.vibrate(amplitude: 50, duration: 200);
        }
      }
    }

    if (posX >= circlePosX[5] && posX <= circlePosX[5] + circleWidth) {
      if (posY >= circlePosY[5] && posY <= circlePosY[5] + circleWidth) {
        if (shouldVibrate[count][5]) {
          Vibration.vibrate(amplitude: 50, duration: 200);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((_) => changePage());
    return Listener(
      onPointerDown: _updateLocation,
      onPointerMove: _updateLocation,
      // appBar: AppBar(
      //   title: const Text('Braille Page'),
      // ),
      child: GestureDetector(
        onDoubleTap: () {
          setState(() {
            if (count < shouldVibrate.length - 1) {
              count++;
            }
          });
        },
        child: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,

              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Circle(circleKey: Keys.key1, shouldVibrate: shouldVibrate[count][0], posX: posX, posY: posY),
                    Circle(circleKey: Keys.key2, shouldVibrate: shouldVibrate[count][1], posX: posX, posY: posY),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Circle(circleKey: Keys.key3, shouldVibrate: shouldVibrate[count][2], posX: posX, posY: posY),
                    Circle(circleKey: Keys.key4, shouldVibrate: shouldVibrate[count][3], posX: posX, posY: posY),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Circle(circleKey: Keys.key5, shouldVibrate: shouldVibrate[count][4], posX: posX, posY: posY),
                    Circle(circleKey: Keys.key6, shouldVibrate: shouldVibrate[count][5], posX: posX, posY: posY),
                  ],
                ),
              ],
            ) 

          )
        ), 
      )
    );
  }
}

Color hexToColor(String code) {
  return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
}

class Circle extends StatefulWidget {
  final GlobalKey circleKey;
  final bool shouldVibrate;
  double posX;
  double posY;
  Circle({Key key, this.circleKey, this.shouldVibrate, this.posX, this.posY}) : super(key: key);

  @override
  CircleState createState() => CircleState();
}

class CircleState extends State<Circle>{
  var size;
  var position;
  Color color = hexToColor('#935E38');


  @override
  void initState() {
    if (widget.circleKey == Keys.key1) {
      color = hexToColor('#935E38');
    } else if (widget.circleKey == Keys.key2) {
      color = hexToColor('#5C4D3C');
    } else if (widget.circleKey == Keys.key3) {
      color = hexToColor('#815839');
    } else if (widget.circleKey == Keys.key4) {
      color = hexToColor('#4A473E');
    } else if (widget.circleKey == Keys.key5) {
      color = hexToColor('#6F523B');
    } else if (widget.circleKey == Keys.key6) {
      color = hexToColor('#38413F');
    }
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) => _initInformation());
  }

  _initInformation() {
    setState(() {
     size = _getSizes(); 
     position = _getPosition();
    });

    Braille.of(context)?.circleWidth = size;

    if (widget.circleKey == Keys.key1) {
      Braille.of(context)?.circlePosX[0] = position.dx;
      Braille.of(context)?.circlePosY[0] = position.dy;
    } else if (widget.circleKey == Keys.key2) {
      Braille.of(context)?.circlePosX[1] = position.dx;
      Braille.of(context)?.circlePosY[1] = position.dy;
    } else if (widget.circleKey == Keys.key3) {
      Braille.of(context)?.circlePosX[2] = position.dx;
      Braille.of(context)?.circlePosY[2] = position.dy;
    } else if (widget.circleKey == Keys.key4) {
      Braille.of(context)?.circlePosX[3] = position.dx;
      Braille.of(context)?.circlePosY[3] = position.dy;
    } else if (widget.circleKey == Keys.key5) {
      Braille.of(context)?.circlePosX[4] = position.dx;
      Braille.of(context)?.circlePosY[4] = position.dy;
    } else if (widget.circleKey == Keys.key6) {
      Braille.of(context)?.circlePosX[5] = position.dx;
      Braille.of(context)?.circlePosY[5] = position.dy;
    }
  }

  _getSizes() {
    if (widget.circleKey!= null) {
      final RenderBox box = widget.circleKey.currentContext?.findRenderObject() as RenderBox; 
      final size = box.size.width;
      return size;
    }
  }

  _getPosition() {
    if (widget.circleKey!=null) {
      final RenderBox box = widget.circleKey.currentContext?.findRenderObject() as RenderBox; 
      final position = box.localToGlobal(Offset.zero);
      return position;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: widget.circleKey,
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        color: widget.shouldVibrate ? color : Colors.white,
        shape: BoxShape.circle
      ),
    );
  }
}