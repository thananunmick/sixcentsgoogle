import 'dart:async';
import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sixcents/screens/draw_screen.dart';
import 'package:vibration/vibration.dart';
import 'package:perfect_volume_control/perfect_volume_control.dart';
import 'communication.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class TextBox extends StatefulWidget {
  @override
  State<TextBox> createState() => _TextBoxState();
}

class _TextBoxState extends State<TextBox> {
  double currentvol = 0.5;
  String buttontype = "none";
  StreamSubscription _volumeButton;
  final myController = TextEditingController();
  var imagePicker;
  var _image;
  bool readImageFromText = false;
  String scannedText = null;

  void changePage() {
    if (buttontype == "up") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DrawScreen())
      );
    } 
  }

  void getImage(ImageSource source) async {
    try {
      final ImagePicker _picker = ImagePicker();
      // pick image from user's gallery
      final selectedImage = await _picker.pickImage(source: source);
      if (selectedImage != null) {
        readImageFromText = true;
        _image = selectedImage;
        setState(() {});
        getTextRecognizer(selectedImage);
      }
    } catch (e) {
      readImageFromText = false;
      _image = null;
      scannedText = "Error occured";
      setState(() {});
    }
  }

  void getTextRecognizer(var image) async {
    final inputImage = InputImage.fromFilePath(image.path);
    final textDetector = GoogleMlKit.vision.textDetector();
    RecognisedText recognisedText = await textDetector.processImage(inputImage);
    await textDetector.close();
    scannedText = "";
    for (TextBlock block in recognisedText.blocks) {
      for (TextLine line in block.lines) {
        scannedText = scannedText + line.text + " ";
      }
    }
    scannedText =
        scannedText.replaceAll(RegExp(r'[^\w\s]+'), '').toLowerCase().trim();
    readImageFromText = false;
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _volumeButton.cancel();
    myController.dispose();
  }

  @override
  void initState() {
    Vibration.vibrate(amplitude: 50, duration: 200);
    imagePicker = ImagePicker();
    Future.delayed(Duration.zero,() async {
        currentvol = await PerfectVolumeControl.getVolume();

        setState(() {
        });
    });

    _volumeButton = PerfectVolumeControl.stream.listen((volume) {  
        
       if(volume != currentvol){
           if(volume > currentvol){
              buttontype = "up";
           }else{
              buttontype = "down";
           }
       }

       setState(() {
          currentvol = volume;
       });
    });

    super.initState();
  }

  Future<void> waitToBraille(int dur, BuildContext ctxt, String text) async {
    await Future.delayed(Duration(milliseconds: dur));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Braille(text: text,))
    );
  }

  @override
  Widget build(BuildContext context){
    WidgetsBinding.instance?.addPostFrameCallback((_) => changePage());
    // https://om-m-mestry.medium.com/to-create-a-beautiful-text-box-with-in-flutter-a7a4d11ae13f
    Color hexToColor(String code) {
      return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
    }

    if (scannedText != null) {
      print(scannedText);
      waitToBraille(200, context, scannedText);
    }

    return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: "Welcome to Flutter",
            home: Material(
                child: Container (
                    padding: const EdgeInsets.all(30.0),
                    color: Colors.white,
                    // color: Color.fromARGB(255, 255,255,186),
                    child: Container(
                      child: Center(
                        child: Column(
                        children : [
                          if (readImageFromText) const CircularProgressIndicator(),
                          Padding(padding: EdgeInsets.only(top: 130.0)),
                          // Padding(padding: EdgeInsets.only(top: 50.0)),
                          Text('What\'s on your mind?',
                          style: TextStyle(color: hexToColor("#7f5539"), fontSize: 25.0),),
                          // style: TextStyle(color: hexToColor("#ffdfba"), fontSize: 25.0),),
                          Padding(padding: EdgeInsets.only(top: 50.0)),
                          TextFormField(
                            controller: myController,
                            decoration: InputDecoration(
                              labelText: "Enter Text",
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25.0),
                                borderSide: BorderSide(
                                ),
                              ),
                            ),
                            keyboardType: TextInputType.text,
                            style: TextStyle(
                              fontFamily: "Poppins",
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(top: 50.0)),
                          // https://yalcingolayoglu.medium.com/flutter-beautiful-buttons-962c0a11c6db
                          ElevatedButton(
                            onPressed: () {
                              FocusScopeNode currentFocus = FocusScope.of(context);

                              if (!currentFocus.hasPrimaryFocus) {
                                currentFocus.unfocus();
                              }

                              waitToBraille(200, context, myController.text);
                            }, 
                            child: Text("Turn it to Braille"),
                            style: ElevatedButton.styleFrom(
                              textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              minimumSize: Size(200, 50),
                              primary: hexToColor("#ddb892"),
                              onPrimary: Colors.white,
                              onSurface: Colors.blue,
                              shadowColor: Colors
                                  .grey,
                              elevation: 5,
                              side: BorderSide(
                                  color: hexToColor("#ddb892"),
                                  width: 2,
                                  style: BorderStyle
                                      .solid),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    30),
                              ),
                              tapTargetSize: MaterialTapTargetSize.padded,
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(top: 50.0)),
                          Divider(
                            // height: 20,
                            thickness: 1,
                            // indent: 20,
                            // endIndent: 0,
                            color: hexToColor("#9c6644"),
                          ),
                          // Padding(padding: EdgeInsets.only(top: 140.0)),
                          Padding(padding: EdgeInsets.only(top: 50.0)),
                          Text('What\'s on your picture?',
                          style: TextStyle(color: hexToColor("#7f5539"), fontSize: 25.0),),
                          Padding(padding: EdgeInsets.only(top: 50.0)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            // crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  getImage(ImageSource.gallery);
                                },
                                child: Text("Gallery"),
                                style: ElevatedButton.styleFrom(
                                  textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  minimumSize: Size(125, 100),
                                  primary: hexToColor("#ddb892"),
                                  onPrimary: Colors.white,
                                  onSurface: Colors.blue,
                                  shadowColor: Colors
                                      .grey,
                                  elevation: 5,
                                  side: BorderSide(
                                      color: hexToColor("#ddb892"),
                                      width: 2,
                                      style: BorderStyle
                                          .solid),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        30),
                                  ),
                                  tapTargetSize: MaterialTapTargetSize.padded,
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  getImage(ImageSource.camera);
                                },
                                child: Text("Camera"),
                                style: ElevatedButton.styleFrom(
                                  textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  minimumSize: Size(125, 100),
                                  primary: hexToColor("#ddb892"),
                                  onPrimary: Colors.white,
                                  onSurface: Colors.blue,
                                  shadowColor: Colors
                                      .grey,
                                  elevation: 5,
                                  side: BorderSide(
                                      color: hexToColor("#ddb892"),
                                      width: 2,
                                      style: BorderStyle
                                          .solid),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        30),
                                  ),
                                  tapTargetSize: MaterialTapTargetSize.padded,
                                ),
                              ),
                            ],
                          ),
                        ]
                        )
                    ),
                  )
                )
            )
        );
  }
  
}