import 'dart:core';
import 'dart:io';
//import 'dart:typed_data';

import 'package:allergensapp/Beings/Allergene.dart';
import 'package:allergensapp/Beings/MAllergeneReaction.dart';
import 'package:allergensapp/Beings/MFamilyAllergene.dart';
import 'package:allergensapp/Beings/MolecularAllergene.dart';
import 'package:allergensapp/Beings/MolecularFamily.dart';
import 'package:allergensapp/Beings/Reaction.dart';
import 'package:flutter/services.dart';
//import 'package:flutter/services.dart';
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
  static final reactionToMolecularAllergeneTable = 'molecular_Allergene_reaction_relational_link';
  static final molecularFamilyToAllergeneTable = 'molecular_family_Allergene_relational_link';


  static final int databaseVersion = 1;

  static final String allergeneTableCreation = '''
  CREATE TABLE IF NOT EXISTS "Allergene" (
  "id"	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
  "name"	TEXT NOT NULL,
  "Allergene_type"	INTEGER NOT NULL,
  "image"	BLOB,
  "color"	TEXT NOT NULL,
  "cross_group"	TEXT
  );''';

  static final String mAllergeneReactionTableCreation = ''' CREATE TABLE IF NOT EXISTS "molecular_Allergene_reaction_relational_link" (
  "id"	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
  "molecular_Allergene_id"	INTEGER NOT NULL,
  "reaction_id"	INTEGER NOT NULL
  );''';


  static final String reactionTableCreation= '''CREATE TABLE "reaction" (
	"id"	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
	"level"	INTEGER NOT NULL,
	"adapted_treatment"	TEXT NOT NULL
  );''';

  static final String mAllergenTableCreation = '''CREATE TABLE "molecular_Allergene" (
  "id"	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
  "name"	TEXT NOT NULL,
  "molecular_family_id"	INTEGER NOT NULL,
  "color"	TEXT NOT NULL
  );''';

  static final String mFamilyAllergenTableCreation = '''CREATE TABLE IF NOT EXISTS "molecular_family_Allergene_relational_link" (
  "id"	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
  "Allergene_1_id"	INTEGER NOT NULL,
  "Allergene_2_id"	INTEGER NOT NULL,
  "molecular_family_id"	INTEGER NOT NULL,
  "occurrence_frequency"	INTEGER
  );''';

  static final String mFamilyTableCreation = '''CREATE TABLE "molecular_family" (
  "id"	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
  "name"	TEXT NOT NULL,
  "color"	TEXT NOT NULL
  );''';

  static final String foodTableCreation = '''CREATE TABLE IF NOT EXISTS "food" (
  "id"	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,
  "name"	TEXT NOT NULL,
  "Allergene_id"	INTEGER NOT NULL
  );''';




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




  /*Future<String> get _localPath async {
    //final directory = await getApplicationDocumentsDirectory();
    return (await getApplicationDocumentsDirectory()).path;
  }*/


  /*Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/AllergensDB.db');
  }*/






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


    // Check if the database exists
    var exists = await databaseExists(path);

    // Make sure the parent directory exists
    if (!exists) {
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}
      // Copy from asset
      ByteData data = await rootBundle.load(join("assets", "AllergensDB.db"));
      List<int> bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);
    }

    // open the database
    return await openDatabase(path, readOnly: false);


  // !!!!!!!!!!!! SAVE IN DEVICE MEMORY !!!!!!!!!!!!!!
    //Directory tempDir = await getApplicationDocumentsDirectory();
    /**String tempDirPath = join(tempDir.path, "AllergensDB.db");*/
    //print(tempDir.path);

    // Only copy if the database doesn't exist
    /**if (FileSystemEntity.typeSync(tempDirPath) == FileSystemEntityType.notFound){

      // Load database from asset and copy
      ByteData data = await rootBundle.load(join('assets', 'AllergensDB.db'));
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Save copied asset to documents
      await new File(path).writeAsBytes(bytes);
    }*/

    return await openDatabase(path, version: databaseVersion,
        onCreate: (Database db, int version) async {
          await db.execute(allergeneTableCreation);
          await db.execute(mAllergeneReactionTableCreation);
          await db.execute(reactionTableCreation);
          await db.execute(mAllergenTableCreation);
          await db.execute(mFamilyAllergenTableCreation);
          await db.execute(mFamilyTableCreation);
          await db.execute(foodTableCreation);
    });

  }







  // SQL code to create the database table (executed only if not found)
  /**Future _onCreate(Database db, int version) async {
    await db.execute(databaseQuery);
  }*/
  
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








  Future<int> insertQuery(Map<String, dynamic> row, String table) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }


  Future<int> updateQuery(Map<String, dynamic> row, String table) async {
    Database db = await instance.database;
    int id = row['id'];
    return await db.update(table, row, where: 'id = ?', whereArgs: [id]);
  }


  Future<int> deleteQuery(int id, String table) async {
    Database db = await instance.database;
    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }













/// ****************************** Allergene **********************************/

  Future<List<Allergene>> getAllergenes() async {
    Database db = await instance.database;
    var res = await db.query(allergeneTable);
    return res.isNotEmpty ? res.map((Map<dynamic, dynamic> row) => Allergene.fromJson(row)).toList(): [];
  }

  Future<List<Allergene>> getAllergeneOfType(int type) async {
    Database db = await instance.database;
    var res = await db.query(allergeneTable, where: 'Allergene_type = $type');
    return res.isNotEmpty ? res.map((Map<dynamic, dynamic> row) => Allergene.fromJson(row)).toList(): [];
  }

  Future<int> insertAllergene(Map<String, dynamic> row) async { return insertQuery(row, allergeneTable);}
  Future<int> updateAllergene(Map<String, dynamic> row) async { return updateQuery(row, allergeneTable);}
  Future<int> deleteAllergene(int id) async {
    Database db = await instance.database;
    await db.rawDelete('DELETE FROM $molecularFamilyToAllergeneTable WHERE Allergene_1_id = $id OR Allergene_2_id = $id;');
    return deleteQuery(id, allergeneTable);
  }




/// ****************************** MolecularFamily **********************************/

  Future<List<MolecularFamily>> getMolecularFamilies() async {
    Database db = await instance.database;
    var res = await db.query(molecularFamilyTable);
    return res.isNotEmpty ? res.map((c) => MolecularFamily.fromJson(c)).toList() : [];
  }

  Future<List<MolecularFamily>> getMolecularFamiliesOfAllergeneCombination(int allergeneId1,int allergeneId2) async {
    Database db = await instance.database;
    //var res = await db.query(molecularFamilyTable, where: '$molecularFamilyTable.id in (SELECT molecular_family_id FROM $molecularFamilyToAllergeneTable WHERE $molecularFamilyToAllergeneTable.Allergene_1_id = $allergeneId1 AND $molecularFamilyToAllergeneTable.Allergene_2_id = $allergeneId2)');
    var res = await db.rawQuery("SELECT $molecularFamilyTable.id,name,color,occurrence_frequency FROM $molecularFamilyTable JOIN $molecularFamilyToAllergeneTable ON $molecularFamilyTable.id = $molecularFamilyToAllergeneTable.molecular_family_id"
        " WHERE $molecularFamilyTable.id in (SELECT molecular_family_id FROM $molecularFamilyToAllergeneTable WHERE $molecularFamilyToAllergeneTable.Allergene_1_id = $allergeneId1 AND $molecularFamilyToAllergeneTable.Allergene_2_id = $allergeneId2)");
    return res.isNotEmpty ? res.map((c) => MolecularFamily.fromJson(c)).toList() : [];
  }

  Future<int> insertMolecularFamily(Map<String, dynamic> row) async { return insertQuery(row, molecularFamilyTable);}
  Future<int> updateMolecularFamily(Map<String, dynamic> row) async { return updateQuery(row, molecularFamilyTable);}
  Future<int> deleteMolecularFamily(int id) async {
    Database db = await instance.database;
    await db.rawDelete('DELETE FROM $molecularFamilyToAllergeneTable WHERE molecular_family_id = $id;');
    await db.rawDelete('DELETE FROM $molecularAllergeneTable WHERE molecular_family_id = $id;');
    return deleteQuery(id, molecularFamilyTable);
  }




  /// ****************************** MolecularAllergene **********************************/

  Future<List<MolecularAllergene>> getMolecularAllergenes() async {
    Database db = await instance.database;
    var res = await db.query(molecularAllergeneTable);
    return res.isNotEmpty ? res.map((c) => MolecularAllergene.fromJson(c)).toList() : [];
  }

  Future<List<MolecularAllergene>> getMolecularAllergenesFromMFamily(int id) async {
    Database db = await instance.database;
    var res = await db.query(molecularAllergeneTable, where: 'molecular_family_id = $id');
    return res.isNotEmpty ? res.map((c) => MolecularAllergene.fromJson(c)).toList() : [];
  }

  Future<int> insertMolecularAllergene(Map<String, dynamic> row) async { return insertQuery(row, molecularAllergeneTable);}
  Future<int> updateMolecularAllergene(Map<String, dynamic> row) async { return updateQuery(row, molecularAllergeneTable);}
  Future<int> deleteMolecularAllergene(int id) async {
    Database db = await instance.database;
    await db.rawDelete('DELETE FROM $reactionToMolecularAllergeneTable WHERE molecular_Allergene_id = $id;');
    return deleteQuery(id, molecularAllergeneTable);
  }




  /// ****************************** Reaction **********************************/

  Future<List<Reaction>> getReactions() async {
    Database db = await instance.database;
    var res = await db.query(reactionTable);
    return res.isNotEmpty ? res.map((c) => Reaction.fromJson(c)).toList() : [];
  }

  Future<List<Reaction>> getReactionsOfMolecularAllergenes(int mAllergeneId) async {
    Database db = await instance.database;
    var res = await db.query(reactionTable, where: '$reactionTable.id in (SELECT reaction_id FROM $reactionToMolecularAllergeneTable WHERE $reactionToMolecularAllergeneTable.molecular_Allergene_id = $mAllergeneId)');
    return res.isNotEmpty ? res.map((c) => Reaction.fromJson(c)).toList() : [];
  }

  Future<int> insertReaction(Map<String, dynamic> row) async { return insertQuery(row, reactionTable);}
  Future<int> updateReaction(Map<String, dynamic> row) async { return updateQuery(row, reactionTable);}
  Future<int> deleteReaction(int id) async {
    Database db = await instance.database;
    await db.rawDelete('DELETE FROM $reactionToMolecularAllergeneTable WHERE reaction_id = $id;');
    return deleteQuery(id, reactionTable);
  }





  /// ****************************** molecular_family_Allergene_relational_link **********************************/

  Future<List<MFamilyAllergene>> getMolecularFamilyToAllergeneList() async {
    Database db = await instance.database;
    var res = await db.query(molecularFamilyToAllergeneTable);
    return res.isNotEmpty ? res.map((c) => MFamilyAllergene.fromJson(c)).toList() : [];
  }

  Future<int> insertMolecularFamilyToAllergene(Map<String, dynamic> row) async { return insertQuery(row, molecularFamilyToAllergeneTable);}
  Future<int> updateMolecularFamilyToAllergene(Map<String, dynamic> row) async {return updateQuery(row, molecularFamilyToAllergeneTable);}
  Future<int> deleteMolecularFamilyToAllergene(int id) async { return deleteQuery(id, molecularFamilyToAllergeneTable);}







  /// ****************************** molecular_Allergene_reaction_relational_link **********************************/

  Future<List<MAllergeneReaction>> getReactionToMolecularAllergeneList() async {
    Database db = await instance.database;
    var res = await db.query(reactionToMolecularAllergeneTable);
    return res.isNotEmpty ? res.map((c) => MAllergeneReaction.fromJson(c)).toList() : [];
  }

  Future<int> insertReactionToMolecularAllergene(Map<String, dynamic> row) async { return insertQuery(row, reactionToMolecularAllergeneTable);}
  Future<int> updateReactionToMolecularAllergene(Map<String, dynamic> row) async {return updateQuery(row, reactionToMolecularAllergeneTable);}
  Future<int> deleteReactionToMolecularAllergene(int id) async { return deleteQuery(id, reactionToMolecularAllergeneTable);}











}