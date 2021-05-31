import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:time_tracker_mobile/models/project.dart';
import 'package:time_tracker_mobile/providers/projects.dart';

class ProjectSearch extends StatefulWidget {
  final Color textColor;
  final Function onChange;
  final Project project;
  ProjectSearch({this.textColor = Colors.white, this.onChange, this.project});

  @override
  _ProjectSearchState createState() => _ProjectSearchState();
}

class _ProjectSearchState extends State<ProjectSearch> {
  TextEditingController controller = TextEditingController(text: "");
  List<Project> options;
  bool isInit = false;

  @override
  void didChangeDependencies() {
    if (!isInit) {
      Provider.of<Projects>(context, listen: false).getProjects().then((value) {
        setState(() {
          options = Provider.of<Projects>(context, listen: false).projects;
        });
      });
      print("Options: $options");
      isInit = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Autocomplete<Project>(
      fieldViewBuilder:
          (context, textEditingController, focusNode, onFieldSubmitted) {
        textEditingController.text =
            widget.project == null ? "" : widget.project.name;
        focusNode.addListener(() {
          textEditingController.text =
              widget.project == null ? "" : widget.project.name;
        });
        return TextFormField(
          focusNode: focusNode,
          validator: (value) {
            if (options.isEmpty) {
              return "You haven't been assigned to any projects";
            }
            if (widget.project == null) {
              return "Please choose a project";
            }
            return null;
          },
          onEditingComplete: () {
            if (textEditingController.text == "") {
              widget.onChange(null);
            } else {
              widget.onChange(options.where((Project option) {
                return option
                    .toString()
                    .toLowerCase()
                    .contains(textEditingController.text.toLowerCase());
              }).first);
            }
          },
          onFieldSubmitted: (_) => onFieldSubmitted,
          controller: textEditingController,
          style: TextStyle(
            color: widget.textColor,
          ),
          decoration: InputDecoration(
            labelText: "Project",
            labelStyle: TextStyle(
                color: Theme.of(context).accentTextTheme.bodyText2.color),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: Theme.of(context).accentTextTheme.bodyText2.color)),
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color: Theme.of(context).accentTextTheme.bodyText2.color)),
          ),
        );
      },
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text == '') {
          // return const Iterable<Project>.empty();
          return options;
        }
        if (options == null) {
          return const Iterable<Project>.empty();
        }
        return options.where((Project option) {
          return option
              .toString()
              .toLowerCase()
              .contains(textEditingValue.text.toLowerCase());
        });
      },
      onSelected: (Project selection) {
        widget.onChange(selection);
      },
    );
  }
}
