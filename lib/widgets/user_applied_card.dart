import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduventure/Model/issue_book_model.dart';
import 'package:eduventure/screens/user_all_applied_books.dart';
import 'package:eduventure/utils/global_variables.dart';
import 'package:flutter/material.dart';

import '../utils/colors.dart';


class UserAppliedCard extends StatefulWidget {
  final IssueBookModel issueBookModel;
  const UserAppliedCard({Key? key, required this.issueBookModel}) : super(key: key);

  @override
  State<UserAppliedCard> createState() => _UserAppliedCardState();
}

class _UserAppliedCardState extends State<UserAppliedCard> {
  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
          child: Container(
            height: 72,
      decoration: BoxDecoration(
          color: gray02,
          borderRadius: BorderRadius.circular(12),
      ),
      child: isLoading
          ? Center(child: CircularProgressIndicator(strokeWidth: 2, color: colorPrimary))
          : ListTile(
          leading: widget.issueBookModel.photoUrl != ""?CircleAvatar(
            radius: 26,
            backgroundImage: NetworkImage(widget.issueBookModel.photoUrl),
          ):Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: colorWhite,
              shape: BoxShape.circle
            ),
            child: Center(child: Icon(Icons.person, color: colorPrimary,size: 26,)),
          ),
          title: Text(
            widget.issueBookModel.name,
            style: TextStyle(color: colorBlack,fontSize: 12, fontWeight: FontWeight.w700),
          ),
          subtitle: Text(
            widget.issueBookModel.studentId,
            style: TextStyle(color: Colors.black.withOpacity(0.5), fontSize: 12),
          ),
      ),
    ),
        );
  }
}
