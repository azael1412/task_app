import 'package:flutter/material.dart';

import 'package:task_app/routes/app_routes.dart';
import 'package:task_app/task/bloc/task_bloc.dart';
import 'package:task_app/task/models/message.dart';
import 'package:task_app/task/models/task.dart';
import 'package:task_app/widgets/snackbar_message.dart';

import 'package:provider/provider.dart';

class TaskItem extends StatefulWidget {
  final Task task;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Function updateTaskList;

  TaskItem({Key key, this.task, this.scaffoldKey, this.updateTaskList})
      : super(key: key);

  @override
  _TaskItemState createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  @override
  Widget build(BuildContext context) {
    TaskBloc taskBloc = Provider.of<TaskBloc>(context, listen: false);
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.red,
      ),
      onDismissed: (direction) {
        taskBloc.delete(widget.task).then((value) {
          if (value is Message) {
            SnackBarMessage.message(
                text: value.message, scaffoldKey: widget.scaffoldKey);
          }
        });
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          children: <Widget>[
            ListTile(
                title: Text(
                  "${widget.task.title}",
                  style: TextStyle(
                      fontSize: 18.0,
                      decoration: widget.task.status == 0
                          ? TextDecoration.none
                          : TextDecoration.lineThrough),
                ),
                subtitle: Text('${widget.task.date} - ${widget.task.priority}',
                    style: TextStyle(
                        fontSize: 15.0,
                        decoration: widget.task.status == 0
                            ? TextDecoration.none
                            : TextDecoration.lineThrough)),
                trailing: Checkbox(
                  onChanged: (value) {
                    widget.task.status = value ? 1 : 0;
                    taskBloc.changeStatus(widget.task).then((response) {
                      if (response is Message) {
                        widget.updateTaskList();
                        SnackBarMessage.message(
                            text: response.message,
                            scaffoldKey: widget.scaffoldKey);
                      }
                    });
                  },
                  activeColor: Theme.of(context).primaryColor,
                  value: widget.task.status == 1 ? true : false,
                ),
                onTap: () => Navigator.pushNamed(context, AppRoutes.addTask,
                        arguments: [widget.task, () {}]).then((value) {
                      if (value != null) {
                        widget.updateTaskList();
                        // print("creando tarea");
                        SnackBarMessage.message(
                            text: value, scaffoldKey: widget.scaffoldKey);
                      }
                    })),
            Divider(),
          ],
        ),
      ),
    );
  }
}
