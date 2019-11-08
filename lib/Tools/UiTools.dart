import 'package:flutter/material.dart';

class UiTools {

  static void newSnackBar(String msg, Color color, int duration,context){
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: color,
      duration: Duration(seconds: duration),
    ));
  }







}