import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'to_do_dao.dart';
import 'to_do_item.dart';

part 'app_database.g.dart';

@Database(version: 1, entities: [ToDoItem])
abstract class AppDatabase extends FloorDatabase {
  ToDoDao get toDoDao;
}
