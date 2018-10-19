import 'package:book_finder/book.dart';
import 'package:book_finder/books_api.dart';
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

class BookDetailsOverlay extends StatelessWidget {
  BookDetailsOverlay(this.book);
  final Book book;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.network(
            book.thumbnailUrl,
            fit: BoxFit.fill,
          ),
        ),
        Positioned(
          top: 30.0,
          left: 30.0,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black45,
              borderRadius: BorderRadius.circular(10.0),
            ),
            width: 250.0,
            child: Text(
              book.title,
              maxLines: 2,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.0,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 50.0,
          right: 30.0,
          child: Text(book.author,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24.0,
              )),
        ),
      ],
    );
  }
}
