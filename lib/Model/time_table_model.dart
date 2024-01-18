import 'package:cloud_firestore/cloud_firestore.dart';

class TimetableModel {
  String id;
  String semester;
  String branch;
  String day;
  String subName;
  String subCode;
  String facultyUid;
  String startTime;
  String endTime;
  String facultyName;

  TimetableModel({
    required this.id,
    required this.semester,
    required this.branch,
    required this.day,
    required this.subName,
    required this.subCode,
    required this.facultyUid,
    required this.startTime,
    required this.endTime,
    required this.facultyName,
  });

  // Static method to create an instance with empty values
  static TimetableModel empty() => TimetableModel(
    id: '',
    semester: '',
    branch: '',
    day: '',
    subName: '',
    subCode: '',
    facultyUid: '',
    startTime: '',
    endTime: '',
    facultyName: '',
  );

  // Method to convert the object to a Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'semester': semester,
      'branch': branch,
      'day': day,
      'subName': subName,
      'subCode': subCode,
      'facultyUid': facultyUid,
      'startTime': startTime,
      'endTime': endTime,
      'facultyName': facultyName,
    };
  }

  // Factory method to create an instance from a Firestore DocumentSnapshot
  factory TimetableModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;

      return TimetableModel(
        id: data['id'] ?? '',
        semester: data['semester'] ?? '',
        branch: data['branch'] ?? '',
        day: data['day'] ?? '',
        subName: data['subName'] ?? '',
        subCode: data['subCode'] ?? '',
        facultyUid: data['facultyUid'] ?? '',
        startTime: data['startTime'] ?? '',
        endTime: data['endTime'] ?? '',
        facultyName: data['facultyName'] ?? '',
      );
    } else {
      return TimetableModel.empty();
    }
  }
}
