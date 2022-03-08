import 'package:chatapp/data/models/message.dart';
import 'package:chatapp/data/sources/chatAPI.dart';
import 'package:chatapp/services/chatServices.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../models/user.dart' as chatUser;

class ChatRepository {
  Stream<List<Message>> getchat({String docID = ''}) {
    return ChatAPI().getChat(docID).map((event) => List.generate(
        event.size,
        (index) => Message(
            date: event.docs[index]["time"].toString(),
            message: event.docs[index]["message"],
            isSender: ChatServices.isSender(event.docs[index]["uid"]))));
  }

  Stream<List<Message>> getlastchat({String docID = ''}) {
    return ChatAPI().getlastChat(docID).map((event) => List.generate(
        event.size,
        (index) => Message(
            date: event.docs[index]["time"].toString(),
            message: event.docs[index]["message"],
            isSender: ChatServices.isSender(event.docs[index]["uid"]))));
  }

  Stream<List<chatUser.User>> getUsers() {
    return ChatAPI().getChats().map((event) => List.generate(
        event.size,
        (index) => chatUser.User(
            uid: event.docs[index]["uid"],
            username: event.docs[index]["username"],
            image: event.docs[index]["image"])));
  }

  Future<String> getChatID({required String uid}) async {
    final chats = FirebaseFirestore.instance.collection("Chats");
    final currentuid = FirebaseAuth.instance.currentUser!.uid;

    final query = await chats
        .where('users', isEqualTo: {uid: null, currentuid: null})
        .limit(1)
        .get();

    if (query.docs.isNotEmpty) return query.docs.single.id;

    return (await chats.add({
      'users': {uid: null, currentuid: null}
    }))
        .id;
  }

  Future<void> sendMessage(
      {required user,
      required String message,
      required String chatID}) async {

    await FirebaseFirestore.instance
        .collection("Chats")
        .doc(chatID)
        .collection("Chat")
        .add({
      "uid": FirebaseAuth.instance.currentUser!.uid,
      "message": message,
      "time": DateTime.now().millisecondsSinceEpoch
    });

    FirebaseMessaging.instance.sendMessage(
      to: await ChatServices.getUserFCM(user.uid),
      data: {
        "title": user.username,
        "body": message
      }
    );
  }
}
