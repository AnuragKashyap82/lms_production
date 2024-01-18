import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Model/material_model.dart';

class MaterialRepository extends GetxController {
  static MaterialRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<List<MaterialModel>> getAllMaterials() async {
    try {
      final snapshot = await _db
          .collection("Materials")
          .orderBy("materialId", descending: true)
          .get();
      final list = snapshot.docs
          .map((document) => MaterialModel.fromSnapshot(document))
          .toList();
      return list;
    } catch (e) {
      throw "something went wrong"; // Fix typo in the error message
    }
  }
}
