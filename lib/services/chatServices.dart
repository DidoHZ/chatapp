import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatServices {
  static bool isSender(String id) {
    return id == FirebaseAuth.instance.currentUser!.uid;
  }

  static Future<String> getUserFCM(String uid) async {
    
    final x = await FirebaseFirestore.instance
        .collection("FCMs")
        .where("uid", isEqualTo: uid)
        .get();

    return '${x.docs.first.data()["FCM"]}@fcm.googleapis.com';
  }
}
