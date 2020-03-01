import 'package:flutter/material.dart';
import 'dart:io';
import 'dots.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatefulWidget {
  final String imagePath;
  final double aspectRatio;

  const DisplayPictureScreen({Key key, this.imagePath, this.aspectRatio})
      : super(key: key);

  @override
  _DisplayPictureScreenState createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  final int max_dots = 4;
  List<Dots> dots = [];
  bool isLoading = false;
  String shirtSize = '';
  String chestSize = '';


    // user defined function
  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Center(child: new Text("Could not process image.")),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final statusbarHeight = MediaQuery.of(context).padding.top;
    _goBack() {
      Navigator.pop(context);
    }

    _addDots(details) {
      // check number of dots
      print("ADD DOTSZ");
      if (dots.length < max_dots) {
        Dots new_dot = new Dots(
            dy: details.globalPosition.dy, dx: details.globalPosition.dx);
        setState(() {
          dots.add(new_dot);
        });
        print(details.globalPosition.dx);
        print(dots);
      }
    }

    _sendImage(imgPath) async {
      var uri = Uri.parse("https://b02956b4.ngrok.io/images");

      var request = new http.MultipartRequest("POST", uri)
        ..files.add(await http.MultipartFile.fromPath('image', imgPath));

      var response = await request.send();
      print(response.statusCode);
      response.stream.bytesToString().then((value) {
        var res_json = json.decode(value);
        setState(() {
          if (response.statusCode != 500){
            shirtSize = res_json['size_name'];
            chestSize = "Chest : "+res_json['chest_length']+" inch";
          }
          else {
            _showDialog();
          }
        });
        print(value);
      });
    }


    return Scaffold(
        // The image is stored as a file on the device. Use the `Image.file`
        // constructor with the given path to display the image.
        body: Container(
      height: double.infinity,
      color: Colors.black,
      child: Stack(alignment: FractionalOffset.topCenter, children: [
        Padding(
          padding: EdgeInsets.only(top: statusbarHeight),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: AspectRatio(
              aspectRatio: widget.aspectRatio,
              child: Image.file(File(widget.imagePath)),
            ),
          ),
        ),
        Align(
          alignment: FractionalOffset.center,
          heightFactor: 1.9,
          child: Container(
            width: size.width,
            height: size.width,
            child: Stack(alignment: Alignment.center, children: [
              Opacity(
                opacity: 0.5,
                child: new Image.asset(
                  isLoading ? 'shirt.png' : 'shirt_white.png',
                  fit: BoxFit.contain,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
              Text(
                shirtSize,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 80,
                    fontWeight: FontWeight.w500),
              ),
              Text(
                chestSize,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 40,
                    fontWeight: FontWeight.w500),
              ),
            ]),
          ),
        ),
        Positioned(
          child: IconButton(
              icon: Icon(Icons.clear),
              color: Colors.white,
              iconSize: 30,
              onPressed: () {
                _goBack();
              }),
          top: 60,
          left: 15,
        ),
        Align(
          alignment: FractionalOffset.bottomCenter,
          heightFactor: 16,
          child: RaisedButton(
            onPressed: () {
              _sendImage(widget.imagePath);
            },
            child: Text("Send Image!"),
          ),
        )
      ]),
    ));
  }
}
