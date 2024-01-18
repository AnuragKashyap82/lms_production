import 'package:cloud_firestore/cloud_firestore.dart';

class ClassroomModel {
  String classCode;
  String className;
  String subjectName;
  String uid;
  String name;

  ClassroomModel({
    required this.classCode,
    required this.className,
    required this.subjectName,
    required this.uid,
    required this.name,
  });

  // Static method to create an instance with empty values
  static ClassroomModel empty() => ClassroomModel(
    classCode: '',
    className: '',
    subjectName: '',
    uid: '',
    name: '',
  );

  // Method to convert the object to a Map
  Map<String, dynamic> toJson() {
    return {
      'classCode': classCode,
      'className': className,
      'subjectName': subjectName,
      'uid': uid,
      'name': name,
    };
  }

  // Factory method to create an instance from a Firestore DocumentSnapshot
  factory ClassroomModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;

      return ClassroomModel(
        classCode: data['classCode'] ?? '',
        className: data['className'] ?? '',
        subjectName: data['subjectName'] ?? '',
        uid: data['uid'] ?? '',
        name: data['name'] ?? '',
      );
    } else {
      return ClassroomModel.empty();
    }
  }
}
