import "package:flutter/material.dart";
import 'package:intl/intl.dart';

class PickDate extends StatelessWidget {
  DateTime date;
  Function handleDatePick;

  PickDate({this.date, this.handleDatePick});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).backgroundColor,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: () {
          showDatePicker(
                  context: context,
                  initialDate: date,
                  firstDate: DateTime(1970),
                  lastDate: DateTime.now())
              .then((value) {
            handleDatePick(value);
          });
        },
        child: Container(
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Date: ${DateFormat("yyyy/MM/dd").format(date)}",
                style: Theme.of(context).primaryTextTheme.headline4,
              ),
              Icon(
                (Icons.calendar_today),
                size: 20,
              )
            ],
          ),
        ),
      ),
    );
    ;
  }
}
