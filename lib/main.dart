import 'package:flutter/material.dart';
import 'package:task_app/task/ui/screen/list_task_screen.dart';

//2 building our add task screen
//minuto 13:09

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ListTaskScreen(),
    );
  }
}
