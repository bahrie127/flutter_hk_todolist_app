import 'package:hk_todolist_app/data/todo_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodolistLocal {
  Future<TodoListModel> saveTodoList(TodoListModel model) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString('todolist', model.toJson());
    return model;
  }

  Future<TodoListModel> getTodoList() async {
    final pref = await SharedPreferences.getInstance();
    final result = pref.getString('todolist');
    return TodoListModel.fromJson(result!);
  }

  Future<bool> isTodoListExist() async {
    final pref = await SharedPreferences.getInstance();
    final result = pref.getString('todolist');
    if (result == null) {
      return false;
    }
    return true;
  }
}
