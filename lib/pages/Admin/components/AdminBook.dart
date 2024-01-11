import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AdminBook extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new AdminBookState();
}

class AdminBookState extends State<AdminBook> {
  List<Map<String, dynamic>> bookList = []; // 书籍列表

  @override
  void initState() {
    super.initState();
    fetchBookList();
  }

  Future<void> fetchBookList() async {
    final response = await http.get(
      Uri.parse(
          'http://localhost:8080/mtsV2/book/getBookList?page=1&pageCount=100'),
      headers: {'Accept-Charset': 'utf-8'},
    );

    if (response.statusCode == 200) {
      final jsonData =
          jsonDecode(utf8.decode(response.bodyBytes)); // 使用utf8.decode解码响应的字节数据
      if (jsonData['code'] == 200) {
        setState(() {
          bookList = List<Map<String, dynamic>>.from(jsonData['data']);
        });
      } else {
        // 处理请求失败的情况
        print('请求失败：${jsonData['message']}');
      }
    } else {
      // 处理网络请求失败的情况
      print('网络请求失败：${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Admin Book"),
      ),
      body: bookList.isEmpty
          ? Center(child: CircularProgressIndicator())
          : new ListView.builder(
              itemCount: bookList.length,
              itemBuilder: (context, index) {
                final book = bookList[index];
                return ListTile(
                  title: Text(book['name'] ?? 'Unknown'),
                  subtitle: Text(book['author'] ?? ''),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      // 删除书籍
                      _deleteBook(book['id']);
                    },
                  ),
                  onTap: () {
                    // 修改书籍
                    _showEditDialog(book);
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 添加书籍
          _showAddDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  // 显示添加书籍对话框
  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String name = '';
        String author = '';
        String info = '';
        int num = 0;

        return AlertDialog(
          title: Text('添加书籍'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: '书名'),
                onChanged: (value) {
                  name = value;
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: '作者'),
                onChanged: (value) {
                  author = value;
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: '简介'),
                onChanged: (value) {
                  info = value;
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: '数量'),
                onChanged: (value) {
                  num = int.tryParse(value) ?? 0;
                },
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('确认'),
              onPressed: () async {
                await _addBook(name, author, info, num);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // 添加书籍
  Future<void> _addBook(
      String name, String author, String info, int num) async {
    final response = await http.post(
      Uri.parse('http://localhost:8080/mtsV2/book/addBook'),
      body: jsonEncode({
        'name': name,
        'author': author,
        'info': info,
        'num': num,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      if (jsonData['code'] == 0) {
        // 添加书籍成功
        await fetchBookList(); // 刷新书籍列表
      } else {
        // 处理请求失败的情况
        print('添加书籍失败：${jsonData['message']}');
      }
    } else {
      // 处理网络请求失败的情况
      print('网络请求失败：${response.statusCode}');
    }
  }

  // 显示编辑书籍对话框
  void _showEditDialog(Map<String, dynamic> book) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String name = book['name'] ?? '';
        String author = book['author'] ?? '';
        String info = book['info'] ?? '';
        int num = book['num'] ?? 0;

        return AlertDialog(
          title: Text('编辑书籍'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: '书名'),
                onChanged: (value) {
                  name = value;
                },
                controller: TextEditingController(text: name),
              ),
              TextField(
                decoration: InputDecoration(labelText: '作者'),
                onChanged: (value) {
                  author = value;
                },
                controller: TextEditingController(text: author),
              ),
              TextField(
                decoration: InputDecoration(labelText: '简介'),
                onChanged: (value) {
                  info = value;
                },
                controller: TextEditingController(text: info),
              ),
              TextField(
                decoration: InputDecoration(labelText: '数量'),
                onChanged: (value) {
                  num = int.tryParse(value) ?? 0;
                },
                keyboardType: TextInputType.number,
                controller: TextEditingController(text: num.toString()),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('确认'),
              onPressed: () async {
                await _updateBook(book['id'], name, author, info, num);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // 更新书籍信息
  Future<void> _updateBook(
      int id, String name, String author, String info, int num) async {
    final response = await http.post(
      Uri.parse('http://localhost:8080/mtsV2/book/updateBook'),
      body: jsonEncode({
        'id': id,
        'name': name,
        'author': author,
        'info': info,
        'num': num,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      if (jsonData['code'] == 0) {
        // 更新书籍信息成功
        await fetchBookList(); // 刷新书籍列表
      } else {
        // 处理请求失败的情况
        print('更新书籍信息失败：${jsonData['message']}');
      }
    } else {
      // 处理网络请求失败的情况
      print('网络请求失败：${response.statusCode}');
    }
  }

  // 删除书籍
  Future<void> _deleteBook(int id) async {
    final response = await http.post(
      Uri.parse('http://localhost:8080/mtsV2/book/deleteBook'),
      body: jsonEncode({
        'id': id,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      if (jsonData['code'] == 0) {
        // 删除书籍成功
        await fetchBookList(); // 刷新书籍列表
      } else {
        // 处理请求失败的情况
        print('删除书籍失败：${jsonData['message']}');
      }
    } else {
      // 处理网络请求失败的情况
      print('网络请求失败：${response.statusCode}');
    }
  }
}
