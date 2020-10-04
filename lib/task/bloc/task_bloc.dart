import 'dart:async';
import 'package:flutter/material.dart';
import 'package:task_app/task/models/task.dart';
import 'package:task_app/task/resources/task_repository.dart';

class TaskBloc extends ChangeNotifier {
  StreamController<List<Task>> _tasks$ =
      StreamController<List<Task>>.broadcast();
  // List<Task> _tasks = new List();
  // Function(List<Task>) get tasksSink => _tasks$.sink.add;
  // Stream<List<Task>> get tasksStream => _tasks$.stream;

  TaskRepository repository = TaskRepository();

  Stream<List<Task>> get tasks => _tasks$.stream;

  Future<dynamic> create(Task task) => repository.create(task);

  Future<dynamic> update(Task task) => repository.update(task);

  Future<dynamic> changeStatus(Task task) => repository.changeStatus(task);

  Future<dynamic> delete(Task task) => repository.delete(task);

  Future<List<Task>> getTasks() async {
    final tasks = await repository.tasks();
    _tasks$.sink.add(tasks);
    // if (tasks != null) {
    // _tasks$.sink.add(tasks);
    // tasksSink(tasks);
    //   _tasks.addAll(tasks);
    //   _tasks$.sink.add(_tasks);
    // }

    return tasks != null ? tasks : [];
  }

  dispose() {
    _tasks$?.close();
  }
}
