import 'dart:async';
import 'package:task_app/task/models/message.dart';
import 'package:task_app/task/models/task.dart';

import 'package:http/http.dart' as http;

class TaskProvider {
  // Client client = Client();
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'X-Requested-With': 'XMLHttpRequest'
  };
  String url = 'http://192.168.0.10:8000/api/task';
  // int page = 0;

  Future<List<Task>> tasks() async {
    try {
      // page++;
      // print(page);
      // final uri =
      //     Uri.http('192.168.0.10:8000', '/api/task', {'page': page.toString()});
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        // If the call to the server was successful, parse the JSON
        // print(response.body);

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
    try {
      final response = await http.put(url + "/${task.id}",
          headers: headers, body: taskToJson(task));
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
    try {
      final response = await http.put(url + "/change-status/${task.id}",
          headers: headers, body: taskToJson(task));
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
    try {
      final response = await http.delete(url + "/${task.id}", headers: headers);
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
}
