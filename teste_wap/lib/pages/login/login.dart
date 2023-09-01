import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:teste_wap/pages/home/home.dart';
import 'package:teste_wap/pages/login/input.dart';

import '../../model/user/user_dto.dart';

class Login extends StatefulWidget {
  UserDto user;
  Login({super.key, required this.user});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController login = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 100,
            ),
            Input(
              label: 'Login',
              controller: login,
            ),
            Input(
              label: ('Senha'),
              controller: password,
            ),
            ElevatedButton(
                onPressed: () async {
                  loginUser();
                },
                child: const Text('Login'))
          ],
        ),
      )),
    );
  }

  void loginUser() async {
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    Map<String, dynamic> body = {'user': login.text, 'password': password.text};
    final response = await http.post(
        Uri.parse('https://api-tr.traderesult.app/TestMobile/auth'),
        headers: headers,
        body: jsonEncode(body));
    final bodyMap = jsonDecode(utf8.decode(response.bodyBytes));
    if (response.statusCode == 200) {
      UserDto.fromJson(bodyMap['user']);

      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Home(
              userName: bodyMap['user']['name'],
              profile: bodyMap['user']['profile'],
              taskList: bodyMap['user']['tasks'],
              idTask: bodyMap['user']['tasks'][0]['id'],
            ),
          ));
    } else if (bodyMap['success'] == false) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Erro'),
              content: bodyMap['fail'],
            );
          });
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Erro'),
              content: bodyMap['fail'],
            );
          });
    }
  }
}
