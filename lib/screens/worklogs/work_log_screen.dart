import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:time_tracker_mobile/providers/projects.dart';
import 'package:time_tracker_mobile/providers/work_logs.dart';
import 'package:time_tracker_mobile/screens/worklogs/widgets/work_log_filter.dart';
import 'package:time_tracker_mobile/screens/add_worklog/add_worklog_screen.dart';
import 'package:time_tracker_mobile/widgets/work_log_row.dart';

class WorkLogScreen extends StatefulWidget {
  static final routeName = "/worklogs";

  @override
  _WorkLogScreenState createState() => _WorkLogScreenState();
}

class _WorkLogScreenState extends State<WorkLogScreen> {
  TextEditingController controller = TextEditingController();
  bool isInit = false;

  Future<void> _refresh() async {
    await Provider.of<Projects>(context, listen: false).getProjects();
    await Provider.of<WorkLogs>(context, listen: false).fetchWorkLogs();
  }

  @override
  void didChangeDependencies() async {
    if (!isInit) {
      isInit = true;
      _refresh();
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(AddWorklogScreen.routeName);
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text(
          "Time Tracker",
          style: Theme.of(context).primaryTextTheme.headline6,
        ),
      ),
      body: FutureBuilder(
        future: _refresh(),
        builder: (context, snapshot) {
          return snapshot.connectionState == ConnectionState.waiting
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : RefreshIndicator(
                  onRefresh: () => _refresh(),
                  child: ListView(
                    children: [
                      WorkLogFilter(),
                      Consumer<WorkLogs>(
                        builder: (context, value, child) {
                          return Column(
                            children: value.workLogs.reversed
                                .map<Widget>((e) => WorkLogRow(e))
                                .toList(),
                          );
                        },
                      ),
                    ],
                  ),
                );
        },
      ),
    );
  }
}
