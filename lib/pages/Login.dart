import 'dart:convert';

import 'package:flutter/material.dart';
import '../model/user.dart';
import '../DAO/test.dart';

// import 'package:hello_flutter/service/http-service.dart';
import 'package:http/http.dart' as http;


Future<Album> fetchAlbum() async {
  final response = await http
      .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Album.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
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
  late Future<Album> futureAlbum;

  User user = User(username: "", password: "");

  // String _message = 'Welcome To Flutter';

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

      futureAlbum = fetchAlbum();

      futureAlbum.then((value) => {
        print(value.title)
        // user.username = '9999'
      });

      // HttpHelper.post(
      //   '/login',
      //   {
      //     'username': user.username,
      //     'password': user.password,
      //   },
      // )
      //     .then((value) => Navigator.pushReplacementNamed(context, '/first'))
      //     .catchError((error) => {_showMessage(error.message)});
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
