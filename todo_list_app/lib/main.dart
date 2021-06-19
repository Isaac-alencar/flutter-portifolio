import "package:flutter/material.dart";

import 'package:todo_list_app/pages/home_page.dart';

void main() async {
  runApp(
    MaterialApp(
      home: Home(),
      debugShowCheckedModeBanner: false,
    ),
  );
}
