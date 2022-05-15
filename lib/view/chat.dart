import 'package:chatapp/core/Storage.dart';
import 'package:chatapp/data/models/message.dart';
import 'package:chatapp/logic/cubit/chats/chats_cubit.dart';
import 'package:chatapp/view/widgets/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'widgets/InputField.dart';
class Chat extends StatefulWidget {
  final user;
  const Chat({required this.user, Key? key}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Image>(
      future: Storage.instance.getProfileImage(widget.user.uid),
      builder: (context, snapshot) {
        return Scaffold(
            appBar: AppBar(title: Row(
              children: [
                CircleAvatar(backgroundImage: snapshot.data?.image),
                const SizedBox(width: 10),
                Text("${widget.user.username}"),
              ],
            )),
            body: Column(children: [
              // Chat Container
              Expanded(
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: ValueListenableBuilder<List<Message>>(
                      valueListenable: BlocProvider.of<ChatsCubit>(context).state.chats.value[BlocProvider.of<ChatsCubit>(context).state.chats.value.keys.where((element) => element.uid == widget.user.uid).first]!,
                      builder: (__,messages,_) {
                        return ListView.builder(
                                          reverse: true,
                                          addAutomaticKeepAlives: true,
                                          itemCount:  messages.length,
                                          itemBuilder: (context, index) => ChatMessage(
                                              message: messages[index], user: widget.user,image: messages[index].isSender ? snapshot.data : null),
                                        );
                      }
              ))),
              //User Input Text Field
              MessagingInput(onSubmit: (String value, BuildContext context) async {
                if (value.length > 2000) return;
                await BlocProvider.of<ChatsCubit>(context)
                    .sendMessage(value, widget.user);
              })
            ]));
      }
    );
  }
}
