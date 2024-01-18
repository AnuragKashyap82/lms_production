import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Model/result_model.dart';

class ResultRepository extends GetxController {
  static ResultRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<List<ResultModel>> getAllResults() async {
    try {
      final snapshot = await _db
          .collection("Result")
          .orderBy("dateTime", descending: true)
          .get();
      final list = snapshot.docs
          .map((document) => ResultModel.fromSnapshot(document))
          .toList();
      return list;
    } catch (e) {
      throw "something went wrong"; // Fix typo in the error message
    }
  }
}
