import 'package:firebase_auth/firebase_auth.dart';

class ChatServices {
  static  bool isSender(String id) {
    return id == FirebaseAuth.instance.currentUser!.uid;
  }
}