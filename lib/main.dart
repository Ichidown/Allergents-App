import 'package:allergensapp/Tools/SqliteManager.dart';
import 'package:flutter/material.dart';
import 'Pages/DemonstrationPage.dart';
import 'Pages/LoadingPage.dart';

void main() {
  runApp(MyHomePage());
}

class MyHomePage extends StatelessWidget {
  final SqliteManager sqliteManager = new SqliteManager();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(theme: new ThemeData(accentColor: Colors.blue,),
      routes: {
        '/': (context) => LoadingPage(),
        '/home': (context) => DemonstrationPage(),
      },
    );
  }

}

