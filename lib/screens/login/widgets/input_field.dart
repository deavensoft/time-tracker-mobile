import "package:flutter/material.dart";

class InputField extends StatelessWidget {
  String labelText;
  TextEditingController controller;
  bool obscure = false;

  InputField({this.labelText, this.controller, this.obscure = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextFormField(
          validator: (value) {
            if (value.isEmpty) return "Field must not be empty";
            return null;
          },
          style: Theme.of(context).primaryTextTheme.headline4,
          controller: controller,
          obscureText: this.obscure,
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: Theme.of(context).primaryTextTheme.headline4,
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white)),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
          )),
    );
  }
}
