import 'package:chatapp/logic/cubit/chats/chats_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'widgets/InputField.dart';
import 'widgets/chatContainer.dart';

class Chat extends StatefulWidget {
  final user;
  const Chat({this.user, Key? key}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> with AutomaticKeepAliveClientMixin{
  @override
  void initState() {
    BlocProvider.of<ChatsCubit>(context).initChatID(widget.user.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
        appBar: AppBar(title: Text("Chat ${widget.user.username}")),
        body: Column(children: [
          ChatContainer(uid: widget.user.uid),
          MessagingInput(
              onSubmit: (String value, BuildContext _context) async =>
                  await BlocProvider.of<ChatsCubit>(_context)
                      .sendMessage(value, widget.user.uid))
        ]));
  }
  
  @override
  bool get wantKeepAlive => true;
}
