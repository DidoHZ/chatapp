import 'dart:async';

import 'package:chatapp/constants/strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

///*
/// When Create User Service it's Automatically Start.
/// >
/// `bool _isRunning` : Service status ,
/// `void stopService()` : Stop service
///
class UserService {
  final List<StreamSubscription> _serviceSubscriptions = [];

  bool _isRunning = false;
  late final _uid;

  UserService({required BuildContext context}) {
    _startService(context);
    _isRunning = true;
  }

  void _startService(BuildContext context) async {
    _serviceSubscriptions.add(FirebaseAuth.instance.idTokenChanges().listen((event) async {
      if (event != null) return;
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushReplacementNamed(loginPage);
    }));
  }

  stopService() async {
    for (var element in _serviceSubscriptions) {
      await element.cancel();
    }
    _serviceSubscriptions.removeWhere((element) => true);
    _isRunning = false;
  }

  get isRunning => _isRunning;
}
