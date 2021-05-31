import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:time_tracker_mobile/providers/users.dart';
import 'package:time_tracker_mobile/screens/login/login_screen.dart';
import 'package:time_tracker_mobile/screens/menu/menu_screen.dart';

class LoginSwitch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<Users>(context).logInWithStoredToken(),
      builder: (context, snapshot) {
        return snapshot.connectionState == ConnectionState.waiting
            ? Center(child: CircularProgressIndicator())
            : snapshot.data == true
                ? MenuScreen()
                : LoginScreen();
      },
    );

    return Provider.of<Users>(context).isLoggedIn
        ? MenuScreen()
        : LoginScreen();
  }
}
