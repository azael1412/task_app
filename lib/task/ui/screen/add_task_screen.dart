import 'package:flutter/material.dart';
import 'package:task_app/task/models/message.dart';

import 'package:task_app/task/models/task.dart';
import 'package:task_app/task/bloc/task_bloc.dart';
import 'package:intl/intl.dart';

class AddTaskScreen extends StatefulWidget {
  final Task task;
  AddTaskScreen({Key key, this.task}) : super(key: key);

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  TaskBloc _taskBloc = TaskBloc();
  String _title;
  String _priority;
  DateTime _dateTime = DateTime.now();

  TextEditingController _dateController = TextEditingController();
  TextEditingController _titleController = TextEditingController();

  final List<String> _priorities = ['Low', 'Medium', 'High'];

  final DateFormat _dateFormatter = DateFormat('MMMM dd, yyyy', 'es_Es');
  //errors variable
  String _titleError; //= 'Please enter a task title';
  String _priorityError; //= 'Please select a priority level';
  String _dateTimeError; //= 'Please enter a task date';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.task != null) {
      _title = widget.task.title;
      _dateTime = DateTime.parse(widget.task.date);
      _priority = widget.task.priority;
    }
    _dateController.text = _dateFormatter.format(_dateTime);
    _titleController.text = _title;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _dateController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  void _handleDatePicker() async {
    final DateTime date = await showDatePicker(
      context: context,
      initialDate: _dateTime,
      firstDate: DateTime(1970),
      lastDate: DateTime(2100),
      locale: Locale('es', 'ES'),
    );
    if (date != null && date != _dateTime) {
      setState(() {
        _dateTime = date;
      });
      _dateController.text = _dateFormatter.format(_dateTime);
    }
  }

  _submit() async {
    Task task = Task(
        title: _title,
        date: "$_dateTime".substring(0, 10),
        priority: _priority);

    if (widget.task == null) {
      _taskBloc.create(task).then((response) {
        if (response is Message) {
          Navigator.pop(context, [true, response.message]);
        }
        if (response is TaskError) {
          setState(() {
            _titleError = response.title != null ? response.title[0] : null;
            _dateTimeError = response.date != null ? response.date[0] : null;
            _priorityError =
                response.priority != null ? response.priority[0] : null;
          });
        }
      });
    } else {
      task.id = widget.task.id;
      _taskBloc.update(task).then((response) {
        if (response is Message) {
          Navigator.pop(context, response.message);
        }
        if (response is TaskError) {
          setState(() {
            _titleError = response.title != null ? response.title[0] : null;
            _dateTimeError = response.date != null ? response.date[0] : null;
            _priorityError =
                response.priority != null ? response.priority[0] : null;
          });
        }
      });
    }
  }
  // }

  _delete() {
    print("delete");
    /*DatabaseHelper.instance.deleteTask(widget.task.id);
    widget.updateTaskList();
    Navigator.pop(context);*/
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        _validationBack(context: context);
        return Future.value(false);
      },
      child: Scaffold(
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 80.0, horizontal: 40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  GestureDetector(
                    onTap: () => _validationBack(
                        context: context), //Navigator.pop(context),
                    child: Icon(Icons.arrow_back_ios,
                        size: 30.0, color: Theme.of(context).primaryColor),
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    widget.task == null ? 'Add Task' : 'Update Task',
                    style: TextStyle(
                        fontSize: 40.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10.0),
                  Container(
                    child: Column(
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.0),
                            child: TextField(
                              autofocus: false,
                              keyboardType: TextInputType.name,
                              controller: _titleController,
                              onChanged: (value) => this._title = value,
                              style: TextStyle(fontSize: 18.0),
                              decoration: InputDecoration(
                                  labelText: 'Title',
                                  errorText: _titleError,
                                  labelStyle: TextStyle(fontSize: 18.0),
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0))),
                            )),
                        Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.0),
                            child: TextField(
                              readOnly: true,
                              style: TextStyle(fontSize: 18.0),
                              controller: _dateController,
                              onTap: _handleDatePicker,
                              decoration: InputDecoration(
                                  labelText: 'Date',
                                  errorText: _dateTimeError,
                                  labelStyle: TextStyle(fontSize: 18.0),
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0))),
                              autofocus: false,
                            )),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.0),
                          child: DropdownButtonFormField(
                            value: this._priority,
                            isDense: true,
                            icon: Icon(Icons.arrow_drop_down_circle),
                            iconSize: 22.0,
                            iconEnabledColor: Theme.of(context).primaryColor,
                            items: _priorities.map((String priority) {
                              return DropdownMenuItem<String>(
                                value: priority,
                                child: Text(
                                  priority,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                  ),
                                ),
                              );
                            }).toList(),
                            style: TextStyle(fontSize: 18.0),
                            decoration: InputDecoration(
                              labelText: 'Priority',
                              errorText: _priorityError,
                              labelStyle: TextStyle(fontSize: 18.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            validator: (input) => this._priorityError,
                            onChanged: (value) {
                              setState(() {
                                this._priority = value;
                              });
                            },
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 20.0),
                          height: 60.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: FlatButton(
                            child: Text(
                              widget.task == null ? 'Add' : 'Update',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                              ),
                            ),
                            onPressed: _submit,
                          ),
                        ),
                        widget.task != null
                            ? Container(
                                margin: EdgeInsets.symmetric(vertical: 20.0),
                                height: 60.0,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor,
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                child: FlatButton(
                                  child: Text(
                                    'Delete',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                  onPressed: _delete,
                                ),
                              )
                            : SizedBox.shrink(),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _validationBack({BuildContext context}) async {
    if (_titleController.text.length > 0) {
      final bool result = await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              content: Text("¿Esta seguro de salir?"),
              actions: [
                FlatButton(
                    child: Text("No"),
                    onPressed: () => Navigator.of(context).pop(false)),
                FlatButton(
                    child: Text("Si"),
                    onPressed: () => Navigator.of(context).pop(true))
              ],
            );
          });
      if (result) {
        Navigator.of(context).pop();
      }
    } else {
      Navigator.of(context).pop();
    }
  }
}
