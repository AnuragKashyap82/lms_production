import 'package:eduventure/Model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<UserModel> getUserData(String uid) async {
    try {
      final doc = await _db.collection("users").doc(uid).get();

      if (doc.exists) {
        return UserModel.fromSnapshot(doc);
      } else {
        // Handle case where user data doesn't exist for the given UID
        return UserModel.empty();
      }
    } catch (e) {
      throw "Error fetching user data: $e";
    }
  }
}
