import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:time_tracker_mobile/providers/users.dart';
import 'package:time_tracker_mobile/screens/login/widgets/input_field.dart';
import 'package:time_tracker_mobile/screens/menu/menu_screen.dart';

class LoginScreen extends StatefulWidget {
  static final routeName = "/login";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController usernameController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  bool isInit = false;

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String error = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(10)),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Container(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        InputField(
                            labelText: "Username",
                            controller: usernameController),
                        InputField(
                            labelText: "Password",
                            controller: passwordController,
                            obscure: true),
                        logInButton(context)
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Container logInButton(BuildContext context) {
    return Container(
        width: double.infinity,
        child: Column(
          children: [
            if (error != "")
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  error,
                  textAlign: TextAlign.start,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Theme.of(context).cardColor),
                ),
                onPressed: () {
                  if (!_formKey.currentState.validate()) return;
                  Provider.of<Users>(context, listen: false)
                      .logInWithUsernameAndPassword(
                          usernameController.text, passwordController.text)
                      .then(
                    (value) {
                      if (value != null) {
                        setState(() {
                          error = value;
                        });
                      } else {
                        setState(() {
                          error = "";
                        });
                        Navigator.of(context)
                            .pushReplacementNamed(MenuScreen.routeName);
                      }
                    },
                  );
                },
                child: Text("Log in")),
          ],
        ));
  }
}
