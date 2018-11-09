import 'package:flutter/material.dart';

import 'package:book_finder/widgets/book_list.dart';
import 'package:book_finder/data/book.dart';
import 'package:book_finder/data/books_api.dart';

class BookListPage extends StatelessWidget {
  BookListPage(this.url);
  final String url;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: fetchBooks(url),
        builder: (context, AsyncSnapshot<List<Book>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return BookListWithAppBar(snapshot.data);
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}
