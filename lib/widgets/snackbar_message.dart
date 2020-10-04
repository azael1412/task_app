import 'package:flutter/material.dart';

class SnackBarMessage {
  static void message(
      {@required String text, @required GlobalKey<ScaffoldState> scaffoldKey}) {
    final snackbar = new SnackBar(
      content: Text(text),
      duration: Duration(seconds: 3),
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
  }
}
