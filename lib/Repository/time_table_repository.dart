import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../Model/time_table_model.dart';

class TimetableRepository extends GetxController {
  static TimetableRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<List<TimetableModel>> getAllTimetables(String semester, String branch) async {
    try {
      final snapshot = await _db
          .collection("TimeTable")
          .where("semester", isEqualTo: semester)
          .where("branch", isEqualTo: branch)
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
