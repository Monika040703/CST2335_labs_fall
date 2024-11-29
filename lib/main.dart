import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do List',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<ToDoItem> todoItems = [];
  ToDoItem? selectedItem;
  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Responsive To-Do List')),
      body: reactiveLayout(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            todoItems.add(ToDoItem(name: textController.text, id: DateTime.now().millisecondsSinceEpoch));
            textController.clear();
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget reactiveLayout() {
    var size = MediaQuery.of(context).size;
    var width = size.width;
    var height = size.height;

    if ((width > height) && (width > 720)) {
      // Tablet/Landscape mode
      return Row(
        children: [
          Expanded(flex: 1, child: ToDoList()),
          Expanded(flex: 2, child: DetailsPage()),
        ],
      );
    } else {
      // Phone/Portrait mode
      return selectedItem == null ? ToDoList() : DetailsPage();
    }
  }

  Widget ToDoList() {
    return Column(
      children: [
        TextField(controller: textController, decoration: InputDecoration(labelText: 'Add To-Do Item')),
        Expanded(
          child: ListView.builder(
            itemCount: todoItems.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(todoItems[index].name),
                onTap: () {
                  setState(() {
                    selectedItem = todoItems[index];
                  });
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget DetailsPage() {
    if (selectedItem != null) {
      return Column(
        children: [
          Text('Item: ${selectedItem!.name}'),
          Text('ID: ${selectedItem!.id}'),
          ElevatedButton(
            onPressed: () {
              setState(() {
                todoItems.remove(selectedItem);
                selectedItem = null;
              });
            },
            child: Text('Delete'),
          ),
        ],
      );
    }
    return Container();
  }
}

class ToDoItem {
  final String name;
  final int id;
  ToDoItem({required this.name, required this.id});
}
