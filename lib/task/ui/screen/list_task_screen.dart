import 'package:flutter/material.dart';
import 'package:task_app/helpers/database_helper.dart';
import 'package:task_app/task/models/task_model.dart';
import 'package:task_app/task/ui/screen/add_task_screen.dart';

import 'package:intl/intl.dart';

class ListTaskScreen extends StatefulWidget {
  ListTaskScreen({Key key}) : super(key: key);

  @override
  _ListTaskScreenState createState() => _ListTaskScreenState();
}

class _ListTaskScreenState extends State<ListTaskScreen> {
  Future<List<Task>> _taskList;
  final DateFormat _dateFormatter = DateFormat('MMM dd, yyyy');
  @override
  void initState() {
    // TODO: implement initState
    _updateTaskList();
  }

  _updateTaskList() {
    setState(() {
      _taskList = DatabaseHelper.instance.getTaskList();
    });
  }

  @override
  Widget build(BuildContext context) {
    _taskList = DatabaseHelper.instance.getTaskList();
    return Scaffold(
      body: FutureBuilder(
          future: _taskList,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final int completedTaskCount = snapshot.data
                .where((Task task) => task.status == 1)
                .toList()
                .length;
            return ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 80.0),
              itemCount: 1 + snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text('My Tasks',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 40.0,
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: 10.0),
                        Text(
                          '$completedTaskCount of ${snapshot.data.length}',
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w600),
                        )
                      ],
                    ),
                  );
                }
                return _buidTask(task: snapshot.data[index - 1]);
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddTaskScreen(
                      updateTaskList: _updateTaskList,
                    ))),
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buidTask({Task task}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.0),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              task.title,
              style: TextStyle(
                  fontSize: 18.0,
                  decoration: task.status == 0
                      ? TextDecoration.none
                      : TextDecoration.lineThrough),
            ),
            subtitle: Text(
                '${_dateFormatter.format(task.date)} - ${task.priority}',
                style: TextStyle(
                    fontSize: 15.0,
                    decoration: task.status == 0
                        ? TextDecoration.none
                        : TextDecoration.lineThrough)),
            trailing: Checkbox(
              onChanged: (value) {
                task.status = value ? 1 : 0;
                DatabaseHelper.instance.updateTask(task);
                _updateTaskList();
              },
              activeColor: Theme.of(context).primaryColor,
              value: task.status == 1 ? true : false,
            ),
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddTaskScreen(
                        task: task, updateTaskList: _updateTaskList))),
          ),
          Divider(),
        ],
      ),
    );
    /* Container(
      margin: EdgeInsets.all(10.0),
      height: 100.0,
      width: double.infinity,
      color: Colors.red,
    );*/
  }
}
