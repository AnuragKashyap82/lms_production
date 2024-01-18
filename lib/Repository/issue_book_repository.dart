import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Model/issue_book_model.dart';

class IssueBookRepository extends GetxController {
  static IssueBookRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<List<IssueBookModel>> getAllIssueBooks() async {
    try {
      final snapshot = await _db
          .collection("issueBooks") // Adjust collection name
          .orderBy("issueId", descending: true)
          .get();
      final list = snapshot.docs
          .map((document) => IssueBookModel.fromSnapshot(document))
          .toList();
      return list;
    } catch (e) {
      throw "something went wrong"; // Fix typo in the error message
    }
  }
}
