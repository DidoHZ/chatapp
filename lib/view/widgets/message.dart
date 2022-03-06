import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  final message;
  
  const ChatMessage({required this.message, Key? key}): super(key: key) ;
  
  @override
  Widget build(BuildContext context) {
    return Row(
    	mainAxisAlignment: message.isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
          	constraints: BoxConstraints(minWidth: 0, maxWidth: MediaQuery.of(context).size.width * .75),
          	margin: const EdgeInsets.only(top: 15),
          	padding : const EdgeInsets.symmetric(horizontal: 15 * 0.75, vertical: 15 / 2),
          	decoration: BoxDecoration(color: message.isSender ? Colors.cyan : Colors.grey , borderRadius: BorderRadius.circular(30)),
          	child: Text(message.message, style: const TextStyle(color: Colors.white))
          )
        ],
      );
  }
}
