import 'package:flutter/material.dart';

import 'package:task_app/task/bloc/task_bloc.dart';
import 'package:task_app/task/models/message.dart';
import 'package:task_app/task/models/task.dart';

import 'package:task_app/routes/app_routes.dart';
import 'package:task_app/widgets/loading_indicator.dart';

import 'package:provider/provider.dart';
import 'package:task_app/widgets/snackbar_message.dart';

// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:task_app/widgets/fade_transition_route.dart';
// import 'package:intl/intl.dart';

class ListTaskScreen extends StatefulWidget {
  ListTaskScreen({Key key}) : super(key: key);

  @override
  _ListTaskScreenState createState() => _ListTaskScreenState();
}

class _ListTaskScreenState extends State<ListTaskScreen> {
  TaskBloc taskBloc;
  bool loading = false;
  ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   _updateTaskList(context: context);
    //   print("entre1");
    // });
  }

  _updateTaskList({BuildContext context}) {
    taskBloc = Provider.of<TaskBloc>(context, listen: false);
    taskBloc.getTasks();
  }

  @override
  Widget build(BuildContext context) {
    _updateTaskList(context: context);
    // taskBloc = Provider.of<TaskBloc>(context);
    // taskBloc.getTasks();

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Lista de Tareas"),
        centerTitle: true,
      ),
      body: StreamBuilder<List<Task>>(
          initialData: [],
          stream: taskBloc.tasks, //taskBloc.tasksStream,
          builder: (context, AsyncSnapshot<List<Task>> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return Loading.loadingIndicators(context: context);
              case ConnectionState.waiting:
                return Loading.loadingIndicators(context: context);
              case ConnectionState.active:
                print("active");
                return _listTask(snapshot: snapshot);
              // return Loading.loadingIndicators(context: context);
              // case ConnectionState.done:
              //   print("done");
              //   return _listTask(snapshot: snapshot);
            }
            if (snapshot.hasError) {
              return Text("${snapshot.error.toString()}");
            }
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () => Navigator.pushNamed(context, AppRoutes.addTask
                //FadeTransitionRoute(widget: AddTaskScreen())
                // MaterialPageRoute(
                //     builder: (context) {
                //       return AddTaskScreen();
                //     },
                //     settings: RouteSettings(name: "AddTaskScreen"))
                )
            .then((value) {
          if (value is List && value != null) {
            if (value[0] != null && value[0]) {
              setState(() {
                loading = true;
              });
              _updateTaskList(context: context);
              SnackBarMessage.message(
                  text: value[1], scaffoldKey: _scaffoldKey);
              loading = false;
            }
          }
        }),
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buidTask({Task task, BuildContext context}) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.red,
      ),
      onDismissed: (direction) {
        taskBloc.delete(task).then((value) {
          if (value is Message) {
            SnackBarMessage.message(
                text: value.message, scaffoldKey: _scaffoldKey);
          }
        });
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          children: <Widget>[
            ListTile(
                title: Text(
                  "${task.title}",
                  style: TextStyle(
                      fontSize: 18.0,
                      decoration: task.status == 0
                          ? TextDecoration.none
                          : TextDecoration.lineThrough),
                ),
                subtitle: Text('${task.date} - ${task.priority}',
                    style: TextStyle(
                        fontSize: 15.0,
                        decoration: task.status == 0
                            ? TextDecoration.none
                            : TextDecoration.lineThrough)),
                trailing: Checkbox(
                  onChanged: (value) {
                    task.status = value ? 1 : 0;
                    taskBloc.changeStatus(task).then((response) {
                      if (response is Message) {
                        _updateTaskList(context: context);
                        SnackBarMessage.message(
                            text: response.message, scaffoldKey: _scaffoldKey);
                      }
                    });
                  },
                  activeColor: Theme.of(context).primaryColor,
                  value: task.status == 1 ? true : false,
                ),
                onTap: () => Navigator.pushNamed(context, AppRoutes.addTask,
                            arguments: task

                            // FadeTransitionRoute(widget: AddTaskScreen(task: task))
                            // MaterialPageRoute(
                            //     builder: (context) {
                            //       return AddTaskScreen(task: task);
                            //     },
                            //     settings: RouteSettings(name: "AddTaskScreen"))
                            )
                        .then((value) {
                      if (value != null) {
                        setState(() {
                          loading = true;
                        });
                        _updateTaskList(context: context);
                        print("creando tarea");
                        SnackBarMessage.message(
                            text: value, scaffoldKey: _scaffoldKey);
                        loading = true;
                      }
                    })),
            Divider(),
          ],
        ),
      ),
    );
  }

  Widget _listTask({AsyncSnapshot<List<Task>> snapshot}) {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print("actual ${_scrollController.position.pixels}");
        print("max: ${_scrollController.position.maxScrollExtent}");
        // taskBloc.getTasks();
      }
    });
    int completedTaskCount = 0;
    completedTaskCount =
        snapshot.data.where((Task task) => task.status == 1).toList().length;
    return ListView.builder(
        physics: BouncingScrollPhysics(),
        controller: _scrollController,
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
            return _buidTask(task: snapshot.data[index - 1], context: context);
          }
        });
  }
}
