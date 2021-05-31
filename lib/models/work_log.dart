import 'dart:core';

import "package:flutter/material.dart";
import 'package:intl/intl.dart';
import 'package:time_tracker_mobile/models/project.dart';

class WorkLog {
  final int id;
  final String topic;
  final String description;
  final double hours;
  final DateTime date;
  int userId;
  final Project project;

  WorkLog(
      {this.id,
      this.userId,
      this.topic = "",
      this.description,
      this.project,
      this.hours,
      this.date});

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "user_id": userId,
      "topic": topic,
      "description": description,
      "project_id": project.id,
      "hours": hours,
      "date": DateFormat("yyyy-MM-dd").format(date)
    };
  }
}
