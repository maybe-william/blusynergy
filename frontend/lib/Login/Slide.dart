import 'package:flutter/material.dart';

class Slide {
  final String imageUrl;
  final String title;
  final String description;

  Slide({
    @required this.imageUrl,
    @required this.title,
    @required this.description,
  });
}

final slideList = [
  Slide(
    imageUrl: 'assets/page2.png',
    title: 'Take Picture of Yourself',
    description: '',
  ),
  Slide(
    imageUrl: 'assets/page1.png',
    title: 'We Analyze Your Photo',
    description: '',
  ),
  Slide(
    imageUrl: 'assets/page3.png',
    title: 'Get Your Measurement',
    description: '',
  ),
];