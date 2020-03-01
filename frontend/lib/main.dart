import 'package:flutter/material.dart';
import 'picture_page.dart';
import 'package:camera/camera.dart';
import 'dashboard.dart';
import 'gallery.dart';

void main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
// can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

// Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();
  print(cameras);
// Get a specific camera from the list of available cameras.
  final firstCamera = cameras.first;
  runApp(MyApp(camera: firstCamera));
}

class MyApp extends StatelessWidget {
  final CameraDescription camera;

  MyApp({this.camera});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: HomePage(camera: camera),
    );
  }
}

class HomePage extends StatefulWidget {
  final CameraDescription camera;

  HomePage({this.camera});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List photoGallery = [];
  int selectedTab = 0;

  _savePhoto(imgPath) {
    setState(() {
      photoGallery.add(imgPath);
    });
  }

  _handlePicture(camera) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                PicturePage(camera: camera, onSave: _savePhoto)));
  }

  _genBody(tabIndex) {
    switch (tabIndex) {
      case 0:
        return Dashboard();
      case 1:
        return Gallery(photoGallery: photoGallery);
      default:
        return Dashboard();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(title: Text('BluSynergy')),
      body: _genBody(selectedTab),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: new FloatingActionButton(
        heroTag: 'Camera',
        child: Icon(Icons.camera_alt),
        onPressed: () => {_handlePicture(widget.camera)},
      ),
      bottomNavigationBar: new BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Padding(
          padding: const EdgeInsets.only(top:10.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              GestureDetector(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(Icons.dashboard),
                    Text("Dashboard"),
                  ],
                ),
                onTap: () {
                  setState(() {
                    selectedTab = 0;
                  });
                },
              ),
              SizedBox(),
              GestureDetector(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(Icons.photo),
                    Text("Gallery")
                  ],
                ),
                onTap: () {
                  setState(() {
                    selectedTab = 1;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
