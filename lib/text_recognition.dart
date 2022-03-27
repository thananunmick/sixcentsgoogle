import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';

class TextRecognition extends StatefulWidget {
  const TextRecognition({Key key}) : super(key: key);

  @override
  State<TextRecognition> createState() => _TextRecognitionState();
}

class _TextRecognitionState extends State<TextRecognition> {
  bool readImageFromText = false;

  XFile imageFile;

  String scannedText = "";
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Text Recognition Example"),
      ),
      body: Center(
          child: SingleChildScrollView(
        child: Container(
            margin: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // show loading while scanning fo text
                if (readImageFromText) const CircularProgressIndicator(),
                // show input image on screen
                if (imageFile != null) Image.file(File(imageFile.path)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Gallery Box UI
                    Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        padding: const EdgeInsets.only(top: 10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            onPrimary: Colors.brown,
                            shadowColor: Colors.grey[400],
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100.0)),
                          ),
                          onPressed: () {
                            getImage(ImageSource.gallery);
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.image,
                                  size: 30,
                                ),
                                Text(
                                  "Gallery",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey[600]),
                                )
                              ],
                            ),
                          ),
                        )),
                    // Camera Box UI
                    Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        padding: const EdgeInsets.only(top: 10),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            onPrimary: Colors.brown,
                            shadowColor: Colors.grey[400],
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100.0)),
                          ),
                          onPressed: () {
                            getImage(ImageSource.camera);
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.camera_alt,
                                  size: 30,
                                ),
                                Text(
                                  "Camera",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey[600]),
                                )
                              ],
                            ),
                          ),
                        )),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  scannedText,
                  style: const TextStyle(fontSize: 20),
                )
              ],
            )),
      )),
    );
  }

  void getImage(ImageSource source) async {
    try {
      final ImagePicker _picker = ImagePicker();
      // pick image from user's gallery
      final selectedImage = await _picker.pickImage(source: source);
      if (selectedImage != null) {
        readImageFromText = true;
        imageFile = selectedImage;
        setState(() {});
        getTextRecognizer(selectedImage);
      }
    } catch (e) {
      readImageFromText = false;
      imageFile = null;
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
        scannedText = scannedText + line.text + "\n";
      }
    }
    scannedText =
        scannedText.replaceAll(RegExp(r'[^\w\s]+'), '').toLowerCase().trim();
    readImageFromText = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
  }
}