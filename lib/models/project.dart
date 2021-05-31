import "package:flutter/material.dart";

class Project {
  final int id;
  final String name;
  final String description;
  final bool isActive;

  Project({this.id, this.name, this.description, this.isActive});

  @override
  String toString() {
    return '$name';
  }
}
