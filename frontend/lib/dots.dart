import 'package:flutter/material.dart';

class Dots extends StatefulWidget {
  final double dy;
  final double dx;

  Dots({this.dx, this.dy});

  @override
  _DotsState createState() => _DotsState(dy: this.dy, dx:this.dx);
}

class _DotsState extends State<Dots> {
  var dy;
  var dx;

  _DotsState({this.dx,this.dy});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: dy,
      left: dx,
      child: Draggable(
        onDragEnd: (details){
          print("derag");
          setState(() {
            dy = details.offset.dy;
            dx = details.offset.dx;
          });
        },
        feedback: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red),
        ),
        child: Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red),
        ),
        childWhenDragging: Container(),
      ),
    );
  }
}
