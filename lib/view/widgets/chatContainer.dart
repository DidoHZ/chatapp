import 'package:chatapp/data/models/message.dart';
import 'package:chatapp/logic/cubit/chats/chats_cubit.dart';
import 'package:chatapp/view/widgets/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatContainer extends StatefulWidget {
  final String uid;
  const ChatContainer({required this.uid, Key? key})
      : super(key: key);

  @override
  _ChatContainerState createState() => _ChatContainerState();
}

class _ChatContainerState extends State<ChatContainer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: ValueListenableBuilder<List<Message>>(
              valueListenable: BlocProvider.of<ChatsCubit>(context).state.chats.value[BlocProvider.of<ChatsCubit>(context).state.chats.value.keys.where((element) => element.uid == widget.uid).first]!,
              builder: (__,messages,_) {
                return ListView.builder(
                                  reverse: true,
                                  addAutomaticKeepAlives: true,
                                  itemCount:  messages.length,
                                  itemBuilder: (context, index) => ChatMessage(
                                      message: messages[index]),
                                );
              }
            )));
  }
}
