import 'package:Water/models/getwaterconsumptiondata.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:provider/provider.dart';
import '../models/waterconsumption.dart';

class Stats extends StatefulWidget {
  @override
  _StatsState createState() => _StatsState();
}

class _StatsState extends State<Stats> {
  bool switchvalue = false;
  List<WaterConsumption> last30days = [];
  List<WaterConsumption> last7days = [];
  @override
  Widget build(BuildContext context) {
    GetWaterConsumptionData data =
        Provider.of<GetWaterConsumptionData>(context);
    data.initializeData();
    last30days = data.last30days;
    last7days = data.last7days;

    List<charts.Series> seriesList;
    List<charts.Series<WaterConsumption, String>> _createRandomData() {
      final listofconsumption = switchvalue ? last30days : last7days;
      return [
        charts.Series<WaterConsumption, String>(
            id: 'water',
            measureFn: (WaterConsumption water, _) => water.quantity,
            domainFn: (WaterConsumption water, _) => water.date,
            data: listofconsumption,
            colorFn: (_, __) =>
                charts.ColorUtil.fromDartColor(Color(0xFF000000)), //e1ab7c
            labelAccessorFn: (WaterConsumption water, _) =>
                ' ${water.date}:  ${water.quantity.toString()}ml')
      ];
    }

    barChart() {
      seriesList = _createRandomData();
      return charts.BarChart(
        seriesList,
        animationDuration: Duration(milliseconds: 800),
        animate: false,
        vertical: false,
        barRendererDecorator: new charts.BarLabelDecorator<String>(),
        domainAxis:
            new charts.OrdinalAxisSpec(renderSpec: new charts.NoneRenderSpec()),
      );
    }

    return Container(
      color: Color(0xFFACCBCD),
      child: Column(
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.only(top: 10, right: 10, bottom: 0, left: 0),
            child: Row(
              children: <Widget>[
                Spacer(),
                Text("Monthly",
                    style: TextStyle(
                      fontSize: 18,
                    )),
                Switch(
                  value: switchvalue,
                  onChanged: (value) {
                    setState(() {
                      switchvalue = value;
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 10, right: 10, bottom: 50, left: 10),
              child: Container(
                child: barChart(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
