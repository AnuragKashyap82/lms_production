import 'package:cloud_firestore/cloud_firestore.dart';

class NoticeModel {
  String noticeTitle;
  String noticeNo;
  String noticeId;
  String noticeUrl;
  String dateTime;
  String uid;

  NoticeModel({
    required this.noticeTitle,
    required this.noticeNo,
    required this.noticeId,
    required this.noticeUrl,
    required this.dateTime,
    required this.uid,
  });

  // Static method to create an instance with empty values
  static NoticeModel empty() => NoticeModel(
    noticeTitle: '',
    noticeNo: '',
    noticeId: '',
    noticeUrl: '',
    dateTime: '',
    uid: '',
  );

  // Method to convert the object to a Map
  Map<String, dynamic> toJson() {
    return {
      'noticeTitle': noticeTitle,
      'noticeNo': noticeNo,
      'noticeId': noticeId,
      'noticeUrl': noticeUrl,
      'dateTime': dateTime,
      'uid': uid,
    };
  }

  // Factory method to create an instance from a Firestore DocumentSnapshot
  factory NoticeModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;

      return NoticeModel(
        noticeTitle: data['noticeTitle'] ?? '',
        noticeNo: data['noticeNo'] ?? '',
        noticeId: data['noticeId'] ?? '',
        noticeUrl: data['noticeUrl'] ?? '',
        dateTime: data['dateTime'] ?? '',
        uid: data['uid'] ?? '',
      );
    } else {
      return NoticeModel.empty();
    }
  }
}
