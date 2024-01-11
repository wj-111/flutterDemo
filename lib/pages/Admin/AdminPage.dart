import 'package:flutter/material.dart';
import './components/AdminBook.dart';
import './components/AdminUser.dart';

class AdminPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Third Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // 处理维护用户信息按钮点击事件
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminUser()),
                );
              },
              child: Text('维护用户信息'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // 处理维护图书信息按钮点击事件
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminBook()),
                );
              },
              child: Text('维护图书信息'),
            ),
          ],
        ),
      ),
    );
  }
}
