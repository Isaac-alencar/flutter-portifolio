import 'dart:io';
import "dart:async";
import "dart:convert";

import "package:flutter/material.dart";
import 'package:path_provider/path_provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Map<String, dynamic>> _todoList = [];

  final TextEditingController _inputController = TextEditingController();

  void _addTaskOnList() {
    setState(() {
      Map<String, dynamic> newTask = Map();
      newTask["title"] = _inputController.text;
      _inputController.text = "";
      newTask["completed"] = false;
      _todoList.add(newTask);
    });
  }

  Future<File> _getFile() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/data.json");
  }

  Future _saveData() async {
    String data = json.encode(_todoList);
    final File file = await _getFile();
    return file.writeAsString(data);
  }

  Future _readData() async {
    try {
      final File file = await _getFile();
      return file.readAsString();
    } catch (error) {
      print(error);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Task List',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Color.fromRGBO(107, 112, 92, 1),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _inputController,
                    decoration: InputDecoration(
                      labelText: "Type to add a task",
                      labelStyle: TextStyle(
                        color: Color.fromRGBO(107, 112, 92, 1),
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.blueAccent,
                    ),
                  ),
                  onPressed: _addTaskOnList,
                  child: Text('Add'),
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(top: 8),
              itemCount: _todoList.length,
              itemBuilder: (BuildContext context, int index) {
                return CheckboxListTile(
                  title: Text(_todoList[index]["title"]),
                  value: _todoList[index]["completed"],
                  onChanged: (bool) {
                    setState(() {
                      _todoList[index]["completed"] = bool;
                    });
                  },
                  secondary: CircleAvatar(
                    child: Icon(
                      _todoList[index]["completed"] == true
                          ? Icons.check
                          : Icons.error,
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
