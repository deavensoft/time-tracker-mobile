import "package:flutter/material.dart";

class MenuOption extends StatelessWidget {
  EdgeInsets margin;
  EdgeInsets padding;
  String labelText;
  String routeName;
  Function handleTap;

  MenuOption(
      {this.labelText,
      this.margin,
      this.padding,
      this.routeName,
      this.handleTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: this.margin,
      child: Container(
        decoration: BoxDecoration(
            boxShadow: [BoxShadow(offset: Offset(1, 5), blurRadius: 5)]),
        child: Material(
          color: Theme.of(context).accentColor,
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: handleTap,
            child: Padding(
              padding: this.padding,
              child: Text(
                labelText,
                textAlign: TextAlign.center,
                style: Theme.of(context).primaryTextTheme.headline4,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
