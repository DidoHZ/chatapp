import 'package:flutter/material.dart';

class MessagingInput extends StatefulWidget {
  final Function(String, BuildContext) onSubmit;
  final Function(String, BuildContext)? onSendImage;
  final Function(String, BuildContext)? onSendFile;
  const MessagingInput({required this.onSubmit, this.onSendImage, this.onSendFile, Key? key}) : super(key: key);

  @override
  State<MessagingInput> createState() => _MessagingInputState();
}

class _MessagingInputState extends State<MessagingInput> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15 / 2),
        child: Row(
          children: [
            Expanded(
                child: TextField(
              controller: controller,
              onSubmitted: (value) async {
                controller.clear();
                await widget.onSubmit(value, context);
              },
              decoration: const InputDecoration(
                hintText: "Enter message..",
                border: InputBorder.none,
              ),
            )),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: () async {
                String value = controller.text;
                controller.clear();
                await widget.onSubmit(value, context);
              },
            )
          ],
        ));
  }
}
