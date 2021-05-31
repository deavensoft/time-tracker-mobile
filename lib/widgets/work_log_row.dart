import 'dart:async';

import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_mobile/models/work_log.dart';
import 'package:time_tracker_mobile/providers/work_logs.dart';
import 'package:time_tracker_mobile/screens/worklog_details/work_log_detail_screen.dart';

class WorkLogRow extends StatefulWidget {
  final WorkLog workLog;

  WorkLogRow(this.workLog);

  @override
  _WorkLogRowState createState() => _WorkLogRowState();
}

class _WorkLogRowState extends State<WorkLogRow> {
  bool isPressed = false;
  bool isDone = false;
  DateTime current = DateTime(0);
  Timer timer;

  void refresh(Timer timer) {
    setState(() {
      this.current = current.add(Duration(seconds: 1));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) async {
        return await showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Are you sure you want to delete this work log"),
              actions: [
                OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    child: Text("Yes")),
                OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child: Text("No"))
              ],
            );
          },
        );
      },
      onDismissed: (direction) async {
        await Provider.of<WorkLogs>(context, listen: false)
            .deleteWorkLog(widget.workLog.id);
      },
      background: Container(
        color: Colors.red,
      ),
      child: Container(
        height: 60,
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        width: double.infinity,
        child: Material(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(10),
          elevation: 4,
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () {
              Navigator.of(context).pushNamed(WorkLogDetailScreen.routeName,
                  arguments: widget.workLog);
            },
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10)),
                    child: Container(
                      decoration:
                          BoxDecoration(color: Theme.of(context).cardColor),
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.all(0),
                              child: Row(
                                children: [
                                  Text("Hours: ",
                                      textAlign: TextAlign.start,
                                      style: Theme.of(context)
                                          .primaryTextTheme
                                          .headline3),
                                  Text("${widget.workLog.hours}",
                                      textAlign: TextAlign.start,
                                      style: Theme.of(context)
                                          .primaryTextTheme
                                          .headline4)
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.all(0),
                              child: Row(
                                children: [
                                  Text(
                                    "Date: ",
                                    textAlign: TextAlign.start,
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .headline3,
                                  ),
                                  Text(
                                    "${DateFormat("yyyy-MM-dd").format(widget.workLog.date)}",
                                    textAlign: TextAlign.start,
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .headline2,
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.all(0),
                              child: Row(
                                children: [
                                  Text(
                                    "Project: ",
                                    textAlign: TextAlign.start,
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .headline3,
                                  ),
                                  Text(
                                    "${widget.workLog.project.name}",
                                    textAlign: TextAlign.start,
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .headline1,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      widget.workLog.topic,
                      overflow: TextOverflow.clip,
                      softWrap: true,
                      style: Theme.of(context).primaryTextTheme.headline5,
                    ),
                  ),
                  Container(
                    child: Row(
                      children: [
                        Icon(Icons.keyboard_arrow_left_sharp),
                        Icon(Icons.delete)
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
