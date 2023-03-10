import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:term_project/model/book_model.dart';

class BookApi {
  static Future<List<BookModel>> getBookData() async {
    List<BookModel> books = [];
    const url =
        'https://www.googleapis.com/books/v1/volumes?q=subject:computer';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);
    final results = json['items'] as List<dynamic>;
    print('api started');

    if (books is List) {
      books = results.map((e) => BookModel.fromMap(e)).toList();
    } else {
      return [];
    }
    return books;
  }

  static Future<List<BookModel>> getDataByQuery({String q = "flutter"}) async {
    List<BookModel> books = [];
    var url = 'https://www.googleapis.com/books/v1/volumes?q=$q';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);
    final results = json['items'] as List<dynamic>;
    print('api started');

    if (books is List) {
      books = results.map((e) => BookModel.fromMap(e)).toList();
    } else {
      return [];
    }
    return books;
  }

  static Future<List<BookModel>> getDataBygenre({String q = "computer"}) async {
    List<BookModel> books = [];
    var url = 'https://www.googleapis.com/books/v1/volumes?q=subject:$q';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);
    final results = json['items'] as List<dynamic>;
    print('api started');

    if (books is List) {
      books = results.map((e) => BookModel.fromMap(e)).toList();
    } else {
      return [];
    }
    return books;
  }

  static Future<List<BookModel>> recommendedBooks(
      {required List<String> list}) async {
    var random = new Random();
    int element = random.nextInt(10);
    List<BookModel> books = [];
    for (int i = 0; i < 4; i++) {
      int randomNumber = element; // randNum = 3
      List<BookModel> bookModel = await BookApi.getDataByQuery(q: list[i]);
      books.add(bookModel[randomNumber]);
    }
    return books;
  }
}
