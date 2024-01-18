import 'package:cloud_firestore/cloud_firestore.dart';

class BooksModel {
  String authorName;
  String bookId;
  String bookName;
  String subjectName;
  String bookQty;
  String timestamp;
  String dateTime;
  String uid;

  BooksModel({
    required this.authorName,
    required this.bookId,
    required this.bookName,
    required this.subjectName,
    required this.bookQty,
    required this.timestamp,
    required this.dateTime,
    required this.uid,
  });

  // Static method to create an instance with empty values
  static BooksModel empty() => BooksModel(
    authorName: '',
    bookId: '',
    bookName: '',
    subjectName: '',
    bookQty: '',
    timestamp: '',
    dateTime: '',
    uid: '',
  );

  // Method to convert the object to a Map
  Map<String, dynamic> toJson() {
    return {
      'authorName': authorName,
      'bookId': bookId,
      'bookName': bookName,
      'subjectName': subjectName,
      'bookQty': bookQty,
      'timestamp': timestamp,
      'dateTime': dateTime,
      'uid': uid,
    };
  }

  // Factory method to create an instance from a Firestore DocumentSnapshot
  factory BooksModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;

      return BooksModel(
        authorName: data['authorName'] ?? '',
        bookId: data['bookId'] ?? '',
        bookName: data['bookName'] ?? '',
        subjectName: data['subjectName'] ?? '',
        bookQty: data['bookQty'] ?? '',
        timestamp: data['timestamp'] ?? '',
        dateTime: data['dateTime'] ?? '',
        uid: data['uid'] ?? '',
      );
    } else {
      return BooksModel.empty();
    }
  }
}
