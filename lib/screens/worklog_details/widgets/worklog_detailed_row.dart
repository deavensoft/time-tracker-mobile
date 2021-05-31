import "package:flutter/material.dart";

class WorkLogDetailedRow extends StatelessWidget {
  final String valueText;
  final String labelText;

  WorkLogDetailedRow({this.valueText, this.labelText});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          makeLabel(
            labelText: labelText,
            context: context,
          ),
          makeRow(labelText: valueText, context: context)
        ],
      ),
    );
  }

  Widget makeLabel({String labelText, BuildContext context}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
      width: double.infinity,
      child: Text(
        labelText,
        style: Theme.of(context).primaryTextTheme.headline3,
      ),
    );
  }

  Widget makeRow({String labelText, BuildContext context}) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(vertical: 5),
      width: double.infinity,
      decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.circular(10)),
      child: Text(
        labelText,
        textAlign: TextAlign.center,
        style: Theme.of(context).primaryTextTheme.headline4,
      ),
    );
  }
}
