import 'package:flutter/material.dart';

class ShowSnackbar{
  static void snackBar(GlobalKey<ScaffoldState> _scaffoldKey, String text) {
    _scaffoldKey.currentState.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(text),
    ));
  }
}