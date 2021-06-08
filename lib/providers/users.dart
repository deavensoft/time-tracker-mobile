import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:time_tracker_mobile/constants.dart';
import 'package:time_tracker_mobile/main.dart';
import 'package:time_tracker_mobile/screens/login/login_screen.dart';

class Users with ChangeNotifier {
  String userId;
  static String accessToken;
  static String refreshToken;
  bool isLoggedIn = false;

  Users() {
    logInWithStoredToken().then((value) {
      if (value) {
        isLoggedIn = value;
        // notifyListeners();
      }
    });
  }

  Future<String> logInWithUsernameAndPassword(
    String username,
    String password,
  ) async {
    try {
      var response = await http.post(
          Uri.http("$IP:$KEYCLOAK_PORT",
              "/auth/realms/$KEYCLOAK_REALM/protocol/openid-connect/token"),
          headers: {
            "Content-Type": "application/x-www-form-urlencoded"
          },
          body: {
            "client_id": "$KEYCLOAK_CLIENT",
            "username": username,
            "password": password,
            "grant_type": "password"
          });
      if (json.decode(response.body)["error"] == null) {
        _extractDataFromResponse(response);
        return null;
      } else {
        return "Username or password is incorrect";
      }
    } on SocketException catch (e) {
      ScaffoldMessenger.of(navigatorKey.currentContext).showSnackBar(
        SnackBar(
          content: Text("${e.message} ${e.osError.message} "),
        ),
      );
      return "${e.message} ${e.osError.message} ";
    } on Exception catch (e) {
      ScaffoldMessenger.of(navigatorKey.currentContext).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
      return e.toString();
    }
    notifyListeners();
  }

  Future<bool> logInWithStoredToken() async {
    print("Testing $IP");
    try {
      var sharedPreferences = await SharedPreferences.getInstance();
      if (!sharedPreferences.containsKey("accessToken")) return false;

      var tempAccessToken = sharedPreferences.getString("accessToken");
      var tempRefreshToken = sharedPreferences.getString("refreshToken");
      DateTime accessTokenExp = DateTime.fromMillisecondsSinceEpoch(
        JwtDecoder.decode(tempAccessToken)["exp"] * 1000,
      );

      if (accessTokenExp.isBefore(DateTime.now())) {
        if (await isRefreshTokenValid(tempRefreshToken)) {
          accessToken = tempAccessToken;
          refreshToken = tempRefreshToken;
          userId = _getUserIdFromAccessToken(accessToken);
          return true;
        } else {
          return false;
        }
      } else {
        return await getTokenWithRefreshToken(tempRefreshToken);
      }
    } on SocketException catch (e) {
      ScaffoldMessenger.of(navigatorKey.currentContext).showSnackBar(
        SnackBar(
          content: Text("${e.message} ${e.osError.message} "),
        ),
      );
      return false;
    } on Exception catch (e) {
      ScaffoldMessenger.of(navigatorKey.currentContext).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
          ),
        ),
      );
      return false;
    }
  }

  static Future<String> getToken() async {
    DateTime accessTokenExp = DateTime.fromMillisecondsSinceEpoch(
      JwtDecoder.decode(accessToken)["exp"] * 1000,
    );

    if (DateTime.now().isBefore(accessTokenExp)) {
      return accessToken;
    } else {
      var response = await http.post(
          Uri.http("$IP:$KEYCLOAK_PORT",
              "/auth/realms/$KEYCLOAK_REALM/protocol/openid-connect/token"),
          headers: {
            "Content-Type": "application/x-www-form-urlencoded"
          },
          body: {
            "client_id": "$KEYCLOAK_CLIENT",
            "grant_type": "refresh_token",
            "refresh_token": refreshToken
          });
      if (json.decode(response.body)["error"] == null) {
        Map<String, dynamic> bodyDecoded = json.decode(response.body);
        accessToken = bodyDecoded["access_token"];
        refreshToken = bodyDecoded["refresh_token"];
        return accessToken;
      } else {
        if (json.decode(response.body)["error"] == "invalid_grant") {
          ScaffoldMessenger.of(navigatorKey.currentContext).showSnackBar(
            SnackBar(
              content:
                  Text("Refresh token invalid, redirecting to login screen"),
            ),
          );
          Navigator.of(navigatorKey.currentContext).pushNamedAndRemoveUntil(
            LoginScreen.routeName,
            (route) => false,
          );
          return "error";
        } else {
          ScaffoldMessenger.of(navigatorKey.currentContext).showSnackBar(
            SnackBar(
              content: Text("No internet"),
            ),
          );
          return "no-internet";
        }
      }
    }
  }

  Future<bool> isRefreshTokenValid(String token) async {
    var response = await http.post(
        Uri.http("$IP:$KEYCLOAK_PORT",
            "/auth/realms/$KEYCLOAK_REALM/protocol/openid-connect/token"),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: {
          "client_id": "$KEYCLOAK_CLIENT",
          "grant_type": "refresh_token",
          "refresh_token": token
        });

    if (json.decode(response.body)["error"] == null) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> getTokenWithRefreshToken(String token) async {
    var response = await http.post(
        Uri.http("$IP:$KEYCLOAK_PORT",
            "/auth/realms/$KEYCLOAK_REALM/protocol/openid-connect/token"),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded"
        },
        body: {
          "client_id": "$KEYCLOAK_CLIENT",
          "grant_type": "refresh_token",
          "refresh_token": token
        });
    if (json.decode(response.body)["error"] != null) {
      return false;
    }
    _extractDataFromResponse(response);
    return true;
  }

  void _extractDataFromResponse(Response response) {
    Map<String, dynamic> bodyDecoded = json.decode(response.body);
    accessToken = bodyDecoded["access_token"];
    refreshToken = bodyDecoded["refresh_token"];
    _storeRefreshAndAccessToken(refreshToken, accessToken);
    userId = _getUserIdFromAccessToken(bodyDecoded["access_token"]);
    print(userId);
  }

  void _storeRefreshAndAccessToken(
      String refreshToken, String accessToken) async {
    var sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("accessToken", accessToken);
    sharedPreferences.setString("refreshToken", refreshToken);
  }

  String _getUserIdFromAccessToken(String token) {
    Map<String, dynamic> decodedAccessToken = JwtDecoder.decode(token);
    return decodedAccessToken["user_id"];
  }

  Future<void> logOut() async {
    try {
      var sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.clear();
      Navigator.of(navigatorKey.currentContext).pushNamedAndRemoveUntil(
        LoginScreen.routeName,
        (route) => false,
      );
      var token = await Users.getToken();
      await http.post(
          Uri.http("$IP:$KEYCLOAK_PORT",
              "/auth/realms/$KEYCLOAK_REALM/protocol/openid-connect/logout"),
          headers: {
            "Content-Type": "application/x-www-form-urlencoded",
            "Authorization": "bearer $token"
          },
          body: {
            "client_id": "$KEYCLOAK_CLIENT",
            "refresh_token": refreshToken
          });
    } on SocketException catch (e) {
      ScaffoldMessenger.of(navigatorKey.currentContext).showSnackBar(
          SnackBar(content: Text("${e.message} ${e.osError.message} ")));
    } on Exception catch (e) {
      ScaffoldMessenger.of(navigatorKey.currentContext)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
}
