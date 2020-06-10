import 'package:Water/models/getwaterconsumptiondata.dart';
import 'package:Water/models/userdata.dart';
import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:Water/widgets/textinwater.dart';
import 'package:provider/provider.dart';
import '../assets/quotes.dart';

class Drink extends StatefulWidget {
  @override
  _DrinkState createState() => _DrinkState();
}

class _DrinkState extends State<Drink> {
  Quotes q;
  @override
  void initState() {
    super.initState();
    q = new Quotes();
    q.randomindex();
  }

  @override
  Widget build(BuildContext context) {
    GetWaterConsumptionData daily =
        Provider.of<GetWaterConsumptionData>(context);
    daily.initializeData();
    UserData user = Provider.of<UserData>(context);
    user.initializeData();
    double calcratio() {
      if (user.millilitre == null || user.millilitre == 0.0) {
        return 0;
      } else {
        if (daily.todaysQuantity == null) {
          return 0;
        } else {
          return (daily.todaysQuantity / user.millilitre);
        }
      }
    }

    double ratio = calcratio();

    return Container(
      color: Color(0xFFACCBCD),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
                child: SizedBox(
                  width: 250,
                  height: 250,
                  child: LiquidCircularProgressIndicator(
                    value: ratio,
                    backgroundColor: Colors.white,
                    valueColor: AlwaysStoppedAnimation(Color(0xFF5195A0)),
                    center: TextInWater(ratio),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 100),
          SizedBox(
            width: 300,
            height: 50,
            child: RaisedButton(
              padding: const EdgeInsets.all(12.0),
              color: Color(0xFFfefeec),
              onPressed: () {
                if (user.currentQuantity != null) {
                  q.randomindex();
                  Provider.of<GetWaterConsumptionData>(context, listen: false)
                      .addWaterConsumption(user.currentQuantity);
                }
              },
              child: user.currentQuantity == null
                  ? Text("choose quantity from settings")
                  : Text(
                      "Drink ${user.currentQuantity} ml of water",
                      style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFF6E6B5F),
                          fontWeight: FontWeight.w400),
                    ),
            ),
          ),
          SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                q.randomquote,
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
