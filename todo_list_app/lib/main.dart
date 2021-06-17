import "package:flutter/material.dart";

import "package:todo_list_app/home.dart";

void main() async {
  runApp(
    MaterialApp(
      home: Home(),
      debugShowCheckedModeBanner: false,
    ),
  );
}
