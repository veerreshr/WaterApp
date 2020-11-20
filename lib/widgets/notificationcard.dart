import "package:flutter/material.dart";

class notificationCard extends StatelessWidget {
  final String time;
  final int index;
  final Function removeNotification;

  notificationCard(this.time, this.removeNotification, this.index);
  Widget displaytime(String id) {
    int length = id.length;
    String value;
    if (length == 4) {
      value =
          "Remainder set at : ${id.substring(0, 2)} : ${id.substring(2, 4)}";
    } else if (length == 3) {
      value =
          "Remainder set at : 0${id.substring(0, 1)} : ${id.substring(1, 3)}";
    }
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Text(value),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Card(
        child: Row(
          children: <Widget>[
            displaytime(time),
            Spacer(),
            FlatButton.icon(
                onPressed: () async {
                  await removeNotification(int.parse(time));
                  SnackBar mySnackBar = new SnackBar(
                    content: const Text("Remainder deleted"),
                    duration: const Duration(seconds: 2),
                    backgroundColor: Colors.redAccent,
                  );
                  Scaffold.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(mySnackBar);
                },
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                label: const Text(
                  "Delete",
                  style: TextStyle(
                    color: Colors.redAccent,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
