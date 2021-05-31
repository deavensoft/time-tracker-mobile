import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_mobile/models/project.dart';
import 'package:time_tracker_mobile/providers/projects.dart';
import 'package:time_tracker_mobile/providers/users.dart';
import 'package:time_tracker_mobile/providers/work_logs.dart';
import 'package:time_tracker_mobile/material_app.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DateTime from;
  DateTime to;
  Project project;
  bool isInit = false;

  void setProject(Project selectedProject) {
    setState(() {
      project = selectedProject;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => Users(),
      child: MultiProvider(
        providers: [
          ChangeNotifierProxyProvider<Users, Projects>(
            create: (ctx) => Projects(),
            update: (context, users, project) {
              project.userId = users.userId;
              project.getProjects();
              return project;
            },
          ),
          ChangeNotifierProxyProvider2<Projects, Users, WorkLogs>(
            create: (context) {
              return WorkLogs();
            },
            update: (context, projects, users, previous) {
              previous.userId = users.userId;
              // projects.getProjects();
              previous.setProjects(projects.projects);
              return previous;
            },
          )
        ],
        child: MainApp(),
      ),
    );
  }
}
