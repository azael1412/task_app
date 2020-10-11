import 'dart:async';

import 'package:task_app/task/models/task.dart';
import 'package:task_app/task/models/message.dart';
import 'package:task_app/task/models/priority.dart';

import 'package:http/http.dart' as http;

class TaskProvider {
  // Client client = Client();
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'X-Requested-With': 'XMLHttpRequest'
  };
  String authority = '192.168.0.4:8000';
  String unencodedPath = '/api/task';

  Future<List<Task>> tasks() async {
    try {
      final url = Uri.http(authority, unencodedPath);
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        return taskFromJson(response.body);
      } else {
        // If that call was not successful, throw an error.
        throw Exception('Failed to load tasks');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<dynamic> create(Task task) async {
    final url = Uri.http(authority, unencodedPath);
    try {
      final response =
          await http.post(url, headers: headers, body: taskToJson(task));
      switch (response.statusCode) {
        case 200:
          return messageFromJson(response.body);
          break;
        case 406:
          return taskErrorFromJson(response.body);
          break;
        default:
          print('Upps!! Algo salio mal');
          break;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<dynamic> update(Task task) async {
    final url = Uri.http(authority, unencodedPath + "/${task.id}");
    try {
      final response =
          await http.put(url, headers: headers, body: taskToJson(task));
      switch (response.statusCode) {
        case 200:
          return messageFromJson(response.body);
          break;
        case 404:
          print(response.body);
          return messageFromJson(response.body);
          break;
        case 406:
          return taskErrorFromJson(response.body);
          break;
        default:
          print('Upps!! Algo salio mal');
          break;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<dynamic> changeStatus(Task task) async {
    final url =
        Uri.http(authority, unencodedPath + "/change-status/${task.id}");
    try {
      final response =
          await http.put(url, headers: headers, body: taskToJson(task));
      switch (response.statusCode) {
        case 200:
          return messageFromJson(response.body);
          break;
        case 404:
          print(response.body);
          return messageFromJson(response.body);
          break;
        default:
          print('Upps!! Algo salio mal');
          break;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<dynamic> delete(Task task) async {
    final url = Uri.http(authority, unencodedPath + "/${task.id}");
    try {
      final response = await http.delete(url, headers: headers);
      switch (response.statusCode) {
        case 200:
          return messageFromJson(response.body);
          break;
        case 404:
          print(response.body);
          return messageFromJson(response.body);
          break;
        default:
          print('Upps!! Algo salio mal');
          break;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<List<Priority>> priorities() async {
    final url = Uri.http(authority, "/api/priorities");
    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        return priorityFromJson(response.body);
      } else {
        // If that call was not successful, throw an error.
        throw Exception('Failed to load tasks');
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
