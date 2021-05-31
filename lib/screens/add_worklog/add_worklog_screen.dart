import "package:flutter/material.dart";
import 'package:time_tracker_mobile/models/project.dart';
import 'package:time_tracker_mobile/models/work_log.dart';
import 'package:time_tracker_mobile/screens/add_worklog/widgets/add_work_log_button.dart';
import 'package:time_tracker_mobile/screens/add_worklog/widgets/pick_date.dart';
import 'package:time_tracker_mobile/screens/add_worklog/widgets/work_log_field.dart';
import 'package:time_tracker_mobile/widgets/project_search.dart';

class AddWorklogScreen extends StatefulWidget {
  static final routeName = "/addWorklog";

  @override
  _AddWorklogScreenState createState() => _AddWorklogScreenState();
}

class _AddWorklogScreenState extends State<AddWorklogScreen> {
  DateTime date;
  Project selectedProject;
  final topicController = TextEditingController();
  final descriptionController = TextEditingController();
  final hoursController = TextEditingController();
  bool isInit = false;
  WorkLog workLog;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    date = DateTime.now();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (!isInit) {
      isInit = true;
      if (workLog == null &&
          ModalRoute.of(context).settings.arguments != null) {
        workLog = ModalRoute.of(context).settings.arguments;
        print(ModalRoute.of(context).settings.arguments);
        date = workLog.date;
        selectedProject = workLog.project;
        topicController.text = workLog.topic;
        descriptionController.text = workLog.description;
        hoursController.text = workLog.hours.toString();
      }
    }
    super.didChangeDependencies();
  }

  void setProject(Project project) {
    setState(() {
      selectedProject = project;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text("Add/Edit Work Log"),
      ),
      body: Container(
        color: Theme.of(context).backgroundColor,
        height: double.maxFinite,
        child: Center(
          child: ListView(
            children: [
              Form(
                key: _formKey,
                child: Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Theme.of(context).accentColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      PickDate(
                        date: date,
                        handleDatePick: handleDatePick,
                      ),
                      WorkLogField(
                        labelText: "Hours",
                        controller: hoursController,
                        textInputType: TextInputType.number,
                      ),
                      Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: ProjectSearch(
                            onChange: setProject,
                            textColor: Colors.white,
                            project: selectedProject,
                          )),
                      WorkLogField(
                          labelText: "Topic", controller: topicController),
                      WorkLogField(
                          labelText: "Description",
                          controller: descriptionController),
                      AddWorkLogButton(
                        workLog: workLog,
                        date: date,
                        project: selectedProject,
                        descriptionController: descriptionController,
                        hoursController: hoursController,
                        topicController: topicController,
                        formKey: _formKey,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  handleDatePick(value) {
    if (value != null) {
      setState(() {
        date = value;
      });
    } else {
      setState(() {
        date = DateTime.now();
      });
    }
  }
}
