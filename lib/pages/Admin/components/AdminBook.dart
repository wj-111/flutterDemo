import 'package:flutter/material.dart';

class AdminBook extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new SecondPageState();
}

class SecondPageState extends State<AdminBook> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Secone"),
      ),
      body: new Center(
        child: new Text("我是第二页"),
      ),
    );
  }
}
