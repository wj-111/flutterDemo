import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import './SecondPage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String token = '';
  String phone = '';
  String role = '';
  String id = '';

  @override
  void initState() {
    super.initState();
    checkSavedData();
  }

  Future<void> checkSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token') ?? '';
      phone = prefs.getString('phone') ?? '';
      role = prefs.getString('role') ?? '';
      id = prefs.getString('id') ?? '';
    });
  }

  Future<void> handleResponse(BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('登录成功'),
        duration: Duration(seconds: 2), // 显示时长
      ),
    );
  }

  Future<void> login() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    final response = await http.post(
      Uri.parse('http://localhost:8080/mtsV2/user/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'phone': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(utf8.decode(response.bodyBytes));

      if (jsonData['code'] == 200) {
        final userData = jsonData['data'];
        final token = userData['token'];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setString('phone', userData['phone']);
        await prefs.setString('role', userData['role']);
        await prefs.setString('id', userData['id'].toString());

        setState(() {
          this.token = token;
          this.phone = userData['phone'];
          this.role = userData['role'];
          this.id = userData['id'].toString();
        });

        handleResponse(context);
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('登录失败'),
            content: Text('账户或者密码错误'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Login Failed'),
          content: Text('Failed to connect to the server.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    setState(() {
      token = '';
      phone = '';
      role = '';
      id = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('登录页'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (token.isNotEmpty) ...[
              Flexible(
                child: Text('Token: $token'),
              ),
              Flexible(
                child: Text('Phone: $phone'),
              ),
              Flexible(
                child: Text('Role: $role'),
              ),
              Flexible(
                child: Text('ID: $id'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: logout,
                child: Text('退出登录'),
              ),
            ] else ...[
              Text('用户名:'),
              TextField(
                controller: _usernameController,
              ),
              SizedBox(height: 20),
              Text('密码:'),
              TextField(
                controller: _passwordController,
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: login,
                child: Text('登录'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
