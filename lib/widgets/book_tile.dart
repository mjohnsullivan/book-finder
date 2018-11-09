import 'package:flutter/material.dart';

import 'package:book_finder/data/book.dart';
import 'package:book_finder/widgets/book_details_page.dart';

import 'package:url_launcher/url_launcher.dart';

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

void _navigateToUrl(String url, BuildContext context) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text('Unable to Launch URL'),
    ));
  }
}

void _navigateToDetailsPage(Book book, BuildContext context) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => BookDetailsPage(book),
  ));
}
