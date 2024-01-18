import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Model/books_model.dart';

class BooksRepository extends GetxController {
  static BooksRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<List<BooksModel>> getAllBooks() async {
    try {
      final snapshot = await _db
          .collection("books") // Adjust collection name
          .orderBy("bookId", descending: true)
          .get();
      final list = snapshot.docs
          .map((document) => BooksModel.fromSnapshot(document))
          .toList();
      return list;
    } catch (e) {
      throw "something went wrong"; // Fix typo in the error message
    }
  }
}
