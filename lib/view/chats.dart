import 'dart:convert';

import 'package:chatapp/constants/strings.dart';
import 'package:chatapp/core/Storage.dart';
import 'package:chatapp/data/models/message.dart';
import 'package:chatapp/logic/cubit/chats/chats_cubit.dart';
import 'package:chatapp/logic/fromSubmissionStatus.dart';
import 'package:chatapp/services/notificationService.dart';
import 'package:chatapp/services/userService.dart';
import 'package:chatapp/view/widgets/userChat.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/user.dart' as chatUser;

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late NotificationService notificationService;
  late UserService userservice;

  @override
  void initState() {
    notificationService = NotificationService(context: context);
    userservice = UserService(context: context);
    getCache();
    super.initState();
  }

  void getCache() async {
    final value = await SharedPreferences.getInstance();
    // Get Chat Cache from : Json (String) to [Map<User,ValueNotifier<List<Messages>>>]
    if (value.getString('chats') == null) return;
    BlocProvider.of<ChatsCubit>(context).state.chats.value = {
      for (var i in json.decode(value.getString('chats')!).entries)
        chatUser.User.fromJson(i.key):
            ValueNotifier([for (var j in i.value) Message.fromJson(j)])
    };
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(profilePage);
                },
                child: FutureBuilder<Image>(
                    future: Storage.instance.getMyProfileImage(),
                    builder: (context, snapshot) {
                      return CircleAvatar(backgroundImage: snapshot.data?.image);
                    }))
          ],
          title: const Text("Chat"),
          leading: IconButton(
            icon: const Icon(Icons.power_settings_new),
            onPressed: () async {
              userservice.stopService();
              notificationService.stopService();
              (await SharedPreferences.getInstance()).clear();
              await FirebaseAuth.instance.signOut();
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
              if (chats.isEmpty)
                return const Center(child: CircularProgressIndicator());

              return SingleChildScrollView(
                child: Column(children: [
                  for (var k in chats.entries)
                    ValueListenableBuilder<List<Message>>(
                        valueListenable: k.value,
                        builder: (__, messages, _) {
                          return UserChat(
                            user: k.key,
                            chat: messages,
                          );
                        })
                ]),
              );
            });
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
