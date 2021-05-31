import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:time_tracker_mobile/providers/users.dart';
import 'package:time_tracker_mobile/screens/menu/widgets/menu_option.dart';
import 'package:time_tracker_mobile/screens/project/project_screen.dart';
import 'package:time_tracker_mobile/screens/worklogs/work_log_screen.dart';
import 'package:time_tracker_mobile/screens/add_worklog/add_worklog_screen.dart';

class MenuScreen extends StatelessWidget {
  static final String routeName = "/menu";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text("Time Tracker"),
      ),
      body: ListView(
        children: [
          MenuOption(
            labelText: "Projects",
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            padding: const EdgeInsets.all(8.0),
            handleTap: () => changePage(context, ProjectScreen.routeName),
          ),
          MenuOption(
            labelText: "Work Logs",
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            padding: const EdgeInsets.all(8.0),
            handleTap: () => changePage(context, WorkLogScreen.routeName),
          ),
          MenuOption(
            labelText: "Add/Edit WorkLogs",
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            padding: const EdgeInsets.all(8.0),
            handleTap: () => changePage(context, AddWorklogScreen.routeName),
          ),
          MenuOption(
            labelText: "Log out",
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            padding: const EdgeInsets.all(8.0),
            handleTap: () => logOut(context),
          ),
        ],
      ),
    );
  }

  changePage(BuildContext context, String routeName) {
    Navigator.of(context).pushNamed(routeName);
  }

  logOut(BuildContext context) async {
    await Provider.of<Users>(context, listen: false).logOut();
  }
}
