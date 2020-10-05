import 'package:flutter/material.dart';

import 'package:task_app/task/bloc/task_bloc.dart';
import 'package:task_app/task/models/task.dart';
import 'package:task_app/task/ui/widgets/task_item.dart';

import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';

class TaskList extends StatelessWidget {
  final AsyncSnapshot<List<Task>> snapshot;
  final GlobalKey<ScaffoldState> scaffoldKey;
  const TaskList({Key key, this.snapshot, this.scaffoldKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TaskBloc taskBloc = Provider.of<TaskBloc>(context, listen: false);
    int completedTaskCount = 0;
    completedTaskCount =
        snapshot.data.where((Task task) => task.status == 1).toList().length;
    return FadeInRightBig(
      child: ListView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: snapshot.data.length + 1,
          itemBuilder: (_, index) {
            if (index == 0) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
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
            } else {
              return TaskItem(
                  task: snapshot.data[index - 1],
                  scaffoldKey: scaffoldKey,
                  updateTaskList: taskBloc
                      .getTasks); //_buidTask(task: snapshot.data[index - 1], context: context);
            }
          }),
    );
  }
}
