import 'dart:convert';

class TodoModel {
  final int id;
  final String title;
  final String description;
  final DateTime dateCreated;
  bool isDone;
  TodoModel({
    required this.id,
    required this.title,
    required this.description,
    required this.dateCreated,
    required this.isDone,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dateCreated': dateCreated.millisecondsSinceEpoch,
      'isDone': isDone,
    };
  }

  factory TodoModel.fromMap(Map<String, dynamic> map) {
    return TodoModel(
      id: map['id']?.toInt() ?? 0,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      dateCreated: DateTime.fromMillisecondsSinceEpoch(map['dateCreated']),
      isDone: map['isDone'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory TodoModel.fromJson(String source) =>
      TodoModel.fromMap(json.decode(source));

  TodoModel copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? dateCreated,
    bool? isDone,
  }) {
    return TodoModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dateCreated: dateCreated ?? this.dateCreated,
      isDone: isDone ?? this.isDone,
    );
  }
}

class TodoListModel {
  final List<TodoModel> data;
  TodoListModel({
    required this.data,
  });

  Map<String, dynamic> toMap() {
    return {
      'data': data.map((x) => x.toMap()).toList(),
    };
  }

  factory TodoListModel.fromMap(Map<String, dynamic> map) {
    return TodoListModel(
      data: List<TodoModel>.from(map['data']?.map((x) => TodoModel.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory TodoListModel.fromJson(String source) =>
      TodoListModel.fromMap(json.decode(source));

  TodoListModel copyWith({
    List<TodoModel>? data,
  }) {
    return TodoListModel(
      data: data ?? this.data,
    );
  }
}
