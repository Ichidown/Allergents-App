
import 'dart:async';
import 'package:flutter/material.dart';


class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  Widget build(BuildContext context) {

    //startSplashScreenTimer();

    return Scaffold(
    body :
        SizedBox.expand(
          child: FlatButton(child: Text('LOADING SCREEN'), onPressed: (){
            print('Loading');
            //Navigator.pushNamed(context, '/home');
            Navigator.pushReplacementNamed(context,'/home');
            },),
        )
    );
  }




  startSplashScreenTimer() async{
    //var duration = const Duration(seconds: 3);

    return Timer(Duration(seconds: 3), (){
       Navigator.pushNamed(context, '/home');
    });

  }
}