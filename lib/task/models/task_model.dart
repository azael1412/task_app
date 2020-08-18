class Task {
  int id;
  String title;
  DateTime date;
  String priority;
  int status;

  Task({this.title, this.date, this.priority, this.status});
  Task.withId({this.id, this.title, this.date, this.priority, this.status});

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    if (this.id != null) {
      map['id'] = this.id;
    }
    map['title'] = this.title;
    map['date'] = this.date.toIso8601String();
    map['priority'] = this.priority;
    map['status'] = this.status;

    return map;
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task.withId(
      id: map['id'],
      title: map['title'],
      date: DateTime.parse(map['date']),
      priority: map['priority'],
      status: map['status'],
    );
  }
}
