import 'dart:async';
import 'package:book_finder/data/book.dart';

import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

/// Fetches a list of books from an asset
Future<List<Book>> fetchAssetBooks() async =>
    parseBookJson(await rootBundle.loadString('assets/bhagat.json'));

/// Fetches a list of books from a Google Books api url
Future<List<Book>> fetchBooks(String url) async =>
    parseBookJson(await fetchBooksJson(url));

/// Fetches a json list of books from a Google Books api url
Future<String> fetchBooksJson(String url) async {
  final res = await http.get(url);
  if (res.statusCode == 200) {
    return res.body;
  } else {
    throw Exception('Error: ${res.statusCode}');
  }
}

Future<List<Book>> fetchCachedBooks(String url) async {
  final prefs = await SharedPreferences.getInstance();
  final booksStr = prefs.getString('cached_books');
  if (booksStr != null) {
    print('Cache hit');
    return parseBookJson(booksStr);
  } else {
    final booksStr = await fetchBooksJson(url);
    prefs.setString('cached_books', booksStr);
    print('Cache populated');
    return parseBookJson(booksStr);
  }
}

final hardCodedBooks = [
  Book(
    title: 'Harry Potter and the Philosopher\'s Stone',
    author: 'JK Rowling',
    thumbnailUrl:
        'http://books.google.com/books/content?id=x4beDQAAQBAJ&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api',
    googleUrl:
        'http://books.google.co.uk/books?id=x4beDQAAQBAJ&printsec=frontcover&dq=harry+potter+inauthor:rowling&hl=&cd=3&source=gbs_api',
  ),
  Book(
    title: 'Harry Potter and the Chamber of Secrets',
    author: 'JK Rowling',
    thumbnailUrl:
        'http://books.google.com/books/content?id=7Z_eDQAAQBAJ&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api',
    googleUrl:
        'http://books.google.co.uk/books?id=7Z_eDQAAQBAJ&printsec=frontcover&dq=harry+potter+inauthor:rowling&hl=&cd=8&source=gbs_api',
  ),
  Book(
    title: 'Harry Potter and the Prisoner of Azkaban',
    author: 'JK Rowling',
    thumbnailUrl:
        'http://books.google.com/books/content?id=y6DeDQAAQBAJ&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api',
    googleUrl:
        'http://books.google.co.uk/books?id=y6DeDQAAQBAJ&printsec=frontcover&dq=harry+potter+inauthor:rowling&hl=&cd=6&source=gbs_api',
  ),
  Book(
    title: 'Harry Potter and the Goblet of Fire',
    author: 'JK Rowling',
    thumbnailUrl:
        'http://books.google.com/books/content?id=N6DeDQAAQBAJ&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api',
    googleUrl:
        'http://books.google.co.uk/books?id=Q6TeDQAAQBAJ&printsec=frontcover&dq=harry+potter+inauthor:rowling&hl=&cd=5&source=gbs_api',
  ),
  Book(
    title: 'Harry Potter and the Order of the Phoenix',
    author: 'JK Rowling',
    thumbnailUrl:
        'http://books.google.com/books/content?id=FmwwDQAAQBAJ&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api',
    googleUrl:
        'http://books.google.co.uk/books?id=FmwwDQAAQBAJ&printsec=frontcover&dq=order+inauthor:rowling&hl=&cd=1&source=gbs_api',
  ),
  Book(
    title: 'Harry Potter and the Half-Blood Prince',
    author: 'JK Rowling',
    thumbnailUrl:
        'http://books.google.com/books/content?id=yofeDQAAQBAJ&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api',
    googleUrl:
        'http://books.google.co.uk/books?id=yofeDQAAQBAJ&printsec=frontcover&dq=harry+potter+inauthor:rowling&hl=&cd=9&source=gbs_api',
  ),
  Book(
    title: 'Harry Potter and the Deathly Hallows',
    author: 'JK Rowling',
    thumbnailUrl:
        'http://books.google.com/books/content?id=N6DeDQAAQBAJ&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api',
    googleUrl:
        'http://books.google.co.uk/books?id=N6DeDQAAQBAJ&printsec=frontcover&dq=harry+potter+inauthor:rowling&hl=&cd=4&source=gbs_api',
  ),
];
