import 'dart:async';
import 'package:flutter/material.dart';

import 'package:task_app/task/models/task.dart';
import 'package:task_app/task/models/priority.dart';
import 'package:task_app/task/resources/task_repository.dart';

class TaskBloc extends ChangeNotifier {
  TaskRepository _repository = TaskRepository();

  StreamController<List<Task>> _tasks$ =
      StreamController<List<Task>>.broadcast();

  Stream<List<Task>> get tasks => _tasks$.stream;

  Future<List<Priority>> get priorities => _repository.priorities();

  Future<dynamic> create(Task task) => _repository.create(task);

  Future<dynamic> update(Task task) => _repository.update(task);

  Future<dynamic> changeStatus(Task task) => _repository.changeStatus(task);

  Future<dynamic> delete(Task task) => _repository.delete(task);

  Future<List<Task>> getTasks() async {
    final tasks = await _repository.tasks();
    _tasks$.sink.add(tasks);
    return tasks;
  }

  void dispose() {
    _tasks$?.close();
  }
}
