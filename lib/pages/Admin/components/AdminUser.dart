import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AdminUser extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new AdminUserState();
}

class AdminUserState extends State<AdminUser> {
  List<Map<String, dynamic>> userList = []; // 用户列表

  @override
  void initState() {
    super.initState();
    fetchUserList();
  }

  Future<void> fetchUserList() async {
    final response = await http.get(
      Uri.parse(
          'http://localhost:8080/mtsV2/user/getUserList?page=1&pageCount=100'),
      headers: {'Accept-Charset': 'utf-8'},
    );

    if (response.statusCode == 200) {
      // 以为设置了上面的请求头就可以保持中文了，结果发现这里还要转化一下
      final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
      if (jsonData['code'] == 200) {
        setState(() {
          userList = List<Map<String, dynamic>>.from(jsonData['data']);
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
        title: new Text("Admin User"),
      ),
      body: userList.isEmpty
          ? Center(child: CircularProgressIndicator())
          : new ListView.builder(
              itemCount: userList.length,
              itemBuilder: (context, index) {
                final user = userList[index];
                return ListTile(
                  title: Text(user['phone'] ?? 'Unknown'),
                  subtitle: Text(user['name'] ?? ''),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      // 删除用户
                      _deleteUser(user['id']);
                    },
                  ),
                  onTap: () {
                    // 修改用户
                    _showEditDialog(user);
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 添加用户
          _showAddDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  // 显示添加用户对话框
  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String password = '';
        String phone = '';

        return AlertDialog(
          title: Text('添加用户'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: '密码'),
                onChanged: (value) {
                  password = value;
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: '电话'),
                onChanged: (value) {
                  phone = value;
                },
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
                await _addUser(password, phone);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // 添加用户
  Future<void> _addUser(String password, String phone) async {
    final response = await http.post(
      Uri.parse('http://localhost:8080/mtsV2/user/addUser'),
      body: jsonEncode({
        'password': password,
        'phone': phone,
        'role': '2',
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      if (jsonData['code'] == 0) {
        // 添加用户成功
        await fetchUserList(); // 刷新用户列表
      } else {
        // 处理请求失败的情况
        print('添加用户失败：${jsonData['message']}');
      }
    } else {
      // 处理网络请求失败的情况
      print('网络请求失败：${response.statusCode}');
    }
  }

  // 显示编辑用户对话框
  void _showEditDialog(Map<String, dynamic> user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String password = '';
        String phone = user['phone'] ?? '';

        return AlertDialog(
          title: Text('编辑用户'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: '密码'),
                onChanged: (value) {
                  password = value;
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: '电话'),
                onChanged: (value) {
                  phone = value;
                },
                controller: TextEditingController(text: phone),
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
                await _updateUser(user['id'], password, phone);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // 更新用户信息
  Future<void> _updateUser(int id, String password, String phone) async {
    final response = await http.post(
      Uri.parse('http://localhost:8080/mtsV2/user/updateUser'),
      body: jsonEncode({
        'id': id,
        'password': password,
        'phone': phone,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      if (jsonData['code'] == 0) {
        // 更新用户信息成功
        await fetchUserList(); // 刷新用户列表
      } else {
        // 处理请求失败的情况
        print('更新用户信息失败：${jsonData['message']}');
      }
    } else {
      // 处理网络请求失败的情况
      print('网络请求失败：${response.statusCode}');
    }
  }

  // 删除用户
  Future<void> _deleteUser(int id) async {
    final response = await http.post(
      Uri.parse('http://localhost:8080/mtsV2/user/deleteUser'),
      body: jsonEncode({
        'id': id,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      if (jsonData['code'] == 0) {
        // 删除用户成功
        await fetchUserList(); // 刷新用户列表
      } else {
        // 处理请求失败的情况
        print('删除用户失败：${jsonData['message']}');
      }
    } else {
      // 处理网络请求失败的情况
      print('网络请求失败：${response.statusCode}');
    }
  }
}
