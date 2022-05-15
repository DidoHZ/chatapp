import 'dart:async';

import 'package:chatapp/constants/strings.dart';
import 'package:chatapp/logic/cubit/chats/chats_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

///*
/// When Create Notification Service it's Automatically Start.
/// >
/// `bool _isRunning` : Service status ,
/// `void stopService()` : Stop service
///
class NotificationService {
  List<StreamSubscription> _serviceSubscriptions = [];

  bool _isRunning = false;
  late final _uid;

  NotificationService({required BuildContext context}) {
    _startService(context);
    _isRunning = true;
  }

  void _startService(BuildContext context) async {
    _uid = FirebaseAuth.instance.currentUser!.uid;

    final token = await FirebaseMessaging.instance
        .getToken(); // Device Token for Firebase Messaging

    final res = await FirebaseFirestore.instance
        .collection("User")
        .where("uid", isEqualTo: _uid)
        .get();

    if (res.size == 0) {
      await FirebaseFirestore.instance.collection("FCMs")
      .add(<String, dynamic>{ "uid": _uid, "FCM": token });
    } else {
      _setFCM(token!);
    }

    // Save new token when token is refresh
    _serviceSubscriptions.add(FirebaseMessaging.instance.onTokenRefresh
        .listen((event) => _setFCM(event)));

    // Check if user is Sing-out to remove user FCM
    _serviceSubscriptions
        .add(FirebaseAuth.instance.idTokenChanges().listen((currentUser) async {
      if (currentUser == null) _setFCM("");
    }));

    // On Notificaion received (Background)
    _serviceSubscriptions.add(FirebaseMessaging.onMessage.listen(
        (RemoteMessage message) => Get.snackbar(
            message.notification?.title! ?? message.data["title"],
            message.notification?.body! ?? message.data["body"])));

    // When Notificaion Open (Foreground)
    _serviceSubscriptions.add(FirebaseMessaging.onMessageOpenedApp.listen(
        (RemoteMessage message) => Navigator.of(context)
            .pushNamedAndRemoveUntil(chatPage, (route) => route.isFirst,
                arguments: BlocProvider.of<ChatsCubit>(context)
                    .state.chats.value.entries
                    .where((element) => element.key.uid == message.data["uid"])
                    .first.key)));
  }

  stopService() async {
    for (var element in _serviceSubscriptions) {
      await element.cancel();
    }
    _serviceSubscriptions.removeWhere((element) => true);
    _isRunning = false;
  }

  void _setFCM(String token) async {
    await FirebaseFirestore.instance
        .collection("FCMs")
        .doc((await FirebaseFirestore.instance
                .collection("FCMs")
                .where("uid", isEqualTo: _uid)
                .get())
            .docs
            .first
            .id)
        .update({"FCM": token});
  }

  get isRunning => _isRunning;
}
