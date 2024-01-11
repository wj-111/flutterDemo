import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'pages/Login.dart';
// import 'pages/SecondPage.dart';
import 'pages/Admin/AdminPage.dart';
import 'pages/Reader/ReaderPage.dart';
import 'pages/SecondPage.dart';

class AppTwo extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(home: Home());
}

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    SecondPage(),
    LoginPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '功能',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '用户',
          )
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
