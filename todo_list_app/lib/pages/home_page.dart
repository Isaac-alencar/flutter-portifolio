import "dart:convert";
import "dart:async";

import "package:flutter/material.dart";

import "package:todo_list_app/util/filesystem_management.dart";
import "package:todo_list_app/widgets/snack_bar.dart";

final FileSystemManagement fsm = FileSystemManagement();

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();

    fsm.readData().then((data) => {
          setState(() {
            _todoList = json.decode(data);
          })
        });
  }

  List<dynamic> _todoList = [];

  Map<String, dynamic>? _lastRemovedItem;
  int? _lastRemovedItemPos;

  final TextEditingController _inputController = TextEditingController();
  void _addTaskOnList() {
    setState(() {
      Map<String, dynamic> newTask = Map();
      newTask["title"] = _inputController.text;
      _inputController.text = "";
      newTask["completed"] = false;
      _todoList.add(newTask);
      fsm.saveData(_todoList);
    });
  }

  void _removeItemFromList(index) {
    _lastRemovedItem = Map.from(_todoList[index]);
    _lastRemovedItemPos = index;
    _todoList.removeAt(index);

    fsm.saveData(_todoList);
  }

  Future<Null> _reafreshAndSortList() async {
    await Future.delayed(Duration(microseconds: 100));
    setState(() {
      _todoList.sort((a, b) {
        if (a["completed"] && !b["completed"])
          return 1;
        else if (a["completed"] && b["completed"])
          return -1;
        else
          return 0;
      });
    });

    return null;
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
            child: RefreshIndicator(
              onRefresh: _reafreshAndSortList,
              child: ListView.builder(
                padding: EdgeInsets.only(top: 8),
                itemCount: _todoList.length,
                itemBuilder: buildItems,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildItems(_, int index) {
    return Dismissible(
      background: Container(
        color: Colors.redAccent[400],
        child: Align(
          alignment: Alignment(-0.9, 0.0),
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
      ),
      child: CheckboxListTile(
        title: Text(_todoList[index]["title"]),
        value: _todoList[index]["completed"],
        onChanged: (bool) {
          setState(() {
            _todoList[index]["completed"] = bool;
            fsm.saveData(_todoList);
          });
        },
        secondary: CircleAvatar(
          child: Icon(
            _todoList[index]["completed"] == true ? Icons.check : Icons.error,
          ),
        ),
      ),
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
      direction: DismissDirection.startToEnd,
      onDismissed: (DismissDirection direction) {
        setState(() {
          _removeItemFromList(index);

          ScaffoldMessenger.of(context).showSnackBar(createSnackBar("Undo", () {
            setState(() {
              _todoList.insert(_lastRemovedItemPos!, _lastRemovedItem);
              fsm.saveData(_todoList);
            });
          }, 2));
        });
      },
    );
  }
}
