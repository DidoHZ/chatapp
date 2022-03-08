import 'package:chatapp/logic/cubit/chats/chats_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'widgets/InputField.dart';
import 'widgets/chatContainer.dart';

class Chat extends StatefulWidget {
  final user;
  const Chat({required this.user, Key? key}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("${widget.user.username}")),
        body: Column(children: [
          ChatContainer(uid: widget.user.uid),
          MessagingInput(
              onSubmit: (String value, BuildContext context) async =>
                  await BlocProvider.of<ChatsCubit>(context)
                      .sendMessage(value, widget.user))
        ]));
  }
}
