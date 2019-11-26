
import 'package:flutter/material.dart';


class AboutAppPage extends StatefulWidget {
  @override
  _AboutAppPageState createState() => _AboutAppPageState();
}

class _AboutAppPageState extends State<AboutAppPage> {
  static const String routeName = '/cms';


  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.grey[200],
        appBar: PreferredSize( preferredSize: Size.fromHeight(40.0), child: AppBar(title: Text('About this App'),centerTitle: true,),),
        body: Center(child: Text('MADE BY SOME DUDE HEHE'),)
    );
  }





}