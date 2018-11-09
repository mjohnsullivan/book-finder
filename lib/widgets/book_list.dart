import 'package:flutter/material.dart';

import 'package:book_finder/widgets/book_tile.dart';
import 'package:book_finder/book.dart';

class BookListWithAppBar extends StatelessWidget {
  BookListWithAppBar(this.books);
  final List<Book> books;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text('Book Finder'),
            backgroundColor: Colors.green,
            forceElevated: true,
            floating: true,
            actions: [
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {},
              )
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              books.map((b) => BookTile(b)).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
