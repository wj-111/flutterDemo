import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Admin/AdminPage.dart';
import 'Reader/ReaderPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecondPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new SecondPageState();
}

class SecondPageState extends State<SecondPage> {
  String token = '';
  String phone = '';
  String role = '';

  @override
  void initState() {
    super.initState();
    loadUserInfo();
  }

  Future<void> loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token') ?? '';
      phone = prefs.getString('phone') ?? '';
      role = prefs.getString('role') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    if (role == '1') {
      return AdminPage();
    } else if (role == '2') {
      return ReaderPage();
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text("功能页，请先登录"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Token: $token"),
              Text("Phone: $phone"),
              Text("Role: $role"),
            ],
          ),
        ),
      );
    }
  }
}
