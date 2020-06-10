import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class UserData extends ChangeNotifier {
  File jsonFile;
  Directory dir;
  String fileName = "userdata";
  bool fileExists = false;
  Map<String, dynamic> fileContent;
  int currentQuantity;
  List<int> quantities;
  double weight;
  int ageCategory;
  double millilitre;

  Future initializeData() async {
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
    currentQuantity = fileContent["currentQuantity"];
    quantities = [
      fileContent["quantity1"],
      fileContent["quantity2"],
      fileContent["quantity3"],
      fileContent["quantity4"],
      fileContent["quantity5"],
      fileContent["quantity6"],
    ];
    weight = fileContent["weight"];
    ageCategory = fileContent["ageCategory"];
    millilitre = fileContent["millilitre"];
    notifyListeners();
  }

  updateValues() {
    currentQuantity = fileContent["currentQuantity"];
    quantities = [
      fileContent["quantity1"],
      fileContent["quantity2"],
      fileContent["quantity3"],
      fileContent["quantity4"],
      fileContent["quantity5"],
      fileContent["quantity6"],
    ];
    weight = fileContent["weight"];
    ageCategory = fileContent["ageCategory"];
    millilitre = fileContent["millilitre"];
    notifyListeners();
  }

  addUserData(double weight, int category) async {
    double dp(double val, int places) {
      double mod = pow(10.0, places);
      return ((val * mod).round().toDouble() / mod);
    }

    fileContent["weight"] = weight;
    fileContent["ageCategory"] = category;
    double intermediate;

    double liters;
    if (category == 1) {
      intermediate = ((2.20462 * weight) / 2.2) * 40;
    } else if (category == 2) {
      intermediate = ((2.20462 * weight) / 2.2) * 35;
    } else {
      intermediate = ((2.20462 * weight) / 2.2) * 30;
    }

    liters = intermediate / (28.3 * 33.8);
    liters = dp(liters, 2);
    millilitre = liters * 1000;
    fileContent["millilitre"] = millilitre;
    await jsonFile.writeAsString(json.encode(fileContent));

    updateValues();
  }

  Future<SnackBar> addQuantityData(int quantity) async {
    bool added = false;
    for (int i = 1; i <= 6; i++) {
      if (fileContent["quantity$i"] == quantity) {
        return SnackBar(
          content: const Text("Duplicates not allowed"),
          backgroundColor: Colors.redAccent,
          duration: const Duration(seconds: 2),
        );
      }
    }
    for (int i = 1; i <= 6; i++) {
      if (fileContent["quantity$i"] == null) {
        fileContent["quantity$i"] = quantity;
        added = true;
        break;
      }
    }
    if (!added) {
      return SnackBar(
        content: const Text("You can add only 6 options"),
        backgroundColor: Colors.redAccent,
        duration: const Duration(seconds: 2),
      );
    } else {
      await jsonFile.writeAsString(json.encode(fileContent));
      updateValues();
      return SnackBar(
        content: const Text("New option added"),
        duration: const Duration(seconds: 2),
      );
    }
  }

  Future changeCurrentQuantity(int current) async {
    fileContent["currentQuantity"] = current;
    await jsonFile.writeAsString(json.encode(fileContent));
    updateValues();
  }

  Future deleteQuantity(int value, bool isCurrentQuantity) async {
    for (int i = 1; i <= 6; i++) {
      if (fileContent["quantity$i"] == value) {
        fileContent["quantity$i"] = null;
        fileContent["currentQuantity"] =
            isCurrentQuantity ? null : currentQuantity;
        await jsonFile.writeAsString(json.encode(fileContent));
        updateValues();
        break;
      }
    }
  }
}
