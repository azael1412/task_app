// To parse this JSON data, do
//
//     final task = taskFromJson(jsonString);

import 'dart:convert';

List<Task> taskFromJson(String str) =>
    List<Task>.from(json.decode(str).map((x) => Task.fromJson(x)));

/*List<Task> taskFromJson(String str) {
  final result = json.decode(str);
  print(result);
  return List<Task>.from(result['data'].map((x) => Task.fromJson(x)));
}*/

/*String taskToJson(List<Task> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));*/

String taskToJson(Task data) => json.encode(data);

class Task {
  Task(
      {this.id,
      this.title,
      this.date,
      this.status,
      this.priority,
      this.priorityId});
  // Task.withId({this.id, this.title, this.date, this.priority, this.status});
  int id;
  String title;
  String date;
  int status;
  String priority;
  int priorityId;

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json["id"],
        title: json["title"],
        date: json["date"],
        status: json["status"],
        priority: json["priority"],
        priorityId: json["priority_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "date": date,
        "status": status,
        "priority": priority,
        "priority_id": priorityId,
      };
}

//errors task

TaskError taskErrorFromJson(String str) => TaskError.fromJson(json.decode(str));

String taskErrorToJson(TaskError data) => json.encode(data.toJson());

class TaskError {
  TaskError({
    this.title,
    this.date,
    this.priorityId,
  });

  List<String> title;
  List<String> date;
  List<String> priorityId;

  factory TaskError.fromJson(Map<String, dynamic> json) => TaskError(
        title: json["title"] != null
            ? List<String>.from(json["title"].map((x) => x))
            : null,
        date: json["date"] != null
            ? List<String>.from(json["date"].map((x) => x))
            : null,
        priorityId: json["priority_id"] != null
            ? List<String>.from(json["priority_id"].map((x) => x))
            : null,
      );

  Map<String, dynamic> toJson() => {
        "title": List<dynamic>.from(title.map((x) => x)),
        "date": List<dynamic>.from(date.map((x) => x)),
        "priority_id": List<dynamic>.from(priorityId.map((x) => x)),
      };
}
