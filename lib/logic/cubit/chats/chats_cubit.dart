import 'package:bloc/bloc.dart';
import 'package:chatapp/data/models/message.dart';
import 'package:chatapp/data/models/user.dart';
import 'package:chatapp/data/repositories/chatRepository.dart';
import 'package:chatapp/logic/fromSubmissionStatus.dart';
import 'package:flutter/material.dart';

part 'chats_state.dart';

class ChatsCubit extends Cubit<ChatsState> {
  final ChatRepository repo;
  Map<String, String> chatIDs = {};

  ChatsCubit({required this.repo}) : super(ChatsState());

  Future<void> getChats() async {
    emit(state.copyWith(status: FormSubmitting()));
    
    try {

      repo.getUsers().listen((event) async {
        Map<User, ValueNotifier<List<Message>>> map = { for (var user in event) user : ValueNotifier([]) };

        for (var user in event) {
          
          String chatID = await repo.getChatID(uid: user.uid);
          chatIDs[user.uid] = chatID;
          repo
              .getchat(docID: chatID)
              .listen((event) => map[user]!.value = event);
        }
        
        state.chats.value = map;
      });

      emit(state.copyWith(status: SubmissionSuccess()));
    } catch (e, _) {
      emit(state.copyWith(status: SubmissionFailed(null)));
    }
  }

  Future<void> sendMessage(String message, User user) async {
    if (message == '') return;
    
    await repo.sendMessage(user: user, message: message, chatID: chatIDs[user.uid]!);
  }
}
