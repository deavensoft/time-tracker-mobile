import "package:flutter/material.dart";

class WorkLogField extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final TextInputType textInputType;

  WorkLogField(
      {this.labelText,
      this.controller,
      this.textInputType = TextInputType.text});

  @override
  Widget build(BuildContext context) {
    UnderlineInputBorder border = UnderlineInputBorder(
      borderSide:
          BorderSide(color: Theme.of(context).accentTextTheme.bodyText2.color),
    );
    Color textColor = Theme.of(context).accentTextTheme.bodyText2.color;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: TextFormField(
        validator: (value) {
          print(textInputType.toJson()["name"]);
          if (value.isEmpty) return "Text field must not be empty";
          if (textInputType.toJson()["name"] == "TextInputType.number" &&
              double.tryParse(value) == null) return "Must be a number";
          return null;
        },
        keyboardType: textInputType,
        style: TextStyle(color: textColor),
        decoration: InputDecoration(
            labelText: labelText,
            labelStyle: TextStyle(color: textColor),
            focusedBorder: border,
            enabledBorder: border),
        controller: controller,
      ),
    );
  }
}
