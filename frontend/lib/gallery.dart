import 'package:camera/new/camera.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'display_picture.dart';

class Gallery extends StatefulWidget {
  final List photoGallery;

  Gallery({this.photoGallery});

  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  CameraController _controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      child: GridView.builder(
          itemCount: widget.photoGallery.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 0, mainAxisSpacing: 0),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: ()async{
                var image = File(widget.photoGallery[index]);
                var decodedImage = await decodeImageFromList(image.readAsBytesSync());
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => DisplayPictureScreen(imagePath: widget.photoGallery[index],aspectRatio: decodedImage.width/decodedImage.height,),
                  ));
              },
              child: new Card(
                child: Image.file(
                  File(widget.photoGallery[index]),
                  fit: BoxFit.cover,
                ),
              ),
            );
          }),
    );
  }
}
