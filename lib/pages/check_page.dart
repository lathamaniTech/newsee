import 'package:flutter/material.dart';

class CheckPage extends StatelessWidget {
  final String title;

  CheckPage(String s, {required this.title, super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
      title: Text("Details Check"),
       )
    );
  }
}