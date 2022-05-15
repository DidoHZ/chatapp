import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  final message;
  final user;
  final Image? image;

  const ChatMessage({required this.message, required this.user,this.image, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          message.isSender ? MainAxisAlignment.start : MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (message.isSender)
          CircleAvatar(
              backgroundImage: image?.image, radius: 10),
        const SizedBox(width: 5),
        Container(
            constraints: BoxConstraints(
                minWidth: 0, maxWidth: MediaQuery.of(context).size.width * .75),
            margin: const EdgeInsets.only(top: 15),
            padding: const EdgeInsets.symmetric(
                horizontal: 15 * 0.75, vertical: 15 / 2),
            decoration: BoxDecoration(
                color: message.isSender ? Colors.blueGrey : Colors.cyan,
                borderRadius: BorderRadius.circular(20)),
            child: Text(message.message,
                style: const TextStyle(color: Colors.white)))
      ],
    );
  }
}
