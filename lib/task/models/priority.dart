// To parse this JSON data, do
//
//     final priority = priorityFromJson(jsonString);

import 'dart:convert';

List<Priority> priorityFromJson(String str) =>
    List<Priority>.from(json.decode(str).map((x) => Priority.fromJson(x)));

String priorityToJson(List<Priority> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Priority {
  Priority({
    this.id,
    this.name,
  });

  int id;
  String name;

  factory Priority.fromJson(Map<String, dynamic> json) => Priority(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
