import 'dart:convert';

class ToDoListModel {
    int userTodoListId;
    String userTodoListTitle;
    String userTodoListDesc;
    String userTodoListCompleted;
    DateTime userTodoListLastUpdate;
    int userId;
    int userTodoTypeId;
    String userTodoTypeName;

    ToDoListModel({
        required this.userTodoListId,
        required this.userTodoListTitle,
        required this.userTodoListDesc,
        required this.userTodoListCompleted,
        required this.userTodoListLastUpdate,
        required this.userId,
        required this.userTodoTypeId,
        required this.userTodoTypeName,
    });

    factory ToDoListModel.fromJson(Map<String, dynamic> json) => ToDoListModel(
        userTodoListId: json["user_todo_list_id"],
        userTodoListTitle: json["user_todo_list_title"],
        userTodoListDesc: json["user_todo_list_desc"],
        userTodoListCompleted: json["user_todo_list_completed"],
        userTodoListLastUpdate: DateTime.parse(json["user_todo_list_last_update"]),
        userId: json["user_id"],
        userTodoTypeId: json["user_todo_type_id"],
        userTodoTypeName: json["user_todo_type_name"],
    );

    Map<String, dynamic> toJson() => {
        "user_todo_list_id": userTodoListId,
        "user_todo_list_title": userTodoListTitle,
        "user_todo_list_desc": userTodoListDesc,
        "user_todo_list_completed": userTodoListCompleted,
        "user_todo_list_last_update": userTodoListLastUpdate.toIso8601String(),
        "user_id": userId,
        "user_todo_type_id": userTodoTypeId,
        "user_todo_type_name": userTodoTypeName,
    };
}