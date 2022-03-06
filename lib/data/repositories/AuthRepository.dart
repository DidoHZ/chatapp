import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  bool isUserLoggedIn() {
    return FirebaseAuth.instance.currentUser != null;
  }

  Future<void> connectEmailPassword(String mail, String pass) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: mail, password: pass);
  }

  Future<void> createAcount(String mail, String pass, String username) async {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: mail, password: pass);
    await userCredential.user?.updateDisplayName(username);
  }

  Future<void> restPassword(String mail) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: mail);
  }

  Future<void> verifyResetCode(String code) async {
    await FirebaseAuth.instance.verifyPasswordResetCode(code);
  }

  Future<void> confirmeResetCode(String code, String newPassword) async {
    await FirebaseAuth.instance
        .confirmPasswordReset(code: code, newPassword: newPassword);
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
