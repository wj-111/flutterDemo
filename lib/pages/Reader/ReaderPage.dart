import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'components/BorrowBook.dart'; // 导入借书页面
import 'components/ReturnBook.dart'; // 导入借书页面

class ReaderPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ReaderPageState();
}

class _ReaderPageState extends State<ReaderPage> {
  String username = '未命名'; // 用户名
  String phone = ''; // 电话号码
  String id = ''; // 用户ID

  @override
  void initState() {
    super.initState();
    loadUserInfo();
  }

  Future<void> loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('phone') ?? 'John Doe';
      phone = prefs.getString('phone') ?? '';
      id = prefs.getString('id') ?? '';
    });
  }

  Future<void> updateUser() async {
    TextEditingController phoneController = TextEditingController(text: phone);
    TextEditingController passwordController = TextEditingController();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('修改用户信息'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: '手机',
                ),
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: '密码',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('取消'),
            ),
            TextButton(
              onPressed: () {
                // 获取输入的电话号码和密码
                String newPhone = phoneController.text;
                String newPassword = passwordController.text;

                // 调用接口更新用户信息
                updateUserInformation(newPhone, newPassword)
                    .then((value) => Navigator.of(context).pop());
              },
              child: Text('确认'),
            ),
          ],
        );
      },
    );
  }

  Future<void> handleResponse(BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('操作成功'),
        duration: Duration(seconds: 2), // 显示时长
      ),
    );
  }

  Future<void> updateUserInformation(
      String newPhone, String newPassword) async {
    // 发送 POST 请求到 http://localhost:8080//mtsV2/user/updateUser
    // 请求体为 { id: '', phone: '', password: '' }
    // 使用 newPhone 替换原有的电话号码，使用 newPassword 替换原有的密码

    String url = 'http://localhost:8080/mtsV2/user/updateUser';
    Map<String, String> headers = {'Content-Type': 'application/json'};
    Map<String, dynamic> body = {
      'id': id,
      'phone': newPhone,
      'password': newPassword
    };

    try {
      http.Response response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        handleResponse(context);
      } else {
        // 处理错误响应
        // TODO: 处理错误响应的逻辑
      }
    } catch (e) {
      // 处理异常
      // TODO: 处理异常的逻辑
    }
  }

  void navigateToBorrowBookPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BorrowBookPage()), // 跳转到借书页面
    );
  }

  void navigateToReturnBookPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ReturnBookPage()), // 跳转到归还书本页面
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('读者操作页'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '欢迎你, 读者$username!', // 显示用户名
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                updateUser();
              },
              child: Text('修改用户信息'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                navigateToBorrowBookPage(); // 跳转到借书页面
              },
              child: Text('借书'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                navigateToReturnBookPage(); // 跳转到归还书本页面
              },
              child: Text('还书'),
            ),
          ],
        ),
      ),
    );
  }
}
