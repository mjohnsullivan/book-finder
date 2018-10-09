import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Book {
  final String title;
  final String author;
  final String thumbnailUrl;
  final String googleUrl;

  Book(
      {@required this.title,
      @required this.author,
      this.thumbnailUrl,
      this.googleUrl})
      : assert(title != null),
        assert(author != null);
}

/// Fetches a list of books from an asset
Future<List<Book>> fetchAssetBooks() async =>
    _parseBookJson(await rootBundle.loadString('assets/config.json'));

/// Fetches a list of books from a Google Books api url
Future<List<Book>> fetchBooks(String url) async =>
    _parseBookJson(await fetchBooksJson(url));

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
    return _parseBookJson(booksStr);
  } else {
    final booksStr = await fetchBooksJson(url);
    prefs.setString('cached_books', booksStr);
    print('Cache populated');
    return _parseBookJson(booksStr);
  }
}

List<Book> _parseBookJson(String jsonStr) {
  final jsonMap = json.decode(jsonStr);
  final jsonList = (jsonMap['items'] as List);
  return jsonList.map((jsonBook) {
    final thumbnailUrl = (jsonBook['volumeInfo'].containsKey('imageLinks') &&
            jsonBook['volumeInfo']['imageLinks'].containsKey('smallThumbnail'))
        ? jsonBook['volumeInfo']['imageLinks']['smallThumbnail']
        : null;
    return Book(
      title: jsonBook['volumeInfo']['title'],
      author: (jsonBook['volumeInfo']['authors'] as List).join(', '),
      thumbnailUrl: thumbnailUrl,
      googleUrl: jsonBook['volumeInfo']['previewLink'],
    );
  }).toList();
}
