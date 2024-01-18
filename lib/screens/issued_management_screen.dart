import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduventure/screens/user_all_issued_book_screen.dart';
import 'package:eduventure/widgets/user_applied_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../Controller/issue_book_controller.dart';
import '../utils/colors.dart';

class IssuedManagementScreen extends StatefulWidget {
  const IssuedManagementScreen({Key? key}) : super(key: key);

  @override
  State<IssuedManagementScreen> createState() => _IssuedManagementScreenState();
}

class _IssuedManagementScreenState extends State<IssuedManagementScreen> {

  TextEditingController _searchKeyController = TextEditingController();
  final issueBookControllerController = Get.put(IssueBookController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4).copyWith(bottom: 0),
            child: SizedBox(
              height: 52,
              child: Center(
                child: TextField(
                  controller: _searchKeyController,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  autofocus: false,
                  onChanged: (value) {
                    setState(() {
                      issueBookControllerController.searchUserIssued(value);
                    });
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                    prefixIcon: Icon(Icons.search_off_sharp, color: colorPrimary,),
                    hintText: "Search by Student Id, name....",
                    filled: true,
                    fillColor: gray02,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(26),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Obx(() {
            if (issueBookControllerController.isLoading.value)
              return  Center(
                child:
                CircularProgressIndicator(strokeWidth: 2, color: colorPrimary),
              );
            if (issueBookControllerController.allIssuedBooks.isEmpty) {
              return Center(
                child: Text(
                  "No Issued Books",
                  style: TextStyle(
                    fontSize: 14,
                    color: colorBlack,
                  ),
                ),
              );
            }
            return ListView.builder(
              itemCount: _searchKeyController.text.isNotEmpty
                  ? issueBookControllerController.searchResults.length
                  : issueBookControllerController.allIssuedBooks.length,
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemBuilder: (_, index) {
                final issuedBooks = _searchKeyController.text.isNotEmpty
                    ? issueBookControllerController.searchResults[index]
                    : issueBookControllerController.allIssuedBooks[index];
                return Container(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserAllIssuedBooksScreen(
                            issueBookModel:issuedBooks,
                          ),
                        ),
                      );
                    },
                    child: UserAppliedCard(
                      issueBookModel: issuedBooks,
                    ),
                  ),
                );
              },
            );
          }),
        ],
      ),
    );
  }
}
