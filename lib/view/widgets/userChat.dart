import 'package:chatapp/constants/strings.dart';
import 'package:chatapp/core/Storage.dart';
import 'package:chatapp/data/models/message.dart';
import 'package:flutter/material.dart';

class UserChat extends StatefulWidget {
  final user;
  final List<Message?> chat;
  const UserChat({required this.user, required this.chat, Key? key})
      : super(key: key);

  @override
  State<UserChat> createState() => _UserChatState();
}

class _UserChatState extends State<UserChat> {
  String getTime(String date) {
    final datetime = DateTime.fromMillisecondsSinceEpoch(int.parse(date));

    return "${datetime.hour.toString().padLeft(2, '0')}:${datetime.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: FutureBuilder(
          future: Storage.instance.getProfileImage(widget.user.uid),
          builder: (context, AsyncSnapshot<Image> snapshot) {
            //print("${widget.user.username}: ${snapshot.data}");
            if (!snapshot.hasData) return const CircleAvatar();
            return CircleAvatar(
                backgroundImage: snapshot.data?.image);
          }),
      onTap: () =>
          Navigator.of(context).pushNamed(chatPage, arguments: widget.user),
      title: Text(widget.user.username),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                  widget.chat.isNotEmpty ? widget.chat.first!.message : "",
                  overflow: TextOverflow.ellipsis)),
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Text(widget.chat.isNotEmpty ? getTime(widget.chat.first!.date) : "")
          ])
        ],
      ),
    );
  }
}
