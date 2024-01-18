import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduventure/widgets/applied_card.dart';
import 'package:eduventure/widgets/books_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../utils/colors.dart';

class AppliedBookScreen extends StatelessWidget {
  const AppliedBookScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("issueBooks")
          .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where("status", isEqualTo: "applied")
              .snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return  Center(
                child: CircularProgressIndicator(strokeWidth: 2, color: colorPrimary),
              );
            }
            return
              GridView.builder(
                itemCount: snapshot.data!.docs.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                primary: false,
                gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1, mainAxisExtent:  128),
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    child:AppliedCard(snap: snapshot.data!.docs[index].data())
                  );
                },
              );
          }),
    );
  }
}
