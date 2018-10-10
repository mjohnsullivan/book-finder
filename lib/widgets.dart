import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:book_finder/book.dart';
import 'package:book_finder/books_api.dart';

class BookList extends StatelessWidget {
  BookList(this.url);
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
              return ListView(
                  children: snapshot.data.map((b) => BookTile(b)).toList());
            }
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}

class BookTile extends StatelessWidget {
  final Book book;
  BookTile(this.book);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage:
            book.thumbnailUrl != null ? NetworkImage(book.thumbnailUrl) : null,
      ),
      title: Text(book.title, maxLines: 2, overflow: TextOverflow.ellipsis),
      subtitle: Text(book.author, overflow: TextOverflow.ellipsis),
      onTap: () => _navigateToDetailsPage(book, context),
      trailing: IconButton(
        icon: Icon(Icons.book),
        onPressed: () => book.googleUrl != null
            ? _navigateToUrl(book.googleUrl, context)
            : null,
      ),
    );
  }
}

void _navigateToDetailsPage(Book book, BuildContext context) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => BookDetailsPage(book),
  ));
}

void _navigateToUrl(String url, BuildContext context) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text('Unable to Launch URL'),
    ));
  }
}

class BookDetailsPage extends StatelessWidget {
  final Book book;
  BookDetailsPage(this.book);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(book.title)),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: BookDetails(book),
      ),
    );
  }
}

class BookDetails extends StatelessWidget {
  final Book book;
  BookDetails(this.book);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.network(book.thumbnailUrl),
          SizedBox(height: 10.0),
          Text(book.title),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(book.author,
                style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}
