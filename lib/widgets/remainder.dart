import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import './notificationcard.dart';

class Remainder extends StatefulWidget {
  @override
  _RemainderState createState() => _RemainderState();
}

class _RemainderState extends State<Remainder> {
  File jsonFile;
  Directory dir;
  String fileName = "remainders.json";
  bool fileExists = false;
  Map<String, dynamic> fileContent;
  int numberoftimes = 14;
  TimeOfDay _time;
  TimeOfDay _picked;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    super.initState();
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = new IOSInitializationSettings();
    var initSetttings = new InitializationSettings(android, iOS);
    flutterLocalNotificationsPlugin.initialize(initSetttings,
        onSelectNotification: onSelectNotification);
    getApplicationDocumentsDirectory().then((Directory directory) {
      dir = directory;
      jsonFile = new File(dir.path + "/" + fileName);
      fileExists = jsonFile.existsSync();
      if (fileExists)
        setState(() {
          print(jsonFile.readAsStringSync() + "hello......................");
          if (jsonFile.readAsStringSync().isNotEmpty) {
            fileContent = json.decode(jsonFile.readAsStringSync());
          }
        });
      else
        print("file not exist");
    });
  }

  void createFile(
      Map<String, dynamic> content, Directory dir, String fileName) {
    print("Creating file!");
    File file = new File(dir.path + "/" + fileName);
    file.createSync();
    fileExists = true;
    file.writeAsStringSync(json.encode(content));
  }

  void writeToFile(String key, String value) {
    print("Writing to file!");
    Map<String, dynamic> content = {key: value};
    if (fileExists) {
      print("File exists");
      print(jsonFile.readAsStringSync());
      if (jsonFile.readAsStringSync().isNotEmpty) {
        Map<String, dynamic> jsonFileContent =
            json.decode(jsonFile.readAsStringSync());
        jsonFileContent.addAll(content);
        jsonFile.writeAsStringSync(json.encode(jsonFileContent));
      } else {
        jsonFile.writeAsStringSync(json.encode(content));
      }

      print(jsonFile.readAsStringSync());
    } else {
      print("File does not exist!");
      createFile(content, dir, fileName);
    }
    setState(() => fileContent = json.decode(jsonFile.readAsStringSync()));
    print(fileContent);
  }

  void _removeNotification(int id) async {
    print(id);
    await flutterLocalNotificationsPlugin.cancel(id);
    Map<String, dynamic> jsonFileContent =
        json.decode(jsonFile.readAsStringSync());
    jsonFileContent.removeWhere((key, value) => key == id.toString());
    jsonFile.writeAsStringSync(json.encode(jsonFileContent));
    setState(() {
      fileContent = json.decode(jsonFile.readAsStringSync());
    });
  }

  void _removeAllNotification() async {
    await flutterLocalNotificationsPlugin.cancelAll();
    setState(() {
      jsonFile.writeAsStringSync('');
      fileContent = null;
    });
  }

  Future onSelectNotification(String payload) {
    debugPrint("payload : $payload");
  }

  Future<String> setNotificationAuto() async {
    for (int i = 0; i < numberoftimes; i++) {
      Time time = Time(7 + i, 00, 00);
      int id = time.hour * 100 + time.minute;

      var android = new AndroidNotificationDetails(
          'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
          priority: Priority.High, importance: Importance.Max);
      var iOS = new IOSNotificationDetails();
      var platform = new NotificationDetails(android, iOS);
      await flutterLocalNotificationsPlugin.showDailyAtTime(
          id,
          'Water Remainder',
          'Drink water and hyderate your body',
          time,
          platform,
          payload: 'id');
      String value = "${time.toString()}:";
      writeToFile("$id", value);
    }
    return "Auto Remainders added";
  }

  setNotification(Time time) async {
    int id = time.hour * 100 + time.minute;
    var android = new AndroidNotificationDetails(
        'channel id', 'channel NAME', 'CHANNEL DESCRIPTION',
        priority: Priority.High, importance: Importance.Max);
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android, iOS);
    await flutterLocalNotificationsPlugin.showDailyAtTime(id, 'Water Remainder',
        'Drink water and hyderate your body', time, platform,
        payload: 'id');
    String value = "${time.toString()}:";
    writeToFile("$id", value);
  }

  Future<String> _startAddCustomRemainder(BuildContext ctx) async {
    return showModalBottomSheet(
      context: ctx,
      builder: (ctx) {
        return StatefulBuilder(
            builder: (BuildContext ctx, StateSetter setModalState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10),
                child: const Text(
                  "Pick the time you want to set Remainder",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    const Text("Remainder at : "),
                    _picked == null
                        ? const Text(
                            "No time selected!",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          )
                        : Text(_picked.format(context)),
                    Spacer(),
                    RaisedButton(
                      color: Color(0xFFACCBCD),
                      onPressed: () async {
                        _time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );

                        if (_picked == null || _picked != _time) {
                          setModalState(() {
                            _picked = _time;
                          });
                        }
                        print(_time.format(context));
                      },
                      child: const Text(
                        "Pick time",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  children: <Widget>[
                    Spacer(),
                    RaisedButton(
                      color: Color(0xFF4A8C98),
                      onPressed: () {
                        setNotification(Time(_picked.hour, _picked.minute, 00));
                        setModalState(() {
                          _picked = null;
                        });
                        Navigator.pop(ctx, "Added Custom Remainder");
                      },
                      child: const Text("Add Remainder"),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFACCBCD),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              color: Colors.white70,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              onPressed: () {
                setNotificationAuto().then((value) {
                  SnackBar mySnackBar = new SnackBar(
                    content: Text("$value"),
                    duration: const Duration(seconds: 2),
                  );
                  Scaffold.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(mySnackBar);
                });
              },
              child: const Text("Add default remainder timings"),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: fileContent == null ? 0 : fileContent.length,
              itemBuilder: (BuildContext context, int index) {
                String key = fileContent.keys.elementAt(index);
                return notificationCard(key, _removeNotification, index);
              },
            ),
          ),
          Row(
            children: <Widget>[
              Spacer(),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: FloatingActionButton(
                  onPressed: () async {
                    var value = await _startAddCustomRemainder(context);
                    if (value == null) {
                      SnackBar mySnackBar = new SnackBar(
                        content: Text(value),
                        duration: const Duration(seconds: 2),
                      );

                      Scaffold.of(context)
                        ..removeCurrentSnackBar()
                        ..showSnackBar(mySnackBar);
                    }
                  },
                  child: Icon(Icons.add),
                  tooltip: "Add custom remainders",
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
