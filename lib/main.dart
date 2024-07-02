import 'package:flutter/material.dart';
import 'database.dart';
import 'entity/todoitem.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  runApp(ToDoApp(database: database));
}

class ToDoApp extends StatelessWidget {
  final AppDatabase database;

  ToDoApp({required this.database});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ToDoList(database: database),
    );
  }
}

class ToDoList extends StatefulWidget {
  final AppDatabase database;

  ToDoList({required this.database});

  @override
  ToDoListState createState() => ToDoListState();
}

class ToDoListState extends State<ToDoList> {
  final List<ToDoItem> _items = [];
  final TextEditingController textController = TextEditingController();
  int idCounter = 1;

  @override
  void initState() {
    super.initState();
    loadItems();
  }

  Future<void> loadItems() async {
    final items = await widget.database.toDoItemDao.findAllToDoItems();
    setState(() {
      _items.addAll(items);
      if (items.isNotEmpty) {
        idCounter = items.map((item) => item.id).reduce((a, b) => a > b ? a : b) + 1;
      }
    });
  }

  void _addItem() async {
    if (textController.text.isNotEmpty) {
      final newItem = ToDoItem(idCounter++, textController.text);
      await widget.database.toDoItemDao.insertToDoItem(newItem);
      setState(() {
        _items.add(newItem);
        textController.clear();
      });
    }
  }

  void removeItem(int index) async {
    final item = _items[index];
    await widget.database.toDoItemDao.deleteToDoItem(item);
    setState(() {
      _items.removeAt(index);
    });
  }

  void _showDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Item'),
          content: Text('Do you want to delete this item?'),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                removeItem(index);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To Do List'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ElevatedButton(
                  onPressed: _addItem,
                  child: Text('Add item'),
                ),
                Expanded(
                  child: TextField(
                    controller: textController,
                    decoration: InputDecoration(
                      hintText: 'Enter a to do item',
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _items.isEmpty
                ? Center(child: Text('There are no items in the list'))
                : ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, rowNum) {
                return GestureDetector(
                  onLongPress: () => _showDeleteDialog(rowNum),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Row number: ${rowNum + 1}"),
                      Text(_items[rowNum].description),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
