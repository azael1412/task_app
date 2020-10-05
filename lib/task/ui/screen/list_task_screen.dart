import 'package:flutter/material.dart';

import 'package:task_app/task/bloc/task_bloc.dart';
import 'package:task_app/task/models/task.dart';
import 'package:task_app/task/ui/widgets/task_list.dart';
import 'package:task_app/widgets/snackbar_message.dart';

import 'package:task_app/routes/app_routes.dart';
import 'package:task_app/widgets/loading_indicator.dart';

import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';

class ListTaskScreen extends StatefulWidget {
  ListTaskScreen({Key key}) : super(key: key);

  @override
  _ListTaskScreenState createState() => _ListTaskScreenState();
}

class _ListTaskScreenState extends State<ListTaskScreen> {
  TaskBloc taskBloc;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    taskBloc = Provider.of<TaskBloc>(context);
    taskBloc.getTasks();

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: FadeInRightBig(
          child: Text(
            "Lista de Tareas",
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<List<Task>>(
          // initialData: [],
          stream: taskBloc.tasks, //taskBloc.tasksStream
          builder: (context, AsyncSnapshot<List<Task>> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return Loading.loadingIndicators(context: context);
              case ConnectionState.waiting:
                return Loading.loadingIndicators(context: context);
              case ConnectionState.active:
                return TaskList(
                  snapshot: snapshot,
                  scaffoldKey: _scaffoldKey,
                );
              case ConnectionState.done:
                return TaskList(snapshot: snapshot, scaffoldKey: _scaffoldKey);
            }
            if (snapshot.hasError) {
              return Text("${snapshot.error.toString()}");
            }
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () => Navigator.pushNamed(context, AppRoutes.addTask,
            arguments: [null, taskBloc.getTasks]).then((value) {
          if (value is List && value != null) {
            if (value[0] != null && value[0]) {
              SnackBarMessage.message(
                  text: value[1], scaffoldKey: _scaffoldKey);
            }
          }
        }),
        child: Icon(Icons.add),
      ),
    );
  }
}
