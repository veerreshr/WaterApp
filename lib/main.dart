import 'package:Water/models/getwaterconsumptiondata.dart';
import 'package:Water/models/userdata.dart';

import 'package:flutter/material.dart';
import 'package:Water/screens/water.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: UserData()),
        ChangeNotifierProvider.value(value: GetWaterConsumptionData()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Water App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Water(),
      ),
    );
  }
}
