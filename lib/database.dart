import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'dao/todoitemdao.dart';
import 'entity/todoitem.dart';

part 'database.g.dart';

@Database(version: 1, entities: [ToDoItem])
abstract class AppDatabase extends FloorDatabase {
  ToDoItemDao get toDoItemDao;
}
