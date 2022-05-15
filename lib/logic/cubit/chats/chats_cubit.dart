import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:chatapp/data/models/message.dart';
import 'package:chatapp/data/models/user.dart';
import 'package:chatapp/data/repositories/chatRepository.dart';
import 'package:chatapp/logic/fromSubmissionStatus.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'chats_state.dart';

/*
* Chat Cubit :
    + Logic
    + Streams
    + Notifiers
    + Get Conversations
    + Send messages event
*/

class ChatsCubit extends Cubit<ChatsState> {
  final ChatRepository repo;

  Map<String, String> _chatIDs = {};
  Map<User, Function()> _listners = {};

  ChatsCubit({required this.repo}) : super(ChatsState());

  // Get Chat Conversations event
  void getChats() async {
    emit(state.copyWith(status: FormSubmitting()));

    try {
      repo.getUsers().listen((event) async {
        // Removing previous chat Listners
        if (_listners.isNotEmpty) {
          for (var i in state.chats.value.entries) {
            i.value.removeListener(_listners[i.key]!);
          }
          _listners.clear();
        }
        // New map
        // Used for ...
        Map<User, ValueNotifier<List<Message>>> map = {
          for (var user in event) user: ValueNotifier([])
        };

        // For each user in the chat
        for (var user in event) {
          
          // Geting user Chat's Document ID
          String chatID = await repo.getChatID(uid: user.uid);
          _chatIDs[user.uid] = chatID;
          // Add Listners for User chat changes
          var stream = repo.getchat(docID: chatID);

          map[user]!.value = await stream.first;

          stream.listen((event) => map[user]!.value = event);

          // Save chat listner (Sort Listner)
          // Here we are geting, sorting, saveing changes
          _listners[user] = () async {
	     
            Stopwatch stopwatch = Stopwatch()..start(); // TODO: wait what void return value ._.
	    
            // Notifie Listners for new data
            state.chats.value = _sortMapByDate(state.chats.value);

            // Cache New data
            (await SharedPreferences.getInstance()).setString(
                "chats",
                json.encode({
                  for (var i in state.chats.value.keys)
                    i.toJson(): [
                      for (var j in state.chats.value[i]!.value) j.toJson()
                    ]
                }));
                
            print('${user.username} Sorting tooks ${stopwatch.elapsed}');
          };
        }

        map = _sortMapByDate(map);

        _listners.forEach((user, func) =>
            // Add listners for each user's messages
            map[user]!.addListener(func));

        //Notifie Listners for New Messages
        state.chats.value = map;
      });

      emit(state.copyWith(status: SubmissionSuccess()));
    } catch (e, _) {
      emit(state.copyWith(status: SubmissionFailed(null)));
    }
  }

  Future<void> sendMessage(String message, User user) async {
    if (message.trim() == '') return;

    await repo.sendMessage(
        user: user, message: message.trim(), chatID: _chatIDs[user.uid]!);
  }

  Map<User, ValueNotifier<List<Message>>> _sortMapByDate(
      Map<User, ValueNotifier<List<Message>>> map) {
    //Get map users
    final list = map.keys.toList();

    // Sort Messages by date
    list.sort(
      (a, b) => ((map[b]?.value.isNotEmpty ?? false)
              ? map[b]!.value.first.date
              : "0")
          .compareTo((map[a]?.value.isNotEmpty ?? false)
              ? map[a]!.value.first.date
              : "0"),
    );

    // return sorted map
    return {for (var i in list) i: map[i]!};
  }
}
