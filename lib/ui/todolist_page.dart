import 'package:flutter/material.dart';
import 'package:hk_todolist_app/data/todo_model.dart';
import 'package:hk_todolist_app/data/todolist_local.dart';

class TodolistPage extends StatefulWidget {
  const TodolistPage({super.key});

  @override
  State<TodolistPage> createState() => _TodolistPageState();
}

class _TodolistPageState extends State<TodolistPage> {
  List<TodoModel> todolist = [];

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  bool isLoading = false;

  Future<void> getTodolist() async {
    setState(() {
      isLoading = true;
    });
    if (await TodolistLocal().isTodoListExist()) {
      final result = await TodolistLocal().getTodoList();
      todolist = result.data;
    }
    setState(() {
      isLoading = false;
    });
  }

  void saveTodo(TodoModel model) async {
    todolist.add(model);
    await TodolistLocal().saveTodoList(TodoListModel(data: todolist));
    getTodolist();
  }

  @override
  void initState() {
    getTodolist();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List App'),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : todolist.isEmpty
              ? const Center(
                  child: Text(
                  'No Data',
                  style: TextStyle(fontSize: 30),
                ))
              : ListView.builder(
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text('${index + 1}'),
                        ),
                        title: Text(todolist.reversed.toList()[index].title),
                        subtitle:
                            Text(todolist.reversed.toList()[index].description),
                        trailing: Checkbox(
                          value: todolist.reversed.toList()[index].isDone,
                          onChanged: (value) {
                            setState(() {
                              todolist.reversed.toList()[index].isDone = value!;
                              TodolistLocal()
                                  .saveTodoList(TodoListModel(data: todolist));
                              getTodolist();
                            });
                          },
                        ),
                      ),
                    );
                  },
                  itemCount: todolist.length,
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Add Todo'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        decoration: const InputDecoration(
                          labelText: 'Title',
                        ),
                        controller: titleController,
                      ),
                      TextField(
                        decoration: const InputDecoration(
                          labelText: 'Description',
                        ),
                        maxLines: 3,
                        controller: descriptionController,
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        final model = TodoModel(
                          id: todolist.length + 1,
                          title: titleController.text,
                          description: descriptionController.text,
                          dateCreated: DateTime.now(),
                          isDone: false,
                        );
                        saveTodo(model);
                        titleController.clear();
                        descriptionController.clear();
                        Navigator.pop(context);
                      },
                      child: const Text('Save'),
                    ),
                  ],
                );
              });
          getTodolist();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
