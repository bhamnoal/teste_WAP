import 'package:flutter/material.dart';

class Input extends StatelessWidget {
  String label;
  TextEditingController controller;
  Input({super.key, required this.label, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        obscureText: label.contains('Login') ? false : true,
        decoration: (InputDecoration(
          icon: Icon(label.contains('Login') ? Icons.person : Icons.password),
          border: InputBorder.none,
          label: Text(label),
        )),
        controller: controller,
      ),
    );
  }
}
