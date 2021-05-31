import "package:flutter/material.dart";
import 'package:intl/intl.dart';

class DateFilter extends StatelessWidget {
  final String labelText;
  final DateTime date;
  final Function setDate;

  DateFilter({this.labelText, this.date, this.setDate});

  @override
  Container build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      color: Theme.of(context).primaryColor,
      child: Row(
        children: [
          Text(labelText,
              textAlign: TextAlign.center,
              style: Theme.of(context).accentTextTheme.bodyText2),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            decoration: BoxDecoration(
                color: Theme.of(context).accentColor,
                borderRadius: BorderRadius.circular(10)),
            child: makeDateRow(context),
          )
        ],
      ),
    );
  }

  selectDate(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(1970),
      lastDate: DateTime.now(),
    ).then((value) {
      if (value == null) return;
      setDate(value);
    });
  }

  Row makeDateRow(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => selectDate(context),
          child: Text(
            DateFormat("dd/MM/yyyy").format(date),
            style: Theme.of(context).accentTextTheme.bodyText1,
          ),
        ),
        Icon(
          Icons.calendar_today,
          size: 20,
        )
      ],
    );
  }
}
