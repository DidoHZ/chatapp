import 'package:chatapp/data/models/message.dart';
import 'package:chatapp/logic/cubit/chats/chats_cubit.dart';
import 'package:chatapp/logic/fromSubmissionStatus.dart';
import 'package:chatapp/view/widgets/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatContainer extends StatefulWidget {
  final String uid;
  const ChatContainer({required this.uid, Key? key}) : super(key: key);

  @override
  _ChatContainerState createState() => _ChatContainerState();
}

class _ChatContainerState extends State<ChatContainer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: BlocBuilder<ChatsCubit, ChatsState>(
              builder: (context, state) {
                if (state.status is FormSubmitting)
                  return const Center(child: CircularProgressIndicator());

                return StreamBuilder<
                        Map<String, Stream<List<Message>>>>(
                    stream: state.messages!,
                    builder: (context, streamshot) {
                      if (streamshot.hasData) {
                        return StreamBuilder<List<Message>>(
                                  stream: streamshot.data![widget.uid],
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return ListView.builder(
                                        reverse: true,
                                        itemCount: snapshot.data?.length ?? 0,
                                        itemBuilder: (context, index) => ChatMessage(message: snapshot.data?[index]),
                                      );
                                    }
                                    return const SizedBox();
                                  });
                      }
                      return const SizedBox();
                    });
              },
            )));
  }
}
