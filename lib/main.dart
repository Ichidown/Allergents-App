import 'package:allergensapp/Tools/SqliteManager.dart';
import 'package:flutter/material.dart';
import 'Pages/DemonstrationPage.dart';
import 'Pages/LoadingPage.dart';
import 'package:splashscreen/splashscreen.dart';

void main() {
  runApp(MyHomePage());
}

class MyHomePage extends StatelessWidget {
  final SqliteManager sqliteManager = new SqliteManager();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(theme: new ThemeData(accentColor: Colors.blue,),
      routes: {
        //'/': (context) => LoadingPage(),
        '/': (context) => DemonstrationPage(),
      },
    );


      return new SplashScreen(
          seconds: 14,
          navigateAfterSeconds: new Text('sss'),
          title: new Text('Welcome In SplashScreen',
            style: new TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0
            ),),
          image: new Image.network('assets/images/india3_19.jpg'),
          backgroundColor: Colors.white,
          styleTextUnderTheLoader: new TextStyle(),
          photoSize: 100.0,
          onClick: ()=>print("Flutter Egypt"),
          loaderColor: Colors.red
      );

  }

}

