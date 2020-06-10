import 'package:Water/models/userdata.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  TextEditingController quantity = new TextEditingController();

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
}
