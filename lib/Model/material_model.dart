import 'package:cloud_firestore/cloud_firestore.dart';

class MaterialModel {
  String semester;
  String branch;
  String subName;
  String subTopic;
  String materialUrl;
  String materialId;
  String dateTime;
  String uid;

  MaterialModel({
    required this.semester,
    required this.branch,
    required this.subName,
    required this.subTopic,
    required this.materialUrl,
    required this.materialId,
    required this.dateTime,
    required this.uid,
  });

  // Static method to create an instance with empty values
  static MaterialModel empty() => MaterialModel(
    semester: '',
    branch: '',
    subName: '',
    subTopic: '',
    materialUrl: '',
    materialId: '',
    dateTime: '',
    uid: '',
  );

  // Method to convert the object to a Map
  Map<String, dynamic> toJson() {
    return {
      'semester': semester,
      'branch': branch,
      'subName': subName,
      'subTopic': subTopic,
      'materialUrl': materialUrl,
      'materialId': materialId,
      'dateTime': dateTime,
      'uid': uid,
    };
  }

  // Factory method to create an instance from a Firestore DocumentSnapshot
  factory MaterialModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;

      return MaterialModel(
        semester: data['semester'] ?? '',
        branch: data['branch'] ?? '',
        subName: data['subName'] ?? '',
        subTopic: data['subTopic'] ?? '',
        materialUrl: data['materialUrl'] ?? '',
        materialId: data['materialId'] ?? '',
        dateTime: data['dateTime'] ?? '',
        uid: data['uid'] ?? '',
      );
    } else {
      return MaterialModel.empty();
    }
  }
}
