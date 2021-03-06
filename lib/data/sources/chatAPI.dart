import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatAPI {
  Stream<QuerySnapshot<Map<String, dynamic>>> getChats () {
    return FirebaseFirestore.instance
                  .collection("User")
                  .where("uid", isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
                  .snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getChat (String docID) {
    return FirebaseFirestore.instance
                  .collection("Chats")
                  .doc(docID)
                  .collection("Chat")
                  .orderBy("time", descending: true)
                  .snapshots();
  }
  
  Stream<QuerySnapshot<Map<String, dynamic>>> getlastChat (String docID) {
    return FirebaseFirestore.instance
                  .collection("Chats")
                  .doc(docID)
                  .collection("Chat")
                  .orderBy("time", descending: true)
                  .limit(1)
                  .snapshots();
  }
}
