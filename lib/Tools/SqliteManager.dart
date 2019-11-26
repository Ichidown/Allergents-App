import 'dart:ui';
import 'package:allergensapp/Beings/ArcItem.dart';
import 'package:flutter/material.dart';



class SqliteManager {


  //Future<Database> database;

  /*SqliteManager(){

  }*/



/*
  Future<void> databaseLog(String functionName, String Sql) async {
  // Open the database and store the reference.
    database = openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'doggie_database.db'),
    );
  }

  // Define a function that inserts dogs into the database
  Future<void> insertDog(Allergene allergene) async {
    final Database db = await database;
    await db.insert('Allergene', allergene.toMap(), conflictAlgorithm: ConflictAlgorithm.replace,);
  }
*/















  static List<ArcItem> getPolens(){
    List<ArcItem> arcItems = List<ArcItem>();

    arcItems.add(ArcItem("arachides", Colors.deepOrangeAccent,));
    arcItems.add(ArcItem("Fruits exotiques", Colors.cyan,));
    arcItems.add(ArcItem("Farines", Colors.lightGreen,));
    arcItems.add(ArcItem("Céréales", Color(0xFFfe0944),));

    arcItems.add(ArcItem("Rosacées", Color(0xFFF9D976),));
    arcItems.add(ArcItem("Juglandacées", Color(0xFF21e1fa),));
    arcItems.add(ArcItem("Corylacées", Color(0xFF3ee98a),));
    arcItems.add(ArcItem("Solanacées", Colors.lightGreen,));
    arcItems.add(ArcItem("Ombellifères", Color(0xFF21e1fa),));
    arcItems.add(ArcItem("Cucurbutacées",Colors.redAccent[100],));
    arcItems.add(ArcItem("Légumineuses", Color(0xFF21e1fa),));
    arcItems.add(ArcItem("Soja", Color(0xFFfe0944),));
    arcItems.add(ArcItem("latex",Color(0xFF21e1fa),));
    arcItems.add(ArcItem("Banane", Color(0xFF3ee98a),));
    arcItems.add(ArcItem("Cucurbutacées",Colors.redAccent[100],));
    arcItems.add(ArcItem("Légumineuses", Color(0xFF21e1fa),));
    arcItems.add(ArcItem("Soja", Color(0xFFfe0944),));
    arcItems.add(ArcItem("latex",Color(0xFF21e1fa),));
    arcItems.add(ArcItem("Banane", Color(0xFF3ee98a),));


    return arcItems;
  }

}












