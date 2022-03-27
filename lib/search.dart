import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';
import 'communication.dart';

class Search extends StatefulWidget {
  const Search({Key key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final myController = TextEditingController();

  // Google APIKEY
  // AIzaSyCXaF8Sh83_kPP3aKJQqy0Tp-mIMZXA_ZY
  Future<http.Response> fetchAlbum() async {
    // return await http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));
    // return await http.get(Uri.parse('https://api.goog.io/v1/search/q=united+states'), headers: {"apikey": "8580552c13mshd813ce1fa6bfd6cp1d0c42jsneb9288170eaa"});
    return await http.get(Uri.parse('https://www.google.com/search?q=hi'), headers: {"apikey": "AIzaSyCXaF8Sh83_kPP3aKJQqy0Tp-mIMZXA_ZY"});
  }

  @override
  void dispose() {
    super.dispose();
    myController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color hexToColor(String code) {
      return new Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
    }

    return Scaffold(
        body: Center(
          child: Column(children: [
            Padding(padding: EdgeInsets.only(top: 130.0)),
            // Padding(padding: EdgeInsets.only(top: 50.0)),
            Text(
              'Search',
              style: TextStyle(color: hexToColor("#F2A03D"), fontSize: 25.0),
            ),
            Padding(padding: EdgeInsets.only(top: 50.0)),
            TextFormField(
              controller: myController,
              decoration: InputDecoration(
                labelText: "Enter Text",
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(),
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

                final response = fetchAlbum();
                response.then((value) => print(value.body));
                // waitToBraille(200, context);
                // Navigator.pushReplacement(
                //   context,
                //   MaterialPageRoute(builder: (context) => Braille(text: myController.text,))
                // );
              }, //This prop for beautiful expressions
              child: Text(
                  "Turn it to Braille"), // This child can be everything. I want to choose a beautiful Text Widget
              style: ElevatedButton.styleFrom(
                textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                minimumSize: Size(200, 50), //change size of this beautiful button
                // We can change style of this beautiful elevated button thanks to style prop
                primary: Colors.orange, // we can set primary color
                onPrimary: Colors.white, // change color of child prop
                onSurface: Colors.blue, // surface color
                shadowColor: Colors
                    .grey, //shadow prop is a very nice prop for every button or card widgets.
                elevation: 5, // we can set elevation of this beautiful button
                side: BorderSide(
                    color: Colors.orangeAccent.shade400, //change border color
                    width: 2, //change border width
                    style: BorderStyle
                        .solid), // change border side of this beautiful button
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      30), //change border radius of this beautiful button thanks to BorderRadius.circular function
                ),
                tapTargetSize: MaterialTapTargetSize.padded,
              ),
            ),
          ]),
        )
      );
    }
}
