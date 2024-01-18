import 'package:get/get.dart';

import '../Model/books_model.dart';
import '../Repository/books_repository.dart';

class BooksController extends GetxController {
  static BooksController get instance => Get.find();

  final isLoading = false.obs;
  final _booksRepository = Get.put(BooksRepository());
  RxList<BooksModel> allBooks = <BooksModel>[].obs;
  RxList<BooksModel> searchResults = <BooksModel>[].obs; // New list for search results

  @override
  void onInit() {
    fetchBooks();
    super.onInit();
  }

  Future<void> fetchBooks() async {
    try {
      isLoading.value = true;
      final books = await _booksRepository.getAllBooks();
      allBooks.assignAll(books);
    } catch (e) {
      print(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void searchBooks(String searchText) {
    if (searchText.isEmpty) {
      // If search text is empty, show all books
      searchResults.clear();
    } else {
      // Perform a local search in the existing books list
      searchResults.assignAll(allBooks
          .where((book) =>
      book.bookName.toLowerCase().contains(searchText.toLowerCase()) ||
          book.subjectName.toLowerCase().contains(searchText.toLowerCase()) ||
          book.bookId.toLowerCase().contains(searchText.toLowerCase()) ||
          book.authorName.toLowerCase().contains(searchText.toLowerCase()))
          .toList());
    }
  }
}
