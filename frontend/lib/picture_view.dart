import 'package:flutter/material.dart';
import 'dart:io';

class PictureView extends StatefulWidget {
  final String imagePath;
  PictureView({this.imagePath});
  @override
  _PictureViewState createState() => _PictureViewState();
}

class _PictureViewState extends State<PictureView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text('BluSynergy'),
      ),
      body: Container(
        child: Image.file(File(widget.imagePath), fit: BoxFit.cover,),
      ),
    );
  }
}
