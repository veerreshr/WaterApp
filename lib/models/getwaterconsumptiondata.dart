import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import './waterconsumption.dart';
import 'package:intl/intl.dart';

class GetWaterConsumptionData extends ChangeNotifier {
  List<WaterConsumption> last30days;
  List<WaterConsumption> last7days;
  String today;
  int todaysQuantity;
  File jsonFile;
  Directory dir;
  String fileName = "quantity";
  bool fileExists = false;
  Map<String, dynamic> fileContent;
  Future<void> initializeData() async {
    await getApplicationDocumentsDirectory().then((Directory directory) async {
      dir = directory;
      jsonFile = new File(dir.path + "/" + fileName);
      fileExists = await jsonFile.exists();
      if (fileExists) {
        String cont = await jsonFile.readAsString();
        if (cont.isNotEmpty) {
          fileContent = json.decode(cont);
        } else {
          fileContent = {};
        }
      } else {
        File file = new File(dir.path + "/" + fileName);
        await file.create();
        fileExists = true;
        fileContent = {};
      }
    });
    today = new DateFormat.yMd().format(DateTime.now()).toString();
    if (fileContent?.isEmpty ?? true) {
      todaysQuantity = 0;
    } else if (fileContent[today] == null) {
      todaysQuantity = 0;
    } else {
      todaysQuantity = int.parse(fileContent[today]);
    }

    updateData();
  }

  String dayDifference(int diff) {
    DateTime now = new DateTime.now().subtract(new Duration(days: diff));
    return new DateFormat.yMd().format(now).toString();
  }

  void updateData() {
    last30days = [];
    last7days = [];
    for (int i = 0; i < 30; i++) {
      String date = dayDifference(i);
      int quantity;
      if (fileContent?.isEmpty ?? true) {
        quantity = 0;
      } else {
        quantity = fileContent[date] == null ? 0 : int.parse(fileContent[date]);
      }
      //try catch block
      last30days.add(WaterConsumption("$date", quantity));
    }
    for (int i = 0; i < 7; i++) {
      String date = dayDifference(i);
      int quantity;
      if (fileContent?.isEmpty ?? true) {
        quantity = 0;
      } else {
        quantity = fileContent[date] == null ? 0 : int.parse(fileContent[date]);
      }
      last7days.add(WaterConsumption("$date", quantity));
    }
    notifyListeners();
  }

  Future<void> addData(Map<String, dynamic> content) async {
    if (fileExists) {
      fileContent.addAll(content);
      await jsonFile.writeAsString(json.encode(fileContent));
    } else {
      await jsonFile.writeAsString(json.encode(content));
      fileContent = content;
    }
  }

  void addWaterConsumption(int quantity) async {
    todaysQuantity =
        (fileContent[today] == null ? 0 : int.parse(fileContent[today]));
    todaysQuantity += quantity;
    fileContent[today] = todaysQuantity;
    await addData({"$today": "$todaysQuantity"});
    updateData();
  }
}
