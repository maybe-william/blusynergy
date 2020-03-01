import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:async';

import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'display_picture.dart';

class PicturePage extends StatefulWidget {
  final CameraDescription camera;
  final Function onSave;
  PicturePage({this.camera,this.onSave});
  @override
  _PicturePageState createState() => _PicturePageState();
}

class _PicturePageState extends State<PicturePage> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.high,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  _goBack() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        height: double.infinity,
        child: FutureBuilder(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // If the Future is complete, display the preview.
                final size = MediaQuery.of(context).size;
                final deviceRatio = size.width / size.height;
                final statusbarHeight = MediaQuery.of(context).padding.top;
                return Stack(alignment: FractionalOffset.topCenter, children: [
                  Padding(
                    padding: EdgeInsets.only(top: statusbarHeight),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: CameraPreview(_controller),
                      ),
                    ),
                  ),
                  Align(
                    alignment: FractionalOffset.center,
                    heightFactor: 1.9,
                    child: Container(
                      width: size.width,
                      height: size.width,
                      child: new Opacity(
                        opacity: 0.5,
                        child: new Image.asset(
                          'shirt.png',
                          fit: BoxFit.contain,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    child: IconButton(
                        icon: BackButtonIcon(),
                        color: Colors.white,
                        onPressed: () {
                          _goBack();
                        }),
                    top: 60,
                    left: 15,
                  )
                ]);
              } else {
                // Otherwise, display a loading indicator.
                return Center(child: CircularProgressIndicator());
              }
            }),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Align(
        alignment: FractionalOffset.center,
        heightFactor: 3,
              child: Container(
          width: 100,
          height: 100,
          child: FloatingActionButton(
            heroTag: 'Camera',
            backgroundColor: Color.fromARGB(150, 255, 255, 255),
            child: Icon(
              Icons.camera_alt,
              size: 40,
            ),
            // Provide an onPressed callback.
            onPressed: () async {
              // Take the Picture in a try / catch block. If anything goes wrong,
              // catch the error.
              try {
                // Ensure that the camera is initialized.
                await _initializeControllerFuture;

                // Construct the path where the image should be saved using the
                // pattern package.
                final path = join(
                  // Store the picture in the temp directory.
                  // Find the temp directory using the `path_provider` plugin.
                  (await getTemporaryDirectory()).path,
                  '${DateTime.now()}.png',
                );

                // Attempt to take a picture and log where it's been saved.
                await _controller.takePicture(path);
                widget.onSave(path);

                // If the picture was taken, display it on a new screen.
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DisplayPictureScreen(imagePath: path, aspectRatio: _controller.value.aspectRatio),
                  ),
                );
              } catch (e) {
                // If an error occurs, log the error to the console.
                print(e);
              }
            },
          ),
        ),
      ),
    );
  }
}
