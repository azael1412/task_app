import 'dart:async';
import 'package:task_app/task/models/task.dart';
import 'package:task_app/task/resources/task_provider.dart';

class TaskRepository {
  final taskProvider = TaskProvider();
  //lists
  Future<List<Task>> tasks() => taskProvider.tasks();
  //create
  Future<dynamic> create(Task task) => taskProvider.create(task);
  //update
  Future<dynamic> update(Task task) => taskProvider.update(task);
  //update
  Future<dynamic> changeStatus(Task task) => taskProvider.changeStatus(task);
  //delete
  Future<dynamic> delete(Task task) => taskProvider.delete(task);
}
