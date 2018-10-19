import 'dart:convert';
import 'package:meta/meta.dart';

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

  String toString() =>
      'title: $title\nAuthor:$author\n' +
      'Thumbnail:$thumbnailUrl\nurl:$googleUrl';
}

List<Book> parseBookJson(String jsonStr) {
  final jsonMap = json.decode(jsonStr);
  final jsonList = (jsonMap['items'] as List);
  return jsonList.map((jsonBook) {
    final thumbnailUrl = (jsonBook['volumeInfo'].containsKey('imageLinks') &&
            jsonBook['volumeInfo']['imageLinks'].containsKey('smallThumbnail'))
        ? jsonBook['volumeInfo']['imageLinks']['thumbnail']
        : null;
    final book = Book(
      title: jsonBook['volumeInfo']['title'],
      author: (jsonBook['volumeInfo']['authors'] as List).join(', '),
      thumbnailUrl: thumbnailUrl,
      googleUrl: jsonBook['volumeInfo']['previewLink'],
    );
    return book;
  }).toList();
}
