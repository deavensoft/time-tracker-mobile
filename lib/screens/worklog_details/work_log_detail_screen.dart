import "package:flutter/material.dart";
import 'package:time_tracker_mobile/models/work_log.dart';
import 'package:time_tracker_mobile/screens/add_worklog/add_worklog_screen.dart';
import 'package:time_tracker_mobile/screens/worklog_details/widgets/worklog_detailed_row.dart';

class WorkLogDetailScreen extends StatelessWidget {
  static final routeName = "/detail";

  @override
  Widget build(BuildContext context) {
    WorkLog workLog = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text("WorkLog Details"),
      ),
      body: Container(
        width: double.infinity,
        child: Center(
          child: ListView(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Theme.of(context).accentColor,
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    WorkLogDetailedRow(
                      valueText: workLog.hours.toString(),
                      labelText: "Hours",
                    ),
                    WorkLogDetailedRow(
                      valueText: workLog.project.name,
                      labelText: "Project",
                    ),
                    WorkLogDetailedRow(
                      valueText: workLog.topic,
                      labelText: "Topic",
                    ),
                    WorkLogDetailedRow(
                      valueText: workLog.description,
                      labelText: "Description",
                    ),
                    makeButton(context: context, workLog: workLog)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget makeButton({BuildContext context, WorkLog workLog}) {
    return Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 5),
        child: ElevatedButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(AddWorklogScreen.routeName, arguments: workLog);
            },
            child: Text("Edit work log")));
  }
}
