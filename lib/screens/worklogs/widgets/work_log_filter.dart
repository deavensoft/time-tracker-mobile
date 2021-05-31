import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:time_tracker_mobile/providers/work_logs.dart';
import 'package:time_tracker_mobile/screens/worklogs/widgets/date_filter.dart';
import 'package:time_tracker_mobile/widgets/project_search.dart';

class WorkLogFilter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Column(children: [
          Container(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: DateFilter(
                      labelText: "From: ",
                      date: Provider.of<WorkLogs>(context).from,
                      setDate: Provider.of<WorkLogs>(context).setFrom),
                ),
                Expanded(
                  child: DateFilter(
                      labelText: "To: ",
                      date: Provider.of<WorkLogs>(context).to,
                      setDate: Provider.of<WorkLogs>(context).setTo),
                )
              ],
            ),
          ),
          Container(
              color: Theme.of(context).primaryColor,
              padding: EdgeInsets.all(10),
              child: ProjectSearch(
                onChange: Provider.of<WorkLogs>(context).setProject,
                project: Provider.of<WorkLogs>(context).project,
              ))
        ]),
      ),
    );
  }
}
