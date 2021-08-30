import 'dart:io';

import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';

class InternetProvider with ChangeNotifier {
  Connectivity _connectivity = new Connectivity();

  bool _isConnected = false;
  bool get isConnected => _isConnected;

  startMonitoring() async {
    await initConnectivity();
    _connectivity.onConnectivityChanged.listen((result) async {
      print(result);
      if (result != ConnectivityResult.none) {
        await hasConnection().then((value) {
          _isConnected = true;
          notifyListeners();
        });
      } else {
        _isConnected = false;
        notifyListeners();
      }
    });
  }

  Future<void> initConnectivity() async {
    try {
      var status = await _connectivity.checkConnectivity();

      if (status != ConnectivityResult.none) {
        await hasConnection().then((value) {
          _isConnected = true;
          notifyListeners();
        });
      } else {
        _isConnected = false;
        notifyListeners();
      }
    } on PlatformException catch (e) {
      print("PlatformException: " + e.toString());
    }
  }

  Future<bool> hasConnection() async {
    bool isConnected = false;

    try {
      final List<InternetAddress> result =
          await InternetAddress.lookup("google.com");
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isConnected = true;
      }
    } on SocketException catch (_) {
      isConnected = false;
    }

    return isConnected;
  }
}
