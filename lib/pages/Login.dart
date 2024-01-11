import 'dart:convert';

import 'package:flutter/material.dart';
import '../model/user.dart';
import '../model/album.dart';
import '../model/userquery.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:hello_flutter/service/http-service.dart';
import 'package:http/http.dart' as http;

Future<Album> createAlbum(UserQuery userQuery) async {
  final response = await http.post(
    Uri.parse('http://localhost:8080/mtsV2/user/login'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(userQuery.toJson()),
  );

  if (response.statusCode == 200) {
    return Album.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception('Failed to create album.');
  }
}

// StatefulWidget
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  User user = User(username: "", password: "");

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          child: Column(
            children: [
              const SizedBox(height: 32.0),
              Icon(Icons.home, color: Colors.blue[400], size: 64),
              const Text('WELCOME', style: TextStyle(fontSize: 32)),
              _buildForm(),
            ],
          ),
        ),
      ),
    );
  }

  // 创建表单
  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(height: 16),
          TextFormField(
              autofocus: true,
              onSaved: (x) => user.username = x!,
              validator: (x) => x!.isNotEmpty ? null : "用户名不能为空",
              decoration: _getInputDecoration(Icons.person, '用户名', '请输入用户名')),
          const SizedBox(height: 16),
          TextFormField(
              obscureText: true,
              onSaved: (x) => user.password = x!,
              validator: (x) => x!.isNotEmpty ? null : "密码不能为空",
              decoration: _getInputDecoration(Icons.lock, '密码', '请输入密码')),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 42,
            child: ElevatedButton(
              onPressed: _onLogin,
              child: const Text("登 录"),
            ),
          ),
        ],
      ),
    );
  }

  // 得到输入控件装饰
  InputDecoration _getInputDecoration(
      IconData icon, String labelText, String hintText) {
    return InputDecoration(
      filled: true,
      isCollapsed: true,
      hintText: hintText,
      // labelText: labelText,
      prefixIcon: Icon(icon),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      enabledBorder: _buildInputBorder(),
      border: _buildInputBorder(),
    );
  }

  // 输入控件边框
  InputBorder _buildInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16.0),
      borderSide: const BorderSide(color: Colors.white, width: 0),
    );
  }

  // 点击登录
  void _onLogin() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      UserQuery userQuery = UserQuery(
        phone: user.username,
        password: user.password,
      );

      createAlbum(userQuery).then((value) async {
        // 这里可以根据返回的结果进行相应的处理
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('token', value.data);
      }).catchError((error) {
        _showMessage(error.toString());
      });
    }
  }

  void _showMessage(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(
          color: Colors.red[400],
        ),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
