import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TabTitleBar extends StatelessWidget{
  String title;
  TabTitleBar(this.title);
  @override
  Widget build(BuildContext context) {
    return Container(padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(color: Colors.blueAccent,),
        child: Row(mainAxisAlignment: MainAxisAlignment.center,children: <Widget>[
          Text(title,style: TextStyle(color: Colors.white),)
        ],)
    );
  }
}


