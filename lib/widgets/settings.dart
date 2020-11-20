import 'package:Water/models/userdata.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/animated_focus_light.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  TextEditingController quantity = new TextEditingController();
  UserData newUserData = new UserData();
  TutorialCoachMark tutorialCoachMark;
  List<TargetFocus> targets = List();

  GlobalKey keyButton1 = GlobalKey();
  GlobalKey keyButton2 = GlobalKey();
  GlobalKey keyButton3 = GlobalKey();
  @override
  initState() {
    initTargets();
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserData data = Provider.of<UserData>(context);
    data.initializeData();

    int ageIndex = data.ageCategory == null ? null : data.ageCategory - 1;
    double weight = data.weight;
    List<int> quantities = data.quantities == null
        ? null
        : data.quantities.where((element) => element != null).toList();
    int currentQuantity = data.currentQuantity;

    List ageCategories = const ["less than 30", "30-55", "more than 55"];
    Widget chip(int ml, bool selected) {
      return InputChip(
        label: Text("$ml ml"),
        onSelected: (select) {
          data.changeCurrentQuantity(ml);
        },
        onDeleted: () {
          if (currentQuantity == ml) {
            data.deleteQuantity(ml, true);
          } else {
            data.deleteQuantity(ml, false);
          }
        },
        backgroundColor: selected ? Colors.green : Colors.yellow[100],
      );
    }

    createchips() {
      return quantities == null
          ? null
          : quantities.map((e) => chip(e, e == currentQuantity)).toList();
    }

    return Container(
      color: Color(0xFFACCBCD),
      child: ListView(
        padding: EdgeInsets.all(10),
        children: <Widget>[
          Card(
            key: keyButton1,
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, right: 10.0, top: 8.0, bottom: 20.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      const Text('Your Weight : ',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(weight == null ? "no record found" : "$weight kgs"),
                      Spacer(),
                      RaisedButton.icon(
                        onPressed: () {
                          _showModalBottom(context).then((value) {
                            data.addUserData(value[0], value[1]);
                          });
                        },
                        icon: Icon(
                          Icons.edit,
                          size: 20,
                        ),
                        label: Text("Edit"),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      const Text('Your Age category : ',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(ageIndex == null
                          ? "no record found"
                          : "${ageCategories[ageIndex]}"),
                    ],
                  )
                ],
              ),
            ),
          ),
          Card(
            key: keyButton2,
            elevation: 5,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: quantity,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Add quantity in ml",
                    ),
                    maxLength: 5,
                  ),
                  RaisedButton.icon(
                    onPressed: () {
                      if (quantity.text.trim().isNotEmpty) {
                        data.addQuantityData(int.parse(quantity.text)).then(
                            (value) =>
                                Scaffold.of(context).showSnackBar(value));
                        setState(() {
                          quantity.text = "";
                        });
                      }
                    },
                    icon: Icon(Icons.add),
                    label: const Text("Add New Quantity"),
                  ),
                ],
              ),
            ),
          ),
          Card(
            key: keyButton3,
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    "Select the cup quantity",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Wrap(
                    runSpacing: 10.0,
                    spacing: 10.0,
                    children: quantities == null
                        ? [
                            const Text("Add new quantity"),
                          ]
                        : createchips(),
                  ),
                ],
              ),
            ),
          ),
          RaisedButton(
              onPressed: () {
                showAboutDialog(
                  context: context,
                  applicationVersion: '1.0.0',
                );
              },
              elevation: 5,
              color: Colors.white,
              child: Text("More info"))
        ],
      ),
    );
  }

  Future<List> _showModalBottom(BuildContext ctx) async {
    TextEditingController weight = new TextEditingController();
    int group = 1;
    return showModalBottomSheet(
      context: ctx,
      builder: (ctx) {
        return StatefulBuilder(
            builder: (BuildContext ctx, StateSetter setModalsState) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: weight,
                  keyboardType: TextInputType.numberWithOptions(
                    decimal: true,
                    signed: false,
                  ),
                  decoration: InputDecoration(
                    labelText: "Weight in kgs",
                  ),
                ),
                SizedBox(height: 10),
                const Text(
                  "Age Category :",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                RadioListTile(
                  title: const Text("less than 30"),
                  value: 1,
                  groupValue: group,
                  onChanged: (val) {
                    setModalsState(() {
                      group = val;
                    });
                  },
                ),
                RadioListTile(
                  title: const Text("30-55"),
                  value: 2,
                  groupValue: group,
                  onChanged: (val) {
                    setModalsState(() {
                      group = val;
                    });
                  },
                ),
                RadioListTile(
                  title: const Text("more than 55"),
                  value: 3,
                  groupValue: group,
                  onChanged: (val) {
                    setModalsState(() {
                      group = val;
                    });
                  },
                ),
                Row(
                  children: <Widget>[
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                        onPressed: () {
                          if (weight.text.trim().isNotEmpty) {
                            Navigator.of(ctx)
                                .pop([double.parse(weight.text), group]);
                          }
                        },
                        child: const Text("Save"),
                        color: Colors.lightBlueAccent,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
      },
    );
  }

  void initTargets() {
    targets.add(
      TargetFocus(
        identify: "Target 0",
        keyTarget: keyButton1,
        shape: ShapeLightFocus.RRect,
        contents: [
          ContentTarget(
              align: AlignContent.bottom,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "1. Edit Your Details",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "Add your weight and age category so we can personalize the water quantity per day. This will reflect the total water quantity you should consume per day",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ))
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "Target 1",
        keyTarget: keyButton2,
        shape: ShapeLightFocus.RRect,
        contents: [
          ContentTarget(
              align: AlignContent.bottom,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "2. Add New Cup Quantity",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "This is quantity of cup that you would use to drink , A max of 6 cups can be used to drink water",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ))
        ],
      ),
    );
    targets.add(
      TargetFocus(
        identify: "Target 2",
        keyTarget: keyButton3,
        shape: ShapeLightFocus.RRect,
        contents: [
          ContentTarget(
              align: AlignContent.top,
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "3 .Select Cup",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(
                        "Selecting cup reflects the cup quantity in home page , that you would use to drink water at a time.",
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

  void showTutorial() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var intro = preferences.getBool('settingsintro') ?? false;
    if (!intro) {
      tutorialCoachMark = TutorialCoachMark(context,
          targets: targets,
          colorShadow: Colors.red,
          textSkip: "SKIP",
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
    await preferences.setBool('settingsintro', true);
  }

  void _afterLayout(_) {
    Future.delayed(Duration(milliseconds: 100), () {
      showTutorial();
    });
  }
}
