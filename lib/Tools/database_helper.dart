import 'dart:io';

import 'package:allergensapp/Beings/Allergene.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {

  // static final _databaseName = "AllergensDB.db";
  // static final _databaseVersion = 1;

  static final table = 'my_table';
  static final columnId = '_id';
  //static final columnName = 'name';
  //static final columnAge = 'age';


  static final String databaseQuery = '''
  BEGIN TRANSACTION;
  CREATE TABLE IF NOT EXISTS "Allergene" (
  "id"	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
  "name"	TEXT NOT NULL,
  "Allergene_type"	INTEGER NOT NULL,
  "image"	BLOB,
  "color"	TEXT NOT NULL
  );
  CREATE TABLE IF NOT EXISTS "molecular_Allergene_reaction_relational_link" (
  "id"	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
  "molecular_Allergene_id"	INTEGER NOT NULL,
  "reaction_id"	INTEGER NOT NULL
  );
  CREATE TABLE IF NOT EXISTS "reaction" (
  "id"	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
  "name"	TEXT NOT NULL,
  "level"	INTEGER NOT NULL
  );
  CREATE TABLE IF NOT EXISTS "molecular_Allergene" (
  "id"	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
  "name"	TEXT NOT NULL,
  "molecular_family_id"	INTEGER NOT NULL
  );
  CREATE TABLE IF NOT EXISTS "molecular_family_Allergene_relational_link" (
  "id"	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
  "Allergene_1_id"	INTEGER NOT NULL,
  "Allergene_2_id"	INTEGER NOT NULL,
  "molecular_family_id"	INTEGER NOT NULL
  );
  CREATE TABLE IF NOT EXISTS "molecular_family" (
  "id"	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
  "name"	TEXT NOT NULL
  );
  CREATE TABLE IF NOT EXISTS "food" (
  "id"	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
  "name"	TEXT NOT NULL,
  "Allergene_id"	INTEGER NOT NULL
  );
  COMMIT;
  ''';





  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {

    // Construct a file path to copy database to
    /** DESKTOP **/
    /**var context = new p.Context(style: Style.platform);
    String path = context.join('assets', 'AllergensDB.db');
     OR just use this bellow (Not yet tested)
    String path = p.join('assets', 'AllergensDB.db');
    **/

    /** MOBILE **/
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "AllergensDB.db");

    // Only copy if the database doesn't exist
    if (FileSystemEntity.typeSync(path) == FileSystemEntityType.notFound){
      // Load database from asset and copy
      ByteData data = await rootBundle.load(join('assets', 'AllergensDB.db'));
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Save copied asset to documents
      await new File(path).writeAsBytes(bytes);
    }

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }







  // SQL code to create the database table (executed only if not found)
  Future _onCreate(Database db, int version) async {
    await db.execute(databaseQuery);
  }

  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert('Allergene', row);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query('Allergene');
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }













  Future<List<Allergene>> getAllergenes() async {
    List<Allergene> allergeneList = List<Allergene>();

    /*allergeneList.add(Allergene(0,"arachides", 1,''));
    allergeneList.add(Allergene(1,"Fruits exotiques", 0,''));
    allergeneList.add(Allergene(2,"Farines", 1,''));
    allergeneList.add(Allergene(3,"Céréales", 0,''));
    allergeneList.add(Allergene(4,"Rosacées", 0,''));
    allergeneList.add(Allergene(5,"Juglandacées", 0,''));
    allergeneList.add(Allergene(6,"Corylacées", 1,''));
    allergeneList.add(Allergene(7,"Solanacées", 1,''));
    allergeneList.add(Allergene(8,"Ombellifères", 0,''));
    allergeneList.add(Allergene(9,"Cucurbutacées",1,''));
    allergeneList.add(Allergene(10,"Légumineuses", 0,''));
    allergeneList.add(Allergene(11,"Soja", 0,''));
    allergeneList.add(Allergene(12,"latex",1,''));
    allergeneList.add(Allergene(13,"Banane", 1,''));*/

    Database db = await instance.database;
    var res = await db.query('Allergene');

    if(res.isNotEmpty) {print( 'XXXXXXXXXXX ${res.length} XXXXXXXXXXXX');}
    else print('YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY');

    return res.isNotEmpty ? res.map((c) => Allergene.fromJson(c)).toList() : [];
  }

}