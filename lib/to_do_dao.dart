import 'package:floor/floor.dart';
import 'to_do_item.dart';

@dao
abstract class ToDoDao {
  @Query('SELECT * FROM ToDoItem')
  Future<List<ToDoItem>> findAllToDoItems();

  @insert
  Future<void> insertToDoItem(ToDoItem toDoItem);

  @delete
  Future<void> deleteToDoItem(ToDoItem toDoItem);
}
