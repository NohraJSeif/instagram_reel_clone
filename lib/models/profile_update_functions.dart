import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/user_model.dart';

class ProfileUpdateFunctions {
  static FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static FirebaseStorage _storage = FirebaseStorage.instance;

  static Future<void> updateUserProfile(UserModel userModel) async {
    try {
      await _firestore
          .collection('users')
          .doc(userModel.uid)
          .update(userModel.toJson());
    } catch (e) {
      print(e);
    }
  }

  static Future<String?> uploadImage(File imageFile, String imageName) async {
    try {
      final reference = _storage.ref().child("images/$imageName.png");
      final uploadTask = reference.putFile(imageFile);
      await uploadTask.whenComplete(() {});
      String downloadUrl = await reference.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
