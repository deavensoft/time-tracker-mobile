import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:time_tracker_mobile/models/project.dart';
import 'package:time_tracker_mobile/models/work_log.dart';
import 'package:time_tracker_mobile/providers/users.dart';
import 'package:time_tracker_mobile/providers/work_logs.dart';
import 'package:time_tracker_mobile/screens/menu/menu_screen.dart';
import 'package:time_tracker_mobile/screens/worklogs/work_log_screen.dart';

class AddWorkLogButton extends StatelessWidget {
  final WorkLog workLog;
  final TextEditingController descriptionController;
  final TextEditingController hoursController;
  final TextEditingController topicController;
  final Project project;
  final DateTime date;
  final GlobalKey<FormState> formKey;

  AddWorkLogButton(
      {this.workLog,
      this.descriptionController,
      this.hoursController,
      this.topicController,
      this.project,
      this.date,
      this.formKey});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (!formKey.currentState.validate()) return;
          WorkLog temp = WorkLog(
              id: workLog == null ? -1 : workLog.id,
              description: descriptionController.text,
              hours: double.parse(hoursController.text),
              topic: topicController.text,
              project: project,
              date: date,
              userId:
                  int.parse(Provider.of<Users>(context, listen: false).userId));

          if (temp.id == -1) {
            Navigator.of(context).pushNamedAndRemoveUntil(
                MenuScreen.routeName, (route) => false);
            Provider.of<WorkLogs>(context, listen: false)
                .addWorkLog(temp)
                .then((value) {
              if (value == null)
                Navigator.pushNamed(context, WorkLogScreen.routeName);
            });
          } else {
            Navigator.popUntil(
                context, ModalRoute.withName(WorkLogScreen.routeName));
            Provider.of<WorkLogs>(context, listen: false)
                .editWorkLog(temp)
                .then((value) {
              if (value == null) {
                Navigator.pushReplacementNamed(
                    context, WorkLogScreen.routeName);
              }
            });
          }
        },
        child: Text("Save worklog"),
      ),
    );
    ;
  }
}
