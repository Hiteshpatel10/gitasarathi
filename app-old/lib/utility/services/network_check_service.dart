import 'dart:async';
import 'package:chapter/main.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class CoreConnectionCheckService with WidgetsBindingObserver {
  static final CoreConnectionCheckService _instance = CoreConnectionCheckService._internal();
  StreamSubscription? _subscription;
  bool _isDisposed = false;

  CoreConnectionCheckService._internal();

  factory CoreConnectionCheckService() {
    return _instance;
  }

  void startListening(AppLifecycleState state, {Function? onConnected, Function? onDisconnected}) {
    if (_isDisposed) return;

    logger.i("CoreConnectionCheckService => AppLifecycleState $state");

    if (_subscription == null) {
      WidgetsBinding.instance.addObserver(this);
      _subscription = _getConnectivity(onConnected: onConnected, onDisconnected: onDisconnected);
    }
  }

  void stopListening() {
    logger.i("CoreConnectionCheckService => Stopping connection check");
    WidgetsBinding.instance.removeObserver(this);
    _subscription?.cancel();
    _subscription = null;
    _isDisposed = true;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_isDisposed) return; // Ensure no listeners after disposal
    logger.i("CoreConnectionCheckService => state: $state");

    if (state == AppLifecycleState.resumed && _subscription == null) {
      startListening(state);
    }
  }

  StreamSubscription<void> _getConnectivity({Function? onConnected, Function? onDisconnected}) {
    final internetChecker = InternetConnectionChecker();
    return internetChecker.onStatusChange.listen((status) {
      logger.i("CoreConnectionCheckService => Connectivity Status: $status");

      switch (status) {
        case InternetConnectionStatus.connected:
          onConnected?.call();
          break;
        case InternetConnectionStatus.disconnected:
          onDisconnected?.call();
          break;
      }
    });
  }
}
