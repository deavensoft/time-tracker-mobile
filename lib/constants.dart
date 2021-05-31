import 'package:flutter/material.dart';

const IP = String.fromEnvironment("IP", defaultValue: "192.168.161.153");
const PORT = String.fromEnvironment("PORT", defaultValue: "9090");
const KEYCLOAK_PORT =
    String.fromEnvironment("KEYCLOAK_PORT", defaultValue: "8080");
const KEYCLOAK_REALM = String.fromEnvironment("KEYCLOAK_REALM",
    defaultValue: "time-tracker-cloak");
const KEYCLOAK_CLIENT =
    String.fromEnvironment("KEYCLOAK_CLIENT", defaultValue: "time-tracker");

var theme = ThemeData(
    textSelectionTheme: TextSelectionThemeData(
        cursorColor: Colors.white,
        selectionColor: Colors.white,
        selectionHandleColor: Color(0xFFF4AA53)),
    primarySwatch: MaterialColor(0xFF2A2D3E, {
      50: Color.fromRGBO(42, 45, 62, .1),
      100: Color.fromRGBO(42, 45, 62, .2),
      200: Color.fromRGBO(42, 45, 62, .3),
      300: Color.fromRGBO(42, 45, 62, .4),
      400: Color.fromRGBO(42, 45, 62, .5),
      500: Color.fromRGBO(42, 45, 62, .6),
      600: Color.fromRGBO(42, 45, 62, .7),
      700: Color.fromRGBO(42, 45, 62, .8),
      800: Color.fromRGBO(42, 45, 62, .9),
      900: Color.fromRGBO(42, 45, 62, 1),
    }),
    backgroundColor: Color.fromRGBO(33, 35, 50, 1),
    accentColor: Color(0XFF2A3752),
    accentTextTheme: TextTheme(
        bodyText1: TextStyle(color: Color(0xFF437FFC), fontSize: 16),
        bodyText2: TextStyle(color: Colors.white)),
    primaryTextTheme: TextTheme(
      headline1: TextStyle(color: Color(0xFFD4F453), fontSize: 15),
      headline2: TextStyle(color: Color(0xFF437FFC), fontSize: 15),
      headline3: TextStyle(color: Color(0xFFF4AA53), fontSize: 15),
      headline4: TextStyle(color: Colors.white, fontSize: 15),
      headline5: TextStyle(color: Colors.white, fontSize: 15),
      headline6: TextStyle(
        color: Color(0xFFF4AA53),
      ),
    ),
    cardColor: Color(0xFF40383A),
    textTheme: TextTheme(bodyText1: TextStyle(color: Color(0xFFD4F453))));
