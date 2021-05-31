import 'dart:io';
import "package:flutter/material.dart";
import 'package:time_tracker_mobile/constants.dart';
import 'package:time_tracker_mobile/main.dart';
import 'package:time_tracker_mobile/models/project.dart';
import "package:http/http.dart" as http;
import "dart:convert";
import 'package:time_tracker_mobile/providers/users.dart';

class Projects with ChangeNotifier {
  List<Project> projects = [];
  String userId;

  Future<void> getProjects() async {
    try {
      var token = await Users.getToken();

      var response = await http.get(
          Uri.parse("http://$IP:$PORT/v1.0/projects/user/4"),
          headers: {"Authorization": "bearer $token"});
      var extractedData = json.decode(response.body);
      List<Project> temp = [];
      extractedData.forEach((element) {
        temp.add(Project(
            id: element["id"],
            name: element["name"],
            description: element["description"]));
      });
      projects = temp;
      notifyListeners();
    } on SocketException catch (e) {
      ScaffoldMessenger.of(navigatorKey.currentContext).showSnackBar(
          SnackBar(content: Text("${e.message}, ${e.osError.message} ")));
    } on Exception catch (e) {
      ScaffoldMessenger.of(navigatorKey.currentContext)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
}
