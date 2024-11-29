import 'package:flutter/material.dart';
import 'app_database.dart'; // Import the database class
import 'to_do_item.dart'; // Import the ToDoItem class
import 'package:floor/floor.dart'; // Import Floor

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensures everything is initialized before the app starts
  final database = await $FloorAppDatabase.databaseBuilder('app_database.db').build(); // Correct usage of the generated class
  runApp(MyApp(database: database));
}

class MyApp extends StatelessWidget {
  final AppDatabase database;

  const MyApp({Key? key, required this.database}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: MyHomePage(database: database),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final AppDatabase database;

  const MyHomePage({Key? key, required this.database}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<ToDoItem> _todoItems = [];
  final TextEditingController _textController = TextEditingController();
  int _idCounter = 1;

  @override
  void initState() {
    super.initState();
    _loadToDoItems();
  }

  Future<void> _loadToDoItems() async {
    final items = await widget.database.toDoDao.findAllToDoItems();
    setState(() {
      _todoItems = items;
      _idCounter = (items.isNotEmpty ? items.map((item) => item.id).reduce((a, b) => a > b ? a : b) : 0) + 1;
    });
  }

  void _addTodoItem() async {
    if (_textController.text.isNotEmpty) {
      final newItem = ToDoItem(_idCounter++, _textController.text);
      await widget.database.toDoDao.insertToDoItem(newItem);
      setState(() {
        _todoItems.add(newItem);
        _textController.clear();
      });
    }
  }

  void _promptRemoveItem(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Task'),
          content: const Text('Are you sure you want to delete this task?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () async {
                final item = _todoItems[index];
                await widget.database.toDoDao.deleteToDoItem(item);
                setState(() {
                  _todoItems.removeAt(index);
                });
                Navigator.of(context).pop();
              },
              child: const Text('Yes'),
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
        title: const Text('Flutter Demo Home Page'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      hintText: 'Enter a task',
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _addTodoItem,
                  child: const Text('Add'),
                ),
              ],
            ),
          ),
          Expanded(
            child: _todoItems.isEmpty
                ? const Center(child: Text('There are no items in the list'))
                : ListView.builder(
              itemCount: _todoItems.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Item $index: ${_todoItems[index].name}'),
                  onLongPress: () => _promptRemoveItem(index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
