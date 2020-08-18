import 'package:flutter/material.dart';
import 'package:task_app/helpers/database_helper.dart';
import 'package:task_app/task/models/task_model.dart';
import 'package:intl/intl.dart';

class AddTaskScreen extends StatefulWidget {
  final Function updateTaskList;
  final Task task;
  AddTaskScreen({Key key, this.task, this.updateTaskList}) : super(key: key);

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title;
  String _priority;
  DateTime _dateTime = DateTime.now();
  TextEditingController _dateController = TextEditingController();
  final List<String> _priorities = ['Low', 'Medium', 'High'];

  final DateFormat _dateFormatter = DateFormat('MMMM dd, yyyy');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.task != null) {
      _title = widget.task.title;
      _dateTime = widget.task.date;
      _priority = widget.task.priority;
    }
    _dateController.text = _dateFormatter.format(_dateTime);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _dateController.dispose();
  }

  void _handleDatePicker() async {
    final DateTime date = await showDatePicker(
        context: context,
        initialDate: _dateTime,
        firstDate: DateTime(1970),
        lastDate: DateTime(2100));
    if (date != null && date != _dateTime) {
      setState(() {
        _dateTime = date;
      });
      _dateController.text = _dateFormatter.format(_dateTime);
    }
  }

  _submit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      print('$_title, $_dateTime, $_priority');

      Task task = Task(title: _title, date: _dateTime, priority: _priority);
      if (widget.task == null) {
        // Insert the task to our user's database
        task.status = 0;
        DatabaseHelper.instance.insertTask(task);
      } else {
        // Update the task
        task.id = widget.task.id;
        task.status = widget.task.status;
        DatabaseHelper.instance.updateTask(task);
      }
      widget.updateTaskList();
      Navigator.pop(context);
    }
  }

  _delete() {
    DatabaseHelper.instance.deleteTask(widget.task.id);
    widget.updateTaskList();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 80.0, horizontal: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                  onTap: () => Navigator.pop(context),
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
                Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.0),
                          child: TextFormField(
                            style: TextStyle(fontSize: 18.0),
                            decoration: InputDecoration(
                                labelText: 'Title',
                                labelStyle: TextStyle(fontSize: 18.0),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0))),
                            validator: (input) => input.trim().isEmpty
                                ? 'Please enter a task title'
                                : null,
                            onSaved: (input) => this._title = input,
                            initialValue: this._title,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.0),
                          child: TextFormField(
                            readOnly: true,
                            style: TextStyle(fontSize: 18.0),
                            controller: _dateController,
                            onTap: _handleDatePicker,
                            decoration: InputDecoration(
                                labelText: 'Date',
                                labelStyle: TextStyle(fontSize: 18.0),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0))),
                            autofocus: false,
                          ),
                        ),
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
                              labelStyle: TextStyle(fontSize: 18.0),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            validator: (input) => this._priority == null
                                ? 'Please select a priority level'
                                : null,
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
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
