import 'package:floor/floor.dart';

@entity
class ToDoItem {
  @primaryKey
  final int id;
  final String description;

  ToDoItem(this.id, this.description);
}
