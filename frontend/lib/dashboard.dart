import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 500,
            padding: EdgeInsets.all(10),
            child: Stack(
                children: [
                  Image.asset('avatar.png', fit: BoxFit.contain),
                  ]),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 50,),
                  Text("My Measurement", style: TextStyle(fontWeight: FontWeight.w800),),
                  Text("Chest: 30cm"), Text("Neck: 8cm")],
              ),
            ),
          )
        ],
      ),
    );
  }
}
