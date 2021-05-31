// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

import 'package:time_tracker_mobile/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    http: //localhost:8080/auth/realms/time-tracker-cloak/protocol/openid-connect/token
    // http.AltHttpClient(context: )
    var token = await http.post(
        Uri.http("192.168.22.54:8080",
            "/auth/realms/time-tracker-cloak/protocol/openid-connect/token"),
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: jsonEncode({
          "client_id": "time-tracker",
          "username": "aca98",
          "password": "123",
          "grant_type": "password"
        }));

    print(token.statusCode);
    // Map<String, dynamic> decodedToken = JwtDecoder.decode(yourToken);
  });
}
