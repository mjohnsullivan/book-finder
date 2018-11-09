import 'dart:ui';

import 'package:book_finder/data/book.dart';
import 'package:book_finder/data/books_api.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

const booksUrl = 'https://www.googleapis.com/books/v1/volumes?maxResults=20&q=';
const potterQuery = '${booksUrl}intitle:harry+potter+inauthor:rowling';
const bhagatQuery = '${booksUrl}chetan%20bhagat+inauthor:bhagat';
const banksQuery = '${booksUrl}iain%20banks+inauthor:iain%20m%20banks';

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
      body: MyBookList(banksQuery), //BookList(potterQuery),
    );
  }
}

class MyBookList extends StatelessWidget {
  MyBookList(this.url);
  final String url;

  @override
  Widget build(BuildContext context) {
    final bookList = fetchBooks(url);
    return FutureBuilder(
        future: bookList,
        builder: (context, AsyncSnapshot<List<Book>> snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: snapshot.data.map((b) => BookTile(b)).toList(),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
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
      leading: CircleAvatar(
        backgroundImage:
            book.thumbnailUrl != null ? NetworkImage(book.thumbnailUrl) : null,
        child: book.thumbnailUrl == null ? Text(book.title[0]) : null,
      ),
      trailing: IconButton(
        icon: Icon(Icons.book),
        onPressed: () => _navigateToUrl(book.googleUrl, context),
      ),
    );
  }

  void _navigateToUrl(String url, BuildContext context) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Unable to launch URL')));
    }
  }
}

class MyBookDetailsPage extends StatelessWidget {
  MyBookDetailsPage(this.book);
  final Book book;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(book.title)),
      body: StackedBookDetails(book),
    );
  }
}

class StackedBookDetails extends StatelessWidget {
  StackedBookDetails(this.book);
  final Book book;
  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Positioned.fill(
          child: Image.network(
        book.thumbnailUrl,
        fit: BoxFit.fill,
      )),
      BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
        child: Container(
          decoration: BoxDecoration(color: Colors.black54),
        ),
      ),
      FractionalTranslation(
        translation: const Offset(1.0, 1.0),
        child: Image.network(book.thumbnailUrl),
      ),
      Positioned(
        top: 10.0,
        left: 10.0,
        child: Container(
          width: 300.0,
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Text(
            book.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24.0,
            ),
          ),
        ),
      ),
      Positioned(
          bottom: 10.0,
          right: 100.0,
          child: Text(
            book.author,
            style: TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                fontWeight: FontWeight.w700),
          )),
    ]);
  }
}

class BookDetails extends StatelessWidget {
  BookDetails(this.book);
  final Book book;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Image.network(book.thumbnailUrl),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Text(book.title),
            ),
            SizedBox(height: 25.0),
            Text(
              book.author,
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ]),
    );
  }
}
