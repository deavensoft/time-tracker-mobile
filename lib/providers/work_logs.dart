import "package:flutter/material.dart";
import 'package:intl/intl.dart';
import 'package:time_tracker_mobile/main.dart';
import 'package:time_tracker_mobile/models/project.dart';
import 'package:time_tracker_mobile/models/work_log.dart';
import 'package:http/http.dart' as http;
import 'package:time_tracker_mobile/providers/users.dart';
import 'dart:convert';
import 'dart:io';

import '../constants.dart';

class WorkLogs with ChangeNotifier {
  String userId;
  DateTime from =
      DateTime.now().subtract(Duration(days: DateTime.now().day - 1));
  DateTime to = DateTime.now();
  Project project;
  List<WorkLog> workLogs = [];
  List<Project> _listProjects = [];

  void setFrom(DateTime date) {
    this.from = date;
    fetchWorkLogs();
    notifyListeners();
  }

  void setTo(DateTime date) {
    this.to = date;
    fetchWorkLogs();
    notifyListeners();
  }

  void setProject(Project project) {
    this.project = project;
    fetchWorkLogs();
    notifyListeners();
  }

  void setProjects(List<Project> projects) {
    _listProjects = projects;
  }

  Future<void> fetchWorkLogs() async {
    if (project == null) {
      await getAllWorkLogs();
    } else {
      await getWorkLogs();
    }
  }

  Future<void> getWorkLogs() async {
    try {
      String tFrom = DateFormat("yyyy-MM-dd").format(this.from);
      String tTo = DateFormat("yyyy-MM-dd").format(this.to);
      var token = await Users.getToken();
      if (token == "no-internet" || token == "error") {
        return;
      }

      var response = await http.get(
          Uri.http("${IP}:$PORT",
              "/v1.0/worklogs/${this.project.id}/$userId/$tFrom/$tTo"),
          headers: {"Authorization": "bearer $token"});
      var extractedData = json.decode(response.body);
      print("Extracted ${extractedData}");
      List<WorkLog> list = [];
      extractedData.forEach((worklog) {
        list.add(
          WorkLog(
            id: worklog["id"],
            topic: worklog["topic"],
            description: worklog["description"],
            hours: worklog["hours"],
            date: DateFormat("yyyy-MM-dd").parse(worklog["date"]),
            userId: worklog["user_id"],
            project: _listProjects
                .where((element) => element.id == worklog["project_id"])
                .first,
          ),
        );
      });
      this.workLogs = list;
      notifyListeners();
    } on SocketException catch (e) {
      ScaffoldMessenger.of(navigatorKey.currentContext).showSnackBar(
        SnackBar(
          content: Text("${e.message}, ${e.osError.message} "),
        ),
      );
    } on Exception catch (e) {
      ScaffoldMessenger.of(navigatorKey.currentContext).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  Future<void> getAllWorkLogs() async {
    try {
      String tFrom = DateFormat("yyyy-MM-dd").format(this.from);
      String tTo = DateFormat("yyyy-MM-dd").format(this.to);
      var token = await Users.getToken();
      if (token == "no-internet" || token == "error") {
        return;
      }

      var response = await http.get(
          Uri.http("$IP:$PORT", "/v1.0/worklogs/user/$userId/$tFrom/$tTo"),
          headers: {"Authorization": "bearer $token"});
      var extractedData = json.decode(response.body);
      List<WorkLog> list = [];
      if (_listProjects.isEmpty) return;
      extractedData.forEach((worklog) {
        list.add(
          WorkLog(
            id: worklog["id"],
            topic: worklog["topic"],
            description: worklog["description"],
            hours: worklog["hours"],
            date: DateFormat("yyyy-MM-dd").parse(worklog["date"]),
            userId: worklog["user_id"],
            project: _listProjects
                .where((element) => element.id == worklog["project_id"])
                .first,
          ),
        );
      });
      this.workLogs = list;
      notifyListeners();
    } on SocketException catch (e) {
      ScaffoldMessenger.of(navigatorKey.currentContext).showSnackBar(
        SnackBar(
          content: Text("${e.message}, ${e.osError.message} "),
        ),
      );
    } on Exception catch (e) {
      ScaffoldMessenger.of(navigatorKey.currentContext).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
    }
  }

  Future<String> addWorkLog(WorkLog worklog) async {
    try {
      var token = await Users.getToken();
      if (token == "no-internet" || token == "error") {
        return token;
      }
      worklog.userId = int.parse(userId);
      var response = await http.post(Uri.http("$IP:$PORT", "/v1.0/worklogs"),
          body: json.encode(worklog.toMap()),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "bearer $token"
          });
      var extractedData = json.decode(response.body);
      workLogs.add(
        WorkLog(
            id: extractedData["id"],
            userId: extractedData["user_id"],
            project: _listProjects
                .where((element) => element.id == extractedData["project_id"])
                .first,
            topic: extractedData["topic"],
            date: DateFormat("yyyy-MM-dd").parse(
              extractedData["date"],
            ),
            hours: extractedData["hours"],
            description: extractedData["description"]),
      );
      return null;
    } on SocketException catch (e) {
      ScaffoldMessenger.of(navigatorKey.currentContext).showSnackBar(
        SnackBar(
          content: Text("${e.message}, ${e.osError.message} "),
        ),
      );
      return "${e.message}, ${e.osError.message} ";
    } on Exception catch (e) {
      ScaffoldMessenger.of(navigatorKey.currentContext).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
      return e.toString();
    }
  }

  Future<String> editWorkLog(WorkLog worklog) async {
    try {
      var token = await Users.getToken();
      if (token == "no-internet" || token == "error") {
        return token;
      }
      await http.put(Uri.http("$IP:$PORT", "/v1.0/worklogs/${worklog.id}"),
          body: json.encode(worklog.toMap()),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "bearer $token"
          });
      notifyListeners();
      return null;
    } on SocketException catch (e) {
      ScaffoldMessenger.of(navigatorKey.currentContext).showSnackBar(
        SnackBar(
          content: Text("${e.message}, ${e.osError.message} "),
        ),
      );
      return "${e.message}, ${e.osError.message} ";
    } on Exception catch (e) {
      ScaffoldMessenger.of(navigatorKey.currentContext).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
      return e.toString();
    }
  }

  Future<String> deleteWorkLog(int id) async {
    try {
      var token = await Users.getToken();
      if (token == "no-internet" || token == "error") {
        return token;
      }
      await http.delete(Uri.http("$IP:$PORT", "/v1.0/worklogs/$id"), headers: {
        "Content-Type": "application/json",
        "Authorization": "bearer $token"
      });

      workLogs.removeWhere((element) => element.id == id);
      notifyListeners();
      return null;
    } on SocketException catch (e) {
      ScaffoldMessenger.of(navigatorKey.currentContext).showSnackBar(
        SnackBar(
          content: Text("${e.message}, ${e.osError.message} "),
        ),
      );
      return "${e.message}, ${e.osError.message} ";
    } on Exception catch (e) {
      ScaffoldMessenger.of(navigatorKey.currentContext).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
      return e.toString();
    }
  }
}
