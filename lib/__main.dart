import 'package:flutter/material.dart';

const url =
    'https://www.googleapis.com/books/v1/volumes?q=harry+potter+inauthor:rowling';

void main() => runApp(Center(
        child: Text(
      'Hello World',
      textDirection: TextDirection.ltr,
    )));

/*
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(body: Center(child: Text('Hello World'))),
    );
  }
}
*/
