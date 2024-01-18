import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../Model/time_table_model.dart';

class TimetableFacultyRepository extends GetxController {
  static TimetableFacultyRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<List<TimetableModel>> getAllFacultyTimetables(String uid) async {
    try {
      final snapshot = await _db
          .collection("TimeTable")
          .where("facultyUid", isEqualTo: uid)
          .get();
      final list = snapshot.docs
          .map((document) => TimetableModel.fromSnapshot(document))
          .toList();
      return list;
    } catch (e) {
      throw "something went wrong"; // Fix typo in the error message
    }
  }
}
