import 'package:floor/floor.dart';
import '../entity/todoitem.dart';

@dao
abstract class ToDoItemDao {
  @Query('SELECT * FROM ToDoItem')
  Future<List<ToDoItem>> findAllToDoItems();

  @insert
  Future<void> insertToDoItem(ToDoItem item);

  @delete
  Future<void> deleteToDoItem(ToDoItem item);
}
