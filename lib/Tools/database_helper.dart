import 'dart:io';
import 'dart:typed_data';

import 'package:allergensapp/Beings/Allergene.dart';
import 'package:allergensapp/Beings/MolecularAllergene.dart';
import 'package:allergensapp/Beings/MolecularFamily.dart';
import 'package:allergensapp/Beings/Reaction.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {

  // static final _databaseName = "AllergensDB.db";
  // static final _databaseVersion = 1;

  //static final table = 'my_table';
  //static final columnId = '_id';
  //static final columnName = 'name';
  //static final columnAge = 'age';

  static final allergeneTable = 'Allergene';
  static final molecularFamilyTable = 'molecular_family';
  static final molecularAllergeneTable = 'molecular_Allergene';
  static final reactionTable = 'reaction';


  static final int databaseVersion = 1;
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
  CREATE TABLE "reaction" (
	"id"	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
	"level"	INTEGER NOT NULL,
	"adapted_treatment"	TEXT NOT NULL
  );
  CREATE TABLE "molecular_Allergene" (
	"id"	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
	"name"	TEXT NOT NULL,
	"molecular_family_id"	INTEGER NOT NULL,
	"color"	TEXT NOT NULL
  );
  CREATE TABLE IF NOT EXISTS "molecular_family_Allergene_relational_link" (
  "id"	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
  "Allergene_1_id"	INTEGER NOT NULL,
  "Allergene_2_id"	INTEGER NOT NULL,
  "molecular_family_id"	INTEGER NOT NULL
  );
  CREATE TABLE "molecular_family" (
	"id"	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
	"name"	TEXT NOT NULL,
	"color"	TEXT NOT NULL
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




  Future<String> get _localPath async {
    //final directory = await getApplicationDocumentsDirectory();
    return (await getApplicationDocumentsDirectory()).path;
  }


  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/AllergensDB.db');
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


  // !!!!!!!!!!!! SAVE IN DEVICE MEMORY !!!!!!!!!!!!!!
    Directory tempDir = await getTemporaryDirectory();
    String tempDirPath = join(tempDir.path, "AllergensDB.db");
    //print(tempDir.path);

    // Only copy if the database doesn't exist
    if (FileSystemEntity.typeSync(tempDirPath) == FileSystemEntityType.notFound){

      // Load database from asset and copy
      ByteData data = await rootBundle.load(join('assets', 'AllergensDB.db'));
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Save copied asset to documents
      await new File(path).writeAsBytes(bytes);
    }

    return await openDatabase(path, version: databaseVersion, onCreate: _onCreate);
  }







  // SQL code to create the database table (executed only if not found)
  Future _onCreate(Database db, int version) async {
    await db.execute(databaseQuery);
  }
  
  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  /*Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query('Allergene');
  }*/

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  /**Future<int> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }*/











/// ****************************** Allergene **********************************/

  Future<List<Allergene>> getAllergenes() async {
    Database db = await instance.database;
    var res = await db.query(allergeneTable);
    return res.isNotEmpty ? res.map((c) => Allergene.fromJson(c)).toList() : [];
  }


  Future<int> insertAllergene(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(allergeneTable, row);
  }


  Future<int> updateAllergene(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row['id'];
    return await db.update(allergeneTable, row, where: 'id = ?', whereArgs: [id]);
  }


  Future<int> deleteAllergene(int id) async {
    Database db = await instance.database;
    return await db.delete(allergeneTable, where: 'id = ?', whereArgs: [id]);
  }








/// ****************************** MolecularFamily **********************************/

  Future<List<MolecularFamily>> getMolecularFamilies() async {
    Database db = await instance.database;
    var res = await db.query(molecularFamilyTable);
    return res.isNotEmpty ? res.map((c) => MolecularFamily.fromJson(c)).toList() : [];
  }

  Future<int> insertMolecularFamily(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(molecularFamilyTable, row);
  }

  Future<int> updateMolecularFamily(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row['id'];
    return await db.update(molecularFamilyTable, row, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteMolecularFamily(int id) async {
    Database db = await instance.database;
    return await db.delete(molecularFamilyTable, where: 'id = ?', whereArgs: [id]);
  }







  /// ****************************** MolecularAllergene **********************************/

  Future<List<MolecularAllergene>> getMolecularAllergenes() async {
    Database db = await instance.database;
    var res = await db.query(molecularAllergeneTable);
    return res.isNotEmpty ? res.map((c) => MolecularAllergene.fromJson(c)).toList() : [];
  }

  Future<int> insertMolecularAllergene(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(molecularAllergeneTable, row);
  }

  Future<int> updateMolecularAllergene(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row['id'];
    return await db.update(molecularAllergeneTable, row, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteMolecularAllergene(int id) async {
    Database db = await instance.database;
    return await db.delete(molecularAllergeneTable, where: 'id = ?', whereArgs: [id]);
  }







  /// ****************************** Reaction **********************************/

  Future<List<Reaction>> getReactions() async {
    Database db = await instance.database;
    var res = await db.query(reactionTable);
    return res.isNotEmpty ? res.map((c) => Reaction.fromJson(c)).toList() : [];
  }

  Future<int> insertReaction(Map<String, dynamic> row) async {
    print(row);
    Database db = await instance.database;
    return await db.insert(reactionTable, row);
  }

  Future<int> updateReaction(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row['id'];
    return await db.update(reactionTable, row, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteReaction(int id) async {
    Database db = await instance.database;
    return await db.delete(reactionTable, where: 'id = ?', whereArgs: [id]);
  }




}