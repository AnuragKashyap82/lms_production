import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Model/notice_model.dart';

class NoticeRepository extends GetxController {
  static NoticeRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<List<NoticeModel>> getAllNotices() async {
    try {
      final snapshot = await _db
          .collection("Notice") // Adjust collection name
          .orderBy("noticeId", descending: true)
          .get();
      final list = snapshot.docs
          .map((document) => NoticeModel.fromSnapshot(document))
          .toList();
      return list;
    } catch (e) {
      throw "something went wrong"; // Fix typo in the error message
    }
  }
}
