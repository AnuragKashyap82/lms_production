import 'package:eduventure/Model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FacultyRepository extends GetxController {
  static FacultyRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;


  Future<List<UserModel>> getAllFaculty() async {
    try {
      final snapshot = await _db
          .collection("users") // Adjust collection name
          .where("userType", isEqualTo: "teacher")
          .get();
      final list = snapshot.docs
          .map((document) => UserModel.fromSnapshot(document))
          .toList();
      return list;
    } catch (e) {
      throw "something went wrong"; // Fix typo in the error message
    }
  }
}
