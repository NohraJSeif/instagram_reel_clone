import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'user_model.dart';

class ProfileFunctions {
  static FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<UserModel?> getUserDetails(String userId) async {
    try {
      final result = await _firestore.collection('users').doc(userId).get();

      UserModel userModel = UserModel.fromJson(result.data()!);
      return userModel;
    } catch (e) {
      print(e);
      return null;
    }
  }

  static Future<void> onFollowAndUnFollow(
      bool isFollow, String profileUserId) async {
    try {
      final currentUserProfileReference =
          _firestore.collection("users").doc(_auth.currentUser!.uid);

      final profileUserProfileReference =
          _firestore.collection("users").doc(profileUserId);

      final currentUserFollowerReference = _firestore
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .collection("following")
          .doc(profileUserId);

      final profileUserFollowerReference = _firestore
          .collection("users")
          .doc(profileUserId)
          .collection("followers")
          .doc(_auth.currentUser!.uid);

      await _firestore.runTransaction((transaction) async {
        final profileUser = await transaction.get(profileUserProfileReference);
        final currentUser = await transaction.get(currentUserProfileReference);
        int profileUserFollowerCount = profileUser['followers'];
        int currentUserFollowingCount = currentUser['following'];

        if (isFollow) {
          transaction.update(profileUserProfileReference, {
            "followers": profileUserFollowerCount + 1,
          });

          transaction.update(currentUserProfileReference, {
            "following": currentUserFollowingCount + 1,
          });
          transaction.set(currentUserFollowerReference, {"uid": profileUserId});
          transaction.set(
              profileUserFollowerReference, {"uid": _auth.currentUser!.uid});
        } else {
          transaction.update(profileUserProfileReference, {
            "followers": profileUserFollowerCount - 1,
          });

          transaction.update(currentUserProfileReference, {
            "following": currentUserFollowingCount - 1,
          });
          transaction.delete(currentUserFollowerReference);
          transaction.delete(profileUserFollowerReference);
        }
      });
    } catch (e) {
      print(e);
    }
  }
}
