import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'user_model.dart';

class SignupFunctions {
  static FirebaseAuth _auth = FirebaseAuth.instance;
  static FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<bool> createAccount(String email, String password) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (result.user != null) {
        _saveUserDetails(email);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<void> _saveUserDetails(String email) async {
    try {
      String uid = _auth.currentUser!.uid;
      UserModel userModel = UserModel(
        uid: uid,
        name: "",
        username: "",
        email: email,
        bio: "",
        addLink: "",
        profileImage: "",
        posts: 0,
        followers: 0,
        following: 0,
      );

      await _firestore.collection('users').doc(uid).set(userModel.toJson());
      print("Details saved successfully");
    } catch (e) {
      print(e);
    }
  }
}
