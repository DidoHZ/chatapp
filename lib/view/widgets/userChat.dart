import 'package:chatapp/constants/string.dart';
import 'package:chatapp/data/models/message.dart';
import 'package:chatapp/logic/cubit/chats/chats_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserChat extends StatefulWidget {
  final user;
  const UserChat({required this.user, Key? key}) : super(key: key);

  @override
  State<UserChat> createState() => _UserChatState();
}

class _UserChatState extends State<UserChat> {
  
  String getTime(String date) {
    final datetime = DateTime.fromMillisecondsSinceEpoch(int.parse(date));

    return "${datetime.hour}:${datetime.minute}";
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.account_circle_outlined, size: 30),
      onTap: () =>
          Navigator.of(context).pushNamed(chatPage, arguments: widget.user),
      title: Text(widget.user.username),
      subtitle: StreamBuilder(
          stream: BlocProvider.of<ChatsCubit>(context).state.lastmessages!,
          builder: (context,
              AsyncSnapshot<Map<String, Stream<List<Message>>>> streamshot) {
            return streamshot.hasData
                ? StreamBuilder(
                    stream: streamshot.data![widget.user.uid],
                    builder: (context, AsyncSnapshot<List<Message>> snapshot) {
                      return snapshot.hasData && snapshot.data!.isNotEmpty
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(padding: EdgeInsets.only(left: 10), child: Text(snapshot.data!.first.message,overflow: TextOverflow.ellipsis)),
                                Row(mainAxisAlignment: MainAxisAlignment.end, children: [Text(getTime(snapshot.data!.first.date))])
                              ],
                            )
                          : const SizedBox();
                    })
                : const Text("No Users");
          }),
    );
  }
}
