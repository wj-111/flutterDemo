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
    // ReaderPage(),
    // AdminPage(),
    SecondPage(),
    LoginPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: AppBar(
//        title: Text("第二种方式"),
//        centerTitle: true,
//      ),
      body: _children[_currentIndex],
//      CupertinoTabBar 是IOS分格
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        items: [
          // BottomNavigationBarItem(
          //   icon: const Icon(Icons.add) ,
          //   label: 'add',
          // ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.list),
            label: 'List',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.message),
            label: 'Message',
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
