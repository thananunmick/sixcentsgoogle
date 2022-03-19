import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

class Keys {
 static final GlobalKey key1 = GlobalKey();
 static final GlobalKey key2 = GlobalKey();
 static final GlobalKey key3 = GlobalKey();
 static final GlobalKey key4 = GlobalKey();
 static final GlobalKey key5 = GlobalKey();
 static final GlobalKey key6 = GlobalKey();

}

class Braille extends StatefulWidget {
  const Braille({Key? key}) : super(key: key);

  @override
  State<Braille> createState() => _BrailleState();

  static _BrailleState? of(BuildContext context) => context.findAncestorStateOfType<_BrailleState>();
}

class _BrailleState extends State<Braille>{

  double posX = 0.0;
  double posY = 0.0;
  double circleWidth = 0.0;
  var circlePosX = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
  var circlePosY = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
  var shouldVibrate = [true, true, false, true, true, false];

  void _updateLocation(PointerEvent details) {
    setState(() {
      posX = details.position.dx;
      posY = details.position.dy;
    });

    if (posX >= circlePosX[0] && posX <= circlePosX[0] + circleWidth) {
      if (posY >= circlePosY[0] && posY <= circlePosY[0] + circleWidth) {
        if (shouldVibrate[0]) {
          Vibration.vibrate(amplitude: 50, duration: 200);
        }
      }
    }

    if (posX >= circlePosX[1] && posX <= circlePosX[1] + circleWidth) {
      if (posY >= circlePosY[1] && posY <= circlePosY[1] + circleWidth) {
        if (shouldVibrate[1]) {
          Vibration.vibrate(amplitude: 50, duration: 200);
        }
      }
    }

    if (posX >= circlePosX[2] && posX <= circlePosX[2] + circleWidth) {
      if (posY >= circlePosY[2] && posY <= circlePosY[2] + circleWidth) {
        if (shouldVibrate[2]) {
          Vibration.vibrate(amplitude: 50, duration: 200);
        }
      }
    }

    if (posX >= circlePosX[3] && posX <= circlePosX[3] + circleWidth) {
      if (posY >= circlePosY[3] && posY <= circlePosY[3] + circleWidth) {
        if (shouldVibrate[3]) {
          Vibration.vibrate(amplitude: 50, duration: 200);
        }
      }
    }

    if (posX >= circlePosX[4] && posX <= circlePosX[4] + circleWidth) {
      if (posY >= circlePosY[4] && posY <= circlePosY[4] + circleWidth) {
        if (shouldVibrate[4]) {
          Vibration.vibrate(amplitude: 50, duration: 200);
        }
      }
    }

    if (posX >= circlePosX[5] && posX <= circlePosX[5] + circleWidth) {
      if (posY >= circlePosY[5] && posY <= circlePosY[5] + circleWidth) {
        if (shouldVibrate[5]) {
          Vibration.vibrate(amplitude: 50, duration: 200);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: _updateLocation,
      onPointerMove: _updateLocation,
      // appBar: AppBar(
      //   title: const Text('Braille Page'),
      // ),
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,

            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Circle(circleKey: Keys.key1, shouldVibrate: true, posX: posX, posY: posY),
                  Circle(circleKey: Keys.key2, shouldVibrate: true, posX: posX, posY: posY),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Circle(circleKey: Keys.key3, shouldVibrate: false, posX: posX, posY: posY),
                  Circle(circleKey: Keys.key4, shouldVibrate: true, posX: posX, posY: posY),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Circle(circleKey: Keys.key5, shouldVibrate: true, posX: posX, posY: posY),
                  Circle(circleKey: Keys.key6, shouldVibrate: false, posX: posX, posY: posY),
                ],
              ),
            ],
          ) 

        )
      ),
    );
  }
}

class Circle extends StatefulWidget {
  final GlobalKey circleKey;
  final bool shouldVibrate;
  double posX;
  double posY;
  Circle({Key? key, required this.circleKey, required this.shouldVibrate, required this.posX, required this.posY}) : super(key: key);
  // const Circle(this.circleKey, this.shouldVibrate);
  // Circle(this.key, this.shouldVibrate); 
  @override
  CircleState createState() => CircleState();
}

class CircleState extends State<Circle>{
  var size;
  var position;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) => _initInformation());
  }

  // @override
  // void didUpdateWidget(Braille oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   print("Updated");
  // }

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
    // if (true) {
      // Vibration.vibrate(amplitude: 50, duration: 200);
    // }
    return Container(
      // margin: EdgeInsets.all(100.0),
      key: widget.circleKey,
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        color: widget.shouldVibrate ? Colors.black : Colors.white,
        shape: BoxShape.circle
      ),
      // child: GestureDetector(
      //   // onPointerMove: (PointerMoveEvent event) {
      //   //   Vibration.vibrate(amplitude: 50, duration: 200);
      //   // },
      //   onPanStart: (DragStartDetails details) {
      //     // print("START");
      //     // print(details);
      //     Vibration.vibrate(amplitude: 50, duration: 200);
      //   },

      //   onPanUpdate: (DragUpdateDetails details) {
      //     // print("UPDATE");
      //     // print(details);
      //     Vibration.vibrate(amplitude: 50, duration: 200);
      //   },
      //   child: InkWell(
      //     onHover: (hovering) {
      //       if (hovering) {
      //         Vibration.vibrate(amplitude: 50, duration: 200);
      //       }
      //     },
      //     onTap: () {
      //       // _getSizes();
      //       // _getPosition();
      //       print(size);
      //       print(position);
      //     },
      //   ),
      // )
    );
  }
}