import 'package:flutter/material.dart';

import 'package:book_finder/widgets/book_list_page.dart';

const booksUrl = 'https://www.googleapis.com/books/v1/volumes?maxResults=20&q=';
const potterQuery = '${booksUrl}intitle:harry+potter+inauthor:rowling';
const bhagatQuery = '${booksUrl}chetan%20bhagat+inauthor:bhagat';
const endeQuery = '${booksUrl}michael%20ende+inauthor:ende';
const banksQuery = '${booksUrl}iain%20banks+inauthor:iain%20m%20banks';

void main() => runApp(BookFinderApp());

class BookFinderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book Finder',
      theme: ThemeData(primarySwatch: Colors.green),
      home: BookFinderPage(),
    );
  }
}

class BookFinderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: SafeArea(child: BookListPage(potterQuery)),
    );
  }
}
