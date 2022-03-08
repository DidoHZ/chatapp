import 'package:chatapp/constants/string.dart';
import 'package:chatapp/data/models/message.dart';
import 'package:chatapp/data/repositories/AuthRepository.dart';
import 'package:chatapp/logic/cubit/chats/chats_cubit.dart';
import 'package:chatapp/logic/fromSubmissionStatus.dart';
import 'package:chatapp/view/widgets/userChat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../data/models/user.dart' as chatUser;

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  void initState() {
    super.initState();

    String uid = FirebaseAuth.instance.currentUser!.uid;

    FirebaseMessaging.instance.getToken().then((FCMtoken) async {
      if ((await FirebaseFirestore.instance
                  .collection("User")
                  .where("uid", isEqualTo: uid)
                  .get())
              .size ==
          0) {
        await FirebaseFirestore.instance
            .collection("User")
            .add(<String, dynamic>{
          "uid": uid,
          "username": FirebaseAuth.instance.currentUser?.displayName,
          "image": ""
        });

        await FirebaseFirestore.instance
            .collection("FCMs")
            .add(<String, dynamic>{
          "uid": uid,
          "FCM": FCMtoken,
        });
      }
    }); // Device Token for Firebase Messaging

    // On Notificaion received (Background)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) => Get.snackbar(
        message.notification?.title! ?? message.data["title"],
        message.notification?.body! ?? message.data["body"]));

    // When Notificaion Open (Foreground)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) => Get.snackbar(
        message.notification?.title! ?? message.data["title"],
        message.notification?.body! ?? message.data["body"]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Chat"),
          leading: IconButton(
            icon: const Icon(Icons.power_settings_new),
            onPressed: () async {
              context.read<AuthRepository>().signOut();
              Navigator.pushReplacementNamed(context, loginPage);
            },
          ),
        ),
        body: const ChatsBuilder());
  }
}

class ChatsBuilder extends StatefulWidget {
  const ChatsBuilder({Key? key}) : super(key: key);

  @override
  State<ChatsBuilder> createState() => _ChatsBuilderState();
}

class _ChatsBuilderState extends State<ChatsBuilder>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    //Get Chats
    BlocProvider.of<ChatsCubit>(context).getChats();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocBuilder<ChatsCubit, ChatsState>(
      builder: (context, state) {
        if (state.status is FormSubmitting)
          return const Center(child: CircularProgressIndicator());

        return ValueListenableBuilder<
                Map<chatUser.User, ValueNotifier<List<Message>>>>(
            valueListenable: state.chats,
            builder: (_, chats, __) {
              return chats.isNotEmpty
                  ? Column(children: [
                      for (var k in chats.entries)
                        ValueListenableBuilder<List<Message>>(
                            valueListenable: k.value,
                            builder: (__, chats, _) {
                              return UserChat(
                                user: k.key,
                                chat: chats,
                              );
                            })
                    ])
                  : const SizedBox();
            });
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
