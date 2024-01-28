import 'package:eduventure/Controller/books_controller.dart';
import 'package:eduventure/screens/add_books_screen.dart';
import 'package:eduventure/screens/book_view_screen.dart';
import 'package:eduventure/screens/library_management_screen.dart';
import 'package:eduventure/screens/my_books_screen.dart';
import 'package:eduventure/utils/colors.dart';
import 'package:eduventure/widgets/books_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class LibraryScreen extends StatefulWidget {
  final String userType;
  const LibraryScreen({Key? key, required this.userType}) : super(key: key);

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  BooksController booksController = Get.find();
  bool _isAdmin = false;
  bool _isLibrarian = false;
  bool _isUser = false;

  TextEditingController _searchKeyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (widget.userType == "admin") {
      setState(() {
        _isAdmin = true;
      });
    } else if (widget.userType == "librarian") {
      setState(() {
        _isLibrarian = true;
      });
    } else {
      setState(() {
        _isUser = true;
      });
    }

    double size = MediaQuery.of(context).size.width;
    int _count = 2;

    setState(() {
      if (size < 300) {
        _count = 2;
      } else if (size > 300 && size < 400) {
        _count = 2;
      } else if (size > 400 && size < 500) {
        _count = 3;
      } else if (size > 500 && size < 600) {
        _count = 3;
      } else if (size > 600 && size < 700) {
        _count = 4;
      } else if (size > 700 && size < 800) {
        _count = 5;
      } else if (size > 800 && size < 900) {
        _count = 5;
      } else if (size > 900 && size < 1000) {
        _count = 6;
      } else if (size > 1000 && size < 1100) {
        _count = 6;
      } else if (size > 1100 && size < 1200) {
        _count = 7;
      } else if (size > 1200 && size < 1300) {
        _count = 7;
      } else if (size > 1300 && size < 1400) {
        _count = 8;
      } else if (size > 1400 && size < 1500) {
        _count = 8;
      } else if (size > 1500 && size < 1600) {
        _count = 9;
      }
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorPrimary,
        elevation: 0,
        iconTheme: IconThemeData(color: colorBlack),
        title: Text(
          "Library",
          style: TextStyle(
              fontSize: 16, color: colorBlack, fontWeight: FontWeight.bold),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => MyBooksScreen()));
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.library_books,
                size: 18,
                color: colorBlack,
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
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
                        booksController.searchBooks(value);
                      });
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                      prefixIcon: Icon(Icons.search_off_sharp, color: colorPrimary,),
                      hintText: "Search by Sub name, Book name, id....",
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
            SizedBox(
              child: Obx(() {
                if (booksController.isLoading.value)
                  return  Center(
                    child:
                    CircularProgressIndicator(strokeWidth: 2, color: colorPrimary),
                  );
                if (booksController.allBooks.isEmpty) {
                  return Center(
                    child: Text(
                      "No Books in library",
                      style: TextStyle(
                        fontSize: 14,
                        color: colorBlack,
                      ),
                    ),
                  );
                }
                return GridView.builder(
                  itemCount: _searchKeyController.text.isNotEmpty
                      ? booksController.searchResults.length
                      : booksController.allBooks.length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  primary: false,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: _count, mainAxisExtent: 120),
                  itemBuilder: (BuildContext context, int index) {
                    final books = _searchKeyController.text.isNotEmpty
                        ? booksController.searchResults[index]
                        : booksController.allBooks[index];
                    return Container(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      BookViewScreen(booksModel: books)));
                        },
                        child: BooksCard(
                            booksModel: books
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: _isAdmin
          ?
      SpeedDial(
        direction: SpeedDialDirection.up,
        icon: Icons.add,
        activeIcon: Icons.close,
        backgroundColor: colorPrimary,
        foregroundColor: colorWhite,
        activeBackgroundColor: colorPrimary,
        activeForegroundColor: colorWhite,
        visible: true,
        closeManually: false,
        curve: Curves.bounceIn,
        overlayColor: colorBlack,
        overlayOpacity: 0.1,
        elevation: 12.0,
        shape: StadiumBorder(),
        children: [
          SpeedDialChild(
            child: Icon(Icons.edit_outlined),
            backgroundColor: colorPrimary,
            foregroundColor: colorWhite,
            shape: StadiumBorder(),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LibraryManagementScreen()));
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.add_outlined),
            backgroundColor: colorPrimary,
            foregroundColor: colorWhite,
            shape: StadiumBorder(),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddBooksScreen()));
            },
          ),
        ],
      )
          : _isLibrarian
          ?
      SpeedDial(
        direction: SpeedDialDirection.up,
        icon: Icons.add,
        activeIcon: Icons.close,
        backgroundColor: colorPrimary,
        foregroundColor: colorWhite,
        activeBackgroundColor: colorPrimary,
        activeForegroundColor: colorWhite,
        visible: true,
        closeManually: false,
        curve: Curves.bounceIn,
        overlayColor: colorBlack,
        overlayOpacity: 0.1,
        elevation: 12.0,
        shape: StadiumBorder(),
        children: [
          SpeedDialChild(
            child: Icon(Icons.edit_outlined),
            backgroundColor: colorPrimary,
            foregroundColor: colorWhite,
            shape: StadiumBorder(),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LibraryManagementScreen()));
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.add_outlined),
            backgroundColor: colorPrimary,
            foregroundColor: colorWhite,
            shape: StadiumBorder(),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddBooksScreen()));
            },
          ),
        ],
      )
          : SizedBox(),
    );
  }
}
