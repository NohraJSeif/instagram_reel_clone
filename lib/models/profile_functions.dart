import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'user_model.dart';

class ProfileFunctions {
  static FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<UserModel?> getUserDetails() async {
    try {
      final result = await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .get();

      UserModel userModel = UserModel.fromJson(result.data()!);
      return userModel;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
