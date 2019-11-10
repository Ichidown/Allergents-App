
import 'dart:async';
import 'package:flutter/material.dart';


class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> with SingleTickerProviderStateMixin{

  AnimationController animationController;
  Animation animation;

  double opacity;
  double dimensions;
  int duration = 1;
  bool isShown = false;

  @override
  void initState() {
    // TODO: implement initState

    animationController = AnimationController(duration: const Duration(seconds: 1),vsync: this);
    /*animation = Tween(begin: 100, end: 5000.0).animate(animationController)..addListener((){
      setState(() {
        print(animation.value);

      });

    });
    animation.addStatusListener((status){
      if(status == AnimationStatus.completed){
        animationController.reverse();
      } else if(status == AnimationStatus.dismissed){
        animationController.forward();
      }
    });*/

    //animation = CurvedAnimation(parent: animationController, curve: Curves.easeIn);
    // Animation<int> alpha = IntTween(begin: 0, end: 255).animate(animationController);
    animation = Tween<double>(begin: 0, end: 300).animate(animationController)
           ..addListener(() {
             setState(() {
               // The state that has changed here is the animation object’s value.
             });
           });
    // animationController.forward();


    opacity = 0.5;
    dimensions = 250;

    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    //animationController.forward();
    //startSplashScreenTimer();

    setState(() {
      dimensions = 100;
      opacity = 0;
      isShown = false;
    });



    return Center(
      child: Column(children: <Widget>[
        RaisedButton(child: Text('Animate',style: TextStyle(color: Colors.redAccent),),onPressed: (){
          setState(() {
            dimensions = 300;
            opacity = 1;
            isShown = false;
          });
        },),
        AnimatedOpacity(duration: Duration(seconds: duration),opacity: isShown?1:0,child:
        AnimatedContainer(
          onEnd: (){Navigator.pushReplacementNamed(context,'/home');},
          duration: Duration(seconds: duration),
          width: isShown?200:300,
          height: isShown?200:300,
          //width: animation.value,
          //height: animation.value,
          child: //AnimatedLogo()
          //FlutterLogo(),
          FittedBox(child: Icon(Icons.directions_car, color: Colors.greenAccent,),),
        )
          ,)
      ],)

    );



      /*Scaffold(body :
        SizedBox.expand(
          child: FlatButton(child: Text('LOADING SCREEN'), onPressed: (){
            print('Loading');
            //Navigator.pushNamed(context, '/home');
            Navigator.pushReplacementNamed(context,'/home');
            },),
        )
    );*/
  }


  /**@override
  void dispose(){
    animationController.dispose();
    super.dispose();
  }*/




  /**startSplashScreenTimer() async{
    //var duration = const Duration(seconds: 3);

    return Timer(Duration(seconds: 3), (){
       Navigator.pushNamed(context, '/home');
    });

  }*/






}



/*class AnimatedLogo extends AnimatedWidget {
  AnimatedLogo({Key key, Animation<double> animation})
      : super(key: key, listenable: animation);

  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        height: animation.value,
        width: animation.value,
        child: FlutterLogo(),
      ),
    );
  }
}*/