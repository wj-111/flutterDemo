import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class BorrowBookPage extends StatefulWidget {
  @override
  _BorrowBookPageState createState() => _BorrowBookPageState();
}

class _BorrowBookPageState extends State<BorrowBookPage> {
  List<Book> bookList = [];

  @override
  void initState() {
    super.initState();
    getBookList();
  }

  Future<void> getBookList() async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://localhost:8080/mtsV2/book/getBookList?page=1&pageCount=100'),
        headers: {'Accept-Charset': 'utf-8'},
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(
            utf8.decode(response.bodyBytes)); // 使用utf8.decode解码响应的字节数据

        // print(responseData);
        // return;
        if (responseData['code'] == 200) {
          List<dynamic> bookData = responseData['data'];
          List<Book> books =
              bookData.map((data) => Book.fromJson(data)).toList();
          setState(() {
            bookList = books;
          });
        } else {
          // 处理错误响应
          // TODO: 处理错误响应的逻辑
          print('错误');
        }
      } else {
        // 处理错误响应
        // TODO: 处理错误响应的逻辑
      }
    } catch (e) {
      // 处理异常
      // TODO: 处理异常的逻辑
      print(e);
    }
  }

  Future<void> borrowBook(int bookId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('id') ?? '';

    String url =
        'http://localhost:8080/mtsV2/book/borrowBook?bookId=$bookId&userId=$userId';

    try {
      http.Response response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['code'] == 0) {
          // 借阅成功
          // TODO: 处理借阅成功的逻辑
        } else {
          // 处理错误响应
          // TODO: 处理错误响应的逻辑
        }
      } else {
        // 处理错误响应
        // TODO: 处理错误响应的逻辑
      }
    } catch (e) {
      // 处理异常
      // TODO: 处理异常的逻辑
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Borrow Book2'),
      ),
      body: ListView.builder(
        itemCount: bookList.length,
        itemBuilder: (context, index) {
          Book book = bookList[index];
          return ListTile(
            title: Text(book.name),
            subtitle: Text(book.author),
            trailing: ElevatedButton(
              onPressed: () {
                borrowBook(book.id);
              },
              child: Text('Borrow'),
            ),
          );
        },
      ),
    );
  }
}

class Book {
  final int id;
  final String name;
  final String author;
  final String info;
  final int num;

  Book({
    required this.id,
    required this.name,
    required this.author,
    required this.info,
    required this.num,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      name: json['name'],
      author: json['author'],
      info: json['info'],
      num: json['num'],
    );
  }
}
