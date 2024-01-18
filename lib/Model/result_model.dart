import 'package:cloud_firestore/cloud_firestore.dart';

class ResultModel {
  String semester;
  String resultYear;
  String branch;
  String resultUrl;
  String dateTime;
  String uid;

  ResultModel({
    required this.semester,
    required this.resultYear,
    required this.branch,
    required this.resultUrl,
    required this.dateTime,
    required this.uid,
  });

  // Static method to create an instance with empty values
  static ResultModel empty() => ResultModel(
    semester: '',
    resultYear: '',
    branch: '',
    resultUrl: '',
    dateTime: '',
    uid: '',
  );

  // Method to convert the object to a Map
  Map<String, dynamic> toJson() {
    return {
      'semester': semester,
      'resultYear': resultYear,
      'branch': branch,
      'resultUrl': resultUrl,
      'dateTime': dateTime,
      'uid': uid,
    };
  }

  // Factory method to create an instance from a Firestore DocumentSnapshot
  factory ResultModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;

      return ResultModel(
        semester: data['semester'] ?? '',
        resultYear: data['resultYear'] ?? '',
        branch: data['branch'] ?? '',
        resultUrl: data['resultUrl'] ?? '',
        dateTime: data['dateTime'] ?? '',
        uid: data['uid'] ?? '',
      );
    } else {
      return ResultModel.empty();
    }
  }
}
