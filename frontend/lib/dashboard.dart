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
            padding: EdgeInsets.only(left:5),
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
                  Text("MY MEASUREMENT", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12),),
                  SizedBox(height: 20,),
                  Text("Chest: 20 inch"), 
                  SizedBox(height: 5,),
                  Text("Neck: 3 inch")],
              ),
            ),
          )
        ],
      ),
    );
  }
}
