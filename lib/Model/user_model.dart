import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String name;
  String email;
  String completeAddress;
  String dob;
  String regNo;
  String branch;
  String semester;
  String session;
  String seatType;
  String photoUrl;
  String userType;
  String studentId;
  String phoneNo;
  String uid;

  UserModel({
    required this.name,
    required this.email,
    required this.completeAddress,
    required this.dob,
    required this.regNo,
    required this.branch,
    required this.semester,
    required this.session,
    required this.seatType,
    required this.photoUrl,
    required this.userType,
    required this.studentId,
    required this.phoneNo,
    required this.uid,

  });

  // Static method to create an instance with empty values
  static UserModel empty() => UserModel(
    name: '',
    email: '',
    completeAddress: '',
    dob: '',
    regNo: '',
    branch: '',
    semester: '',
    session: '',
    seatType: '',
    photoUrl: '',
    userType: '',
    studentId: '',
    phoneNo: '',
    uid: '',
  );

  // Method to convert the object to a Map
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'completeAddress': completeAddress,
      'dob': dob,
      'regNo': regNo,
      'branch': branch,
      'semester': semester,
      'session': session,
      'seatType': seatType,
      'photoUrl': photoUrl,
      'userType': userType,
      'studentId': studentId,
      'phoneNo': phoneNo,
      'uid': uid,
    };
  }

  factory UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return UserModel(
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      completeAddress: data['completeAddress'] ?? '',
      dob: data['dob'] ?? '',
      regNo: data['regNo'] ?? '',
      branch: data['branch'] ?? '',
      semester: data['semester'] ?? '',
      session: data['session'] ?? '',
      seatType: data['seatType'] ?? '',
      photoUrl: data['photoUrl'] ?? '',
      userType: data['userType'] ?? '',
      studentId: data['studentId'] ?? '',
      phoneNo: data['phoneNo'] ?? '',
      uid: data['uid'] ?? '',

    );
  }
}
