import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:time_tracker_mobile/constants.dart';

class InternetAccess {
  InternetAccess._internal();

  static final InternetAccess _instance = InternetAccess._internal();

  static InternetAccess get instance => _instance;

  Connectivity connectivity = Connectivity();

  StreamController controller = StreamController.broadcast();

  Stream get myStream => controller.stream;

  void initialise() async {
    ConnectivityResult result = await connectivity.checkConnectivity();
    _checkStatus(result);
    connectivity.onConnectivityChanged.listen((result) {
      _checkStatus(result);
    });
  }

  void _checkStatus(ConnectivityResult result) async {
    bool isOnline = false;
    try {
      final resultKeyCloak = await InternetAddress.lookup('$IP:8080');
      final resultTimeTracker = await InternetAddress.lookup('$IP:9090');
      if (resultKeyCloak.isNotEmpty &&
          resultKeyCloak[0].rawAddress.isNotEmpty &&
          resultTimeTracker.isNotEmpty &&
          resultTimeTracker[0].rawAddress.isNotEmpty) {
        isOnline = true;
      } else
        isOnline = false;
    } on SocketException catch (_) {
      isOnline = false;
    }
    controller.sink.add({result: isOnline});
  }

  void disposeStream() => controller.close();
}
