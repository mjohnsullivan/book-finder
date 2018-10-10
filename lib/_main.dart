import 'dart:async';

import 'package:book_finder/book.dart';
import 'package:flutter/material.dart';
import 'package:book_finder/widgets.dart';
import 'package:flutter/services.dart' show rootBundle;

const booksUrl = 'https://www.googleapis.com/books/v1/volumes?q=';
const potterQuery = '${booksUrl}harry+potter+inauthor:rowling';
const bhagatQuery = '${booksUrl}chetan%20bhagat+inauthor:bhagat';

void main() => runApp(BookFinderApp());

class BookFinderApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book Finder',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: BookFinderPage(),
    );
  }
}

class BookFinderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Finder'),
        leading: Icon(Icons.book),
      ),
      body: MyBookList(), //BookList(potterQuery),
    );
  }
}

class MyBookList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getBooks(),
        builder: (context, AsyncSnapshot<List<Book>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done)
            return ListView(
              children: snapshot.data.map((b) => BookTile(b)).toList(),
            );
          return Center(child: CircularProgressIndicator());
        });
  }
}

class BookTile extends StatelessWidget {
  BookTile(this.book);
  final Book book;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(book.title),
      subtitle: Text(book.author),
      leading: CircleAvatar(backgroundImage: NetworkImage(book.thumbnailUrl)),
    );
  }
}

Future<List<Book>> getBooks() async =>
    parseBookJson(await rootBundle.loadString('assets/bhagat.json'));
