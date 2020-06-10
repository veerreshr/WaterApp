import 'package:Water/models/getwaterconsumptiondata.dart';
import 'package:Water/models/userdata.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TextInWater extends StatefulWidget {
  final double ratio;
  TextInWater(this.ratio);
  @override
  _TextInWaterState createState() => _TextInWaterState();
}

class _TextInWaterState extends State<TextInWater> {
  @override
  Widget build(BuildContext context) {
    String text;
    if (widget.ratio < 0.1) {
      text = "Your body highly needs water";
    } else if (widget.ratio < 0.3) {
      text = "Hydration is important";
    } else if (widget.ratio < 0.6) {
      text = "Your in half way";
    } else if (widget.ratio < 0.9) {
      text = "Going great!";
    } else if (widget.ratio < 1) {
      text = "Maintain this spirit";
    } else {
      text = "Your in a healthy path";
    }
    GetWaterConsumptionData daily =
        Provider.of<GetWaterConsumptionData>(context);
    UserData user = Provider.of<UserData>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          user.millilitre == null
              ? "--/--"
              : "${daily.todaysQuantity == null ? 0 : daily.todaysQuantity}/${user.millilitre == null ? 0 : user.millilitre.round()}",
          style: TextStyle(
            color: Color(0xFF182339),
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          text,
          style: TextStyle(
            color: Color(0xFFCED2DB),
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}
