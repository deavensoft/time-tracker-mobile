import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:time_tracker_mobile/models/project.dart';
import 'package:time_tracker_mobile/providers/projects.dart';
import 'package:time_tracker_mobile/screens/worklogs/work_log_screen.dart';

class ProjectScreen extends StatefulWidget {
  static final routeName = "/projects";

  @override
  _ProjectScreenState createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
  bool isInit = false;

  Future<void> _refresh() async {
    await Provider.of<Projects>(context, listen: false).getProjects();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text("Projects"),
      ),
      // body: test(),
      body: FutureBuilder(
        future: _refresh(),
        builder: (context, snapshot) {
          return snapshot.connectionState == ConnectionState.waiting
              ? Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: _refresh,
                  child: Consumer<Projects>(
                    builder: (context, value, child) {
                      print("Work pls ${value.projects}");
                      return ListView(
                        children: [
                          ...value.projects.map((e) {
                            return projectRow(context, e);
                          }),
                        ],
                      );
                      // return projectRow(value, context);
                    },
                  ),
                );
        },
      ),
    );
  }

  Padding projectRow(BuildContext context, Project e) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: double.infinity,
        child: Material(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).accentColor,
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () {
              // Provider.of<WorkLogs>(context).setProject(project)
              Navigator.of(context)
                  .pushReplacementNamed(WorkLogScreen.routeName);
            },
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Center(
                  child: Text(
                e.name,
                style: Theme.of(context).primaryTextTheme.headline6,
              )),
            ),
          ),
        ),
      ),
    );
  }
}
