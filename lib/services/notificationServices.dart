import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class NotificationServices {
  static void setFCM(String FCMtoken) async {
     await FirebaseFirestore.instance
                .collection("FCMs")
                .doc(
                  (await FirebaseFirestore.instance
                    .collection("FCMs")
                    .where("uid",isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                    .get()
                  ).docs.first.id )
                .update({"FCM" : FCMtoken});
  }
}