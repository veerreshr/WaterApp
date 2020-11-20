import 'package:Water/models/userdata.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:Water/widgets/drink.dart';
import 'package:Water/widgets/remainder.dart';
import 'package:Water/widgets/stats.dart';
import '../widgets/settings.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class Water extends StatefulWidget {
  @override
  _WaterState createState() => _WaterState();
}

class _WaterState extends State<Water> {
  int selectedScreen;
  TutorialCoachMark tutorialCoachMark;
  List<TargetFocus> targets = List();
  UserData newUserData = new UserData();
  GlobalKey keyButton = GlobalKey();
  @override
  initState() {
    selectedScreen = 0;
    initTargets();
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    super.initState();
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
          Container(
            child: Icon(
              Icons.home,
              size: 30,
              color: Color(0xFFACCBCD),
            ),
          ),
          Container(
            child: Icon(
              Icons.show_chart,
              size: 30,
              color: Color(0xFFACCBCD),
            ),
          ),
          Container(
            child: Icon(
              Icons.alarm,
              size: 30,
              color: Color(0xFFACCBCD),
            ),
          ),
          Container(
            child: Icon(Icons.settings,
                size: 30, color: Color(0xFFACCBCD), key: keyButton),
          ),
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

  void initTargets() {
    targets.add(
      TargetFocus(
        identify: "Target 0",
        keyTarget: keyButton,
        contents: [
          ContentTarget(
              align: AlignContent.top,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Click to setup",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "Add your weight and age category so we can personalize the water quantity per day. Also select the cup quantity",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }

  void showTutorial() {
    bool isValid = newUserData.body_weight > 0 ? false : true;
    if (isValid) {
      tutorialCoachMark = TutorialCoachMark(context,
          targets: targets,
          colorShadow: Colors.red,
          textSkip: "",
          paddingFocus: 10,
          opacityShadow: 0.8, onFinish: () {
        print("finish");
      }, onClickTarget: (target) {
        print(target);
      }, onClickSkip: () {
        print("skip");
      })
        ..show();
    }
  }

  void _afterLayout(_) {
    Future.delayed(Duration(milliseconds: 100), () {
      showTutorial();
    });
  }
}
