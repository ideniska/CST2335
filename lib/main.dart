import 'package:flutter/material.dart';

void main() {
  runApp(Lab6());
}

class Lab6 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ToDoList(),
    );
  }
}

class ToDoList extends StatefulWidget {
  @override
  _ToDoListState createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  final List<String> words = [];
  final TextEditingController textController = TextEditingController();

  void addItem() {
    setState(() {
      words.add(textController.text);
      textController.clear();
    });
  }

  void removeItem(int index) {
    setState(() {
      words.removeAt(index);
    });
  }

  void showDeleteDialog(int index) {
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
                  onPressed: addItem,
                  child: Text('Add item'),
                ),
                Expanded(
                  child: TextField(
                    controller: textController,
                    decoration: InputDecoration(
                      hintText: 'Enter a todo item',
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: words.isEmpty
                ? Center(child: Text('There are no items in the list'))
                : ListView.builder(
              itemCount: words.length,
              itemBuilder: (context, rowNum) {
                return GestureDetector(
                  onLongPress: () => showDeleteDialog(rowNum),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Row number: ${rowNum + 1}"),
                      Text(words[rowNum]),
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
