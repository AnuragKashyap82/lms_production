import 'package:eduventure/Model/books_model.dart';
import 'package:eduventure/screens/book_view_screen.dart';
import 'package:eduventure/utils/colors.dart';
import 'package:flutter/material.dart';

class BooksCard extends StatefulWidget {
  final BooksModel booksModel;
  const BooksCard({Key? key, required this.booksModel}) : super(key: key);

  @override
  State<BooksCard> createState() => _BooksCardState();
}

class _BooksCardState extends State<BooksCard> {
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
                widget.booksModel.subjectName,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                widget.booksModel.bookName,
                style: TextStyle(fontSize: 12,),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(
              height: 8,
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
                      "Book Id: ${widget.booksModel.bookId}",
                      style:
                      TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4, right: 4),
                  child: Text(
                    widget.booksModel.authorName,
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
