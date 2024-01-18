import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Model/classroom_model.dart';

class ClassroomRepository extends GetxController {
  static ClassroomRepository get instance => Get.find();

  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  Future<List<ClassroomModel>> getAllClassrooms() async {
    try {
      final snapshot = await _db
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .collection("classroom")
          .orderBy("classCode", descending: true)
          .get();
      final list = snapshot.docs
          .map((document) => ClassroomModel.fromSnapshot(document))
          .toList();
      return list;
    } catch (e) {
      throw "something went wrong"; // Fix typo in the error message
    }
  }
}
