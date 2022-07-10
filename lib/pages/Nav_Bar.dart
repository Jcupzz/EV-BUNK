import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:ev_bunk/pages/homePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Nav_Bar extends StatefulWidget {
  @override
  _Nav_BarState createState() => _Nav_BarState();
}

class _Nav_BarState extends State<Nav_Bar> {
  int _page = 0;
  final pageOption = [
    HomePage(),
    HomePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.grey.shade300,
        animationCurve: Curves.bounceInOut,
        animationDuration: Duration(milliseconds: 200),
        color: Colors.white,
        buttonBackgroundColor: Colors.white,
        height: 60,
        items: <Widget>[
          Icon(
            Icons.home,
            size: 20,
            color: Colors.black,
          ),
          // Icon(
          //   Icons.add_circle_rounded,
          //   size: 20,
          //   color: Colors.black,
          // ),
          // Icon(
          //   Icons.location_on_outlined,
          //   color: Colors.black,
          //   size: 20,
          // ),
          Icon(
            Icons.person,
            size: 20,
            color: Colors.black,
          ),
        ],
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
      ),
      body: pageOption[_page],
    );
  }
}
