import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class FireStoreMethods {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;


  Future createTodayAttendance({
    required String year,
    required String month,
    required String date,
    required String classCode,
  }) async {

    await firebaseFirestore.collection("classroom").doc(classCode)
    .collection("Attendance").doc("$date-$month-$year")
        .set({
      "active": true,
      "date": "$date-$month-$year",
    });
  }

  // Future increaseClassCount({
  //   required String year,
  //   required String month,
  //   required String classCode,
  //   required int classCount,
  // }) async {
  //
  //   await firebaseFirestore.collection("classroom").doc(classCode)
  //       .collection("ClassCount").doc("$month-$year")
  //       .set({
  //     "month": "$month",
  //     "year": "$year",
  //     "classCount": "$classCount",
  //   });
  // }

  Future markAttendancePresent({
    required String classCode,
    required String uid,
  }) async {

    String year = DateTime.now().year.toString();
    String month = DateFormat('MMMM').format(DateTime.now());
    String date = DateFormat('d').format(DateTime.now());

    await firebaseFirestore.collection("classroom").doc(classCode)
        .collection("Attendance").doc("$date-$month-$year").collection("Students").doc(uid)
        .update({
      "attendance": "present",
    });
  }

  Future markAttendanceAbsent({
    required String classCode,
    required String uid,
  }) async {

    String year = DateTime.now().year.toString();
    String month = DateFormat('MMMM').format(DateTime.now());
    String date = DateFormat('d').format(DateTime.now());

    await firebaseFirestore.collection("classroom").doc(classCode)
        .collection("Attendance").doc("$date-$month-$year").collection("Students").doc(uid)
        .update({
      "attendance": "absent",
    });
  }

  Future<void> updateToken(String token) async {
    await firebaseFirestore.collection("users").doc(firebaseAuth.currentUser!.uid).update({
      "token": token,
    });
  }

  Future<List<String>> getAllUsersToken() async {
    List<String> usersToken = [];

    try {
      QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('users').get();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        // Check if the document exists and has the 'token' field
        if (doc.data() is Map<String, dynamic> &&
            (doc.data() as Map<String, dynamic>).containsKey('token')) {
          // Access the 'token' field from each document
          String userToken = doc['token'];

          // Add the user name to the list
          usersToken.add(userToken);
        }
      }

      print(usersToken);
      return usersToken;
    } catch (e) {
      print("Error getting user names: $e");
      return [];
    }
  }

  Future<List<String>> getAllUsersJoined(String classCode) async {
    List<String> usersUid = [];

    try {
      QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('classroom').doc(classCode).collection("students").get();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        // Check if the document exists and has the 'token' field
        if (doc.data() is Map<String, dynamic> &&
            (doc.data() as Map<String, dynamic>).containsKey('uid')) {
          // Access the 'token' field from each document
          String userUid = doc['uid'];

          // Add the user name to the list
          usersUid.add(userUid);
        }
      }

      print(usersUid);
      return usersUid;
    } catch (e) {
      print("Error getting user names: $e");
      return [];
    }
  }

  Future<List<String>> getUsersTokens(List<String> userUids) async {
    List<String> usersTokens = [];

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('users').get();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        if (doc.data() is Map<String, dynamic> &&
            (doc.data() as Map<String, dynamic>).containsKey('token')) {
          String uid = doc.id; // Assuming UID is stored as the document ID
          String userToken = doc['token'];

          // Check if the user's UID is in the list of desired UIDs
          if (userUids.contains(uid)) {
            usersTokens.add(userToken);
          }
        }
      }

      print(usersTokens);
      return usersTokens;
    } catch (e) {
      print("Error getting user tokens: $e");
      return [];
    }
  }


  Future<void> sendPushNotification(List<String> tokens, String body, String title) async {
    try {
      final response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
          'key=AAAA5prAEeo:APA91bETpDCr6udasjThb-PAj3iKSwvW0D8IqOBCL1_LPm1G5ycX1kjlWSO-1bzi0QjNh2_w0YzjFeQXOn6F7pGCnlKpfcJBZQewG6fUZRVlnVhB-Jq2WELAoKVODQOZpl3_plD5D6B0',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': body,
              'title': title,
              "android_channel_id": "Notice",
            },
            'priority': 'high',
            "registration_ids": tokens,
          },
        ),
      );
      print('done');
    } catch (e) {
      print("error push notification");
    }
  }

}
