import 'package:connectivity/connectivity.dart';
import "package:flutter/material.dart";
import 'package:time_tracker_mobile/screens/add_worklog/add_worklog_screen.dart';
import 'package:time_tracker_mobile/screens/login/login_screen.dart';
import 'package:time_tracker_mobile/screens/menu/menu_screen.dart';
import 'package:time_tracker_mobile/screens/project/project_screen.dart';
import 'package:time_tracker_mobile/screens/worklog_details/work_log_detail_screen.dart';
import 'package:time_tracker_mobile/screens/worklogs/work_log_screen.dart';
import 'package:time_tracker_mobile/widgets/login_switch.dart';
import 'package:time_tracker_mobile/widgets/internet_access.dart';

import 'constants.dart';
import 'main.dart';

class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  Map _source = {ConnectivityResult.none: false};
  InternetAccess _connectivity = InternetAccess.instance;

  @override
  void initState() {
    _connectivity.initialise();
    _connectivity.myStream.listen((source) {
      switch (source.keys.toList()[0]) {
        case ConnectivityResult.none:
          ScaffoldMessenger.of(navigatorKey.currentContext)
              .showSnackBar(SnackBar(content: Text("No internet")));
          break;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Flutter Demo',
      theme: theme,
      home: LoginSwitch(),
      routes: {
        MenuScreen.routeName: (ctx) => MenuScreen(),
        WorkLogDetailScreen.routeName: (ctx) => WorkLogDetailScreen(),
        WorkLogScreen.routeName: (ctx) => WorkLogScreen(),
        ProjectScreen.routeName: (ctx) => ProjectScreen(),
        AddWorklogScreen.routeName: (ctx) => AddWorklogScreen(),
        LoginScreen.routeName: (ctx) => LoginScreen()
      },
    );
  }
}
