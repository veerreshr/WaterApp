import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:Water/widgets/drink.dart';
import 'package:Water/widgets/remainder.dart';
import 'package:Water/widgets/stats.dart';

import '../widgets/settings.dart';

class Water extends StatefulWidget {
  @override
  _WaterState createState() => _WaterState();
}

class _WaterState extends State<Water> {
  int selectedScreen;
  @override
  void initState() {
    super.initState();
    selectedScreen = 0;
  }

  Widget getScreenContent(int index) {
    switch (index) {
      case 0:
        return Drink();
      case 1:
        return Stats();
      case 2:
        return Remainder();
      case 3:
        return Settings();

        break;
      default:
        return Text("Something went wrong");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Water App"),
        backgroundColor: Color(0xFF4A8C98),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        height: 50,
        color: Color(0xFF3D3E40),
        buttonBackgroundColor: Color(0xFF3D3E40),
        backgroundColor: Color(0xFFACCBCD),
        items: <Widget>[
          Icon(Icons.home, size: 30, color: Color(0xFFACCBCD)),
          Icon(Icons.show_chart, size: 30, color: Color(0xFFACCBCD)),
          Icon(Icons.alarm, size: 30, color: Color(0xFFACCBCD)),
          Icon(Icons.settings, size: 30, color: Color(0xFFACCBCD)),
        ],
        onTap: (index) {
          setState(() {
            selectedScreen = index;
          });
        },
      ),
      body: getScreenContent(selectedScreen),
    );
  }
}
