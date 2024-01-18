import 'package:eduventure/utils/colors.dart';
import 'package:flutter/material.dart';

class ReturnedCard extends StatefulWidget {
  final snap;
  const ReturnedCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<ReturnedCard> createState() => _ReturnedCardState();
}

class _ReturnedCardState extends State<ReturnedCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Container(
        padding: EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: gray02,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(4),
              child: Text(
                widget.snap['subjectName'],
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                widget.snap['bookName'],
                style: TextStyle(fontSize: 12),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Text(
                      "Book Id: ${widget.snap['bookId']}",
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4, right: 4),
                  child: Text(
                    widget.snap['authorName'],
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.end,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4, right: 4),
                  child: Text(
                    "Returned Date: ${widget.snap['returnedDate']}",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
