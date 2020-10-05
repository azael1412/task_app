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
  Task({this.id, this.title, this.priority, this.date, this.status});
  // Task.withId({this.id, this.title, this.date, this.priority, this.status});
  int id;
  String title;
  String priority;
  // DateTime date;
  String date;
  int status;

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json["id"],
        title: json["title"],
        priority: json["priority"],
        //date: DateTime.parse(json["date"]),
        date: json["date"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "priority": priority,
        "date": date,
        //"${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "status": status,
      };
}

//errors task

TaskError taskErrorFromJson(String str) => TaskError.fromJson(json.decode(str));

String taskErrorToJson(TaskError data) => json.encode(data.toJson());

class TaskError {
  TaskError({
    this.title,
    this.date,
    this.priority,
  });

  List<String> title;
  List<String> date;
  List<String> priority;

  factory TaskError.fromJson(Map<String, dynamic> json) => TaskError(
        title: json["title"] != null
            ? List<String>.from(json["title"].map((x) => x))
            : null,
        date: json["date"] != null
            ? List<String>.from(json["date"].map((x) => x))
            : null,
        priority: json["priority"] != null
            ? List<String>.from(json["priority"].map((x) => x))
            : null,
      );

  Map<String, dynamic> toJson() => {
        "title": List<dynamic>.from(title.map((x) => x)),
        "date": List<dynamic>.from(date.map((x) => x)),
        "priority": List<dynamic>.from(priority.map((x) => x)),
      };
}
