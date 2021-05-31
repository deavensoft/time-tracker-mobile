import "package:flutter/material.dart";
import "package:http/http.dart" as http;

class User {
  int id;
  String firstName;
  String lastName;
  String email;

  Future<void> getUser() async {
    var response =
        await http.get(Uri.http("192.168.22.28:9090", "/v1.0/projects"));
    print(response.body);
  }
}
