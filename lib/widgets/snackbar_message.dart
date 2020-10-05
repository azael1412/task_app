import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class SnackBarMessage {
  static void message(
      {@required String text, @required GlobalKey<ScaffoldState> scaffoldKey}) {
    final snackbar = new SnackBar(
      content: FadeInRightBig(child: Text(text)),
      duration: Duration(seconds: 3),
    );
    scaffoldKey.currentState.showSnackBar(snackbar);
  }
}
