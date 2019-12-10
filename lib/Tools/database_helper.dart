import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:allergensapp/Beings/Allergen.dart';
import 'package:allergensapp/Beings/Conclusion.dart';
import 'package:allergensapp/Beings/MAllergenReaction.dart';
import 'package:allergensapp/Beings/MFamilyAllergen.dart';
import 'package:allergensapp/Beings/MolecularAllergen.dart';
import 'package:allergensapp/Beings/MolecularFamily.dart';
import 'package:allergensapp/Beings/Reaction.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {

  static final allergenTable = 'Allergene';
  static final molecularFamilyTable = 'molecular_family';
  static final molecularAllergenTable = 'molecular_Allergene';
  static final reactionTable = 'reaction';
  static final reactionToMolecularAllergenTable = 'molecular_Allergene_reaction_relational_link';
  static final molecularFamilyToAllergenTable = 'molecular_family_Allergene_relational_link';
  static final source1Source2MfMaLinks = 'source1_source2_mf_ma_links';

  static final int databaseVersion = 1;

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

    Directory documentsDirectory = await getExternalStorageDirectory();
    String path = '${documentsDirectory.path}/AllergensDB.db';

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
  }


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

  Future<List<Allergen>> getAllergens() async {
    Database db = await instance.database;
    var res = await db.query(allergenTable,orderBy: "name");
    //var res = await db.rawQuery("SELECT id,name,Allergene_type,color,cross_group,image FROM $allergeneTable;");
    return res.isNotEmpty ? res.map((Map<dynamic, dynamic> row) => Allergen.fromJson(row)).toList(): [];
  }

  Future<List<Allergen>> getAllergenOfType(int type) async {
    Database db = await instance.database;
    var res = await db.query(allergenTable, where: 'Allergene_type = $type',orderBy: "name");
    return res.isNotEmpty ? res.map((Map<dynamic, dynamic> row) => Allergen.fromJson(row)).toList(): [];
  }

  Future<int> insertAllergen(Map<String, dynamic> row) async { return insertQuery(row, allergenTable);}
  Future<int> updateAllergen(Map<String, dynamic> row) async { return updateQuery(row, allergenTable);}
  Future<int> deleteAllergen(int id) async {
    Database db = await instance.database;
    await db.rawDelete('DELETE FROM $molecularFamilyToAllergenTable WHERE Allergene_1_id = $id OR Allergene_2_id = $id;');
    return deleteQuery(id, allergenTable);
  }


  /**Future<Allergene> getAllergenImage(Allergene allergene) async {
    Database db = await instance.database;
    //var res = await db.query(allergeneTable);
    var res = await db.rawQuery("SELECT image FROM $allergeneTable WHERE id = ${allergene.id} LIMIT 1;");
    allergene.image = res[0].values.single;
    return allergene; //res.isNotEmpty ? res.map((Map<dynamic, dynamic> row) => Allergene.fromJson(row)).toList(): [];
  }*/




/// ****************************** MolecularFamily **********************************/

  Future<List<MolecularFamily>> getMolecularFamilies() async {
    Database db = await instance.database;
    var res = await db.query(molecularFamilyTable,orderBy: "name");
    return res.isNotEmpty ? res.map((c) => MolecularFamily.fromJson(c)).toList() : [];
  }

  Future<List<MolecularFamily>> getMolecularFamiliesOfAllergenCombination(int allergenId1,int allergenId2) async {
    Database db = await instance.database;
    var res = await db.rawQuery(
        "SELECT $molecularFamilyTable.id,$molecularFamilyTable.name,$molecularFamilyTable.color,$molecularFamilyToAllergenTable.occurrence_frequency FROM $molecularFamilyTable "

        "LEFT OUTER JOIN $molecularFamilyToAllergenTable ON ($molecularFamilyTable.id = $molecularFamilyToAllergenTable.molecular_family_id)"
            "WHERE "
            "$molecularFamilyToAllergenTable.Allergene_1_id = $allergenId1 AND "
            "$molecularFamilyToAllergenTable.Allergene_2_id = $allergenId2"
        " ORDER BY name ASC;");
    return res.isNotEmpty ? res.map((c) => MolecularFamily.fromJson(c)).toList() : [];
  }

  Future<int> insertMolecularFamily(Map<String, dynamic> row) async { return insertQuery(row, molecularFamilyTable);}
  Future<int> updateMolecularFamily(Map<String, dynamic> row) async { return updateQuery(row, molecularFamilyTable);}
  Future<int> deleteMolecularFamily(int id) async {
    Database db = await instance.database;
    await db.rawDelete('DELETE FROM $molecularFamilyToAllergenTable WHERE molecular_family_id = $id;');
    await db.rawDelete('DELETE FROM $molecularAllergenTable WHERE molecular_family_id = $id;');
    return deleteQuery(id, molecularFamilyTable);
  }




  /// ****************************** MolecularAllergene **********************************/

  Future<List<MolecularAllergen>> getMolecularAllergens() async {
    Database db = await instance.database;
    var res = await db.query(molecularAllergenTable,orderBy: "name");
    return res.isNotEmpty ? res.map((c) => MolecularAllergen.fromJson(c)).toList() : [];
  }

  Future<List<MolecularAllergen>> getMolecularAllergensFromMFamily(int id) async {
    Database db = await instance.database;
    //var res = await db.query(molecularAllergenTable, where: 'molecular_family_id = $id',orderBy: "name");

    var res = await db.rawQuery(
        "SELECT * FROM $molecularAllergenTable "
            //"LEFT OUTER JOIN $source1Source2MfMaLinks ON ($molecularAllergenTable.id = $source1Source2MfMaLinks.molecular_Allergene_id)"
            "WHERE "
            " $molecularAllergenTable.molecular_family_id =  $id"// AND"
            //"$source1Source2MfMaLinks.molecular_family_Allergene_relational_link_id = $allergenId1 AND "
            /*"$molecularFamilyToAllergenTable.Allergene_2_id = $allergenId2"*/

            " ORDER BY name ASC;");

    return res.isNotEmpty ? res.map((c) => MolecularAllergen.fromJson(c)).toList() : [];
  }

  Future<int> insertMolecularAllergen(Map<String, dynamic> row) async { return insertQuery(row, molecularAllergenTable);}
  Future<int> updateMolecularAllergen(Map<String, dynamic> row) async { return updateQuery(row, molecularAllergenTable);}
  Future<int> deleteMolecularAllergen(int id) async {
    Database db = await instance.database;
    await db.rawDelete('DELETE FROM $reactionToMolecularAllergenTable WHERE molecular_Allergene_id = $id;');
    return deleteQuery(id, molecularAllergenTable);
  }




  /// ****************************** Reaction **********************************/

  Future<List<Reaction>> getReactions() async {
    Database db = await instance.database;
    var res = await db.query(reactionTable);
    return res.isNotEmpty ? res.map((c) => Reaction.fromJson(c)).toList() : [];
  }

  Future<List<Reaction>> getReactionsOfMolecularAllergenes(int mAllergeneId) async {
    Database db = await instance.database;
    var res = await db.query(reactionTable, where: '$reactionTable.id in (SELECT reaction_id FROM $reactionToMolecularAllergenTable WHERE $reactionToMolecularAllergenTable.molecular_Allergene_id = $mAllergeneId)');
    return res.isNotEmpty ? res.map((c) => Reaction.fromJson(c)).toList() : [];
  }

  Future<int> insertReaction(Map<String, dynamic> row) async { return insertQuery(row, reactionTable);}
  Future<int> updateReaction(Map<String, dynamic> row) async { return updateQuery(row, reactionTable);}
  Future<int> deleteReaction(int id) async {
    Database db = await instance.database;
    return await db.rawDelete('DELETE FROM $reactionToMolecularAllergenTable WHERE reaction_id = $id;');
    // return deleteQuery(id, reactionTable);
  }





  /// ****************************** molecular_family_Allergene_relational_link **********************************/

  Future<List<MFamilyAllergen>> getMolecularFamilyToAllergeneList() async {
    Database db = await instance.database;
    var res = await db.query(molecularFamilyToAllergenTable);
    return res.isNotEmpty ? res.map((c) => MFamilyAllergen.fromJson(c)).toList() : [];
  }

  Future<int> insertMolecularFamilyToAllergen(Map<String, dynamic> row) async { return insertQuery(row, molecularFamilyToAllergenTable);}
  Future<int> updateMolecularFamilyToAllergen(Map<String, dynamic> row) async {return updateQuery(row, molecularFamilyToAllergenTable);}
  Future<int> deleteMolecularFamilyToAllergen(int id) async {
    deleteSource1Source2MfMaLinkList(id);
    return deleteQuery(id, molecularFamilyToAllergenTable);
  }







  /// ****************************** molecular_Allergene_reaction_relational_link **********************************/

  Future<List<MAllergenReaction>> getReactionToMolecularAllergeneList() async {
    Database db = await instance.database;
    var res = await db.query(reactionToMolecularAllergenTable);
    return res.isNotEmpty ? res.map((c) => MAllergenReaction.fromJson(c)).toList() : [];
  }

  Future<int> insertReactionToMolecularAllergene(Map<String, dynamic> row) async { return insertQuery(row, reactionToMolecularAllergenTable);}
  Future<int> updateReactionToMolecularAllergene(Map<String, dynamic> row) async {return updateQuery(row, reactionToMolecularAllergenTable);}
  Future<int> deleteReactionToMolecularAllergene(int id) async { return deleteQuery(id, reactionToMolecularAllergenTable);}







  /// ****************************** molecular_Allergene_reaction_relational_link **********************************/

  Future<Conclusion> getConclusion(int source1Id,int source2Id, int mFamilyId, int mAllergenId, int reactionId) async {
    Database db = await instance.database;

    var source1 = await db.rawQuery("SELECT name,cross_group FROM $allergenTable WHERE id = $source1Id LIMIT 1;");
    var source2 = await db.rawQuery("SELECT name,cross_group FROM $allergenTable WHERE id = $source2Id LIMIT 1;");
    var mFamily = await db.rawQuery("SELECT name FROM $molecularFamilyTable WHERE id = $mFamilyId LIMIT 1;");
    var mAllergen = await db.rawQuery("SELECT name FROM $molecularAllergenTable WHERE id = $mAllergenId LIMIT 1;");
    var reaction = await db.rawQuery("SELECT adapted_treatment,level FROM $reactionTable WHERE id = $reactionId LIMIT 1;");
    var frequency = await db.rawQuery("SELECT occurrence_frequency FROM $molecularFamilyToAllergenTable WHERE Allergene_1_id = $source1Id AND Allergene_2_id = $source2Id AND molecular_family_id = $mFamilyId LIMIT 1;");

    return new Conclusion(
        source1[0].values.elementAt(0),
        source2[0].values.elementAt(0),
        source1[0].values.elementAt(1),
        source2[0].values.elementAt(1),
        mFamily[0].values.single,
        frequency[0].values.single,
        mAllergen[0].values.single,
        reaction[0].values.elementAt(1),
        reaction[0].values.elementAt(0));

  }






  /// ***************************************** source1_source2_mf_ma_links *************************************************/

  Future<List<bool>> getSource1Source2MfMaLink(int mFamilyAllergenLinkId, List<MolecularAllergen> molecularAllergenList) async {
    Database db = await instance.database;
    List<bool> foundList = [];
    var res;
    //molecularAllergenIdList.forEach((int i)
    //molecularAllergenList.then((onValue) async {

      for(int i=0;i<molecularAllergenList.length;i++)
      {
        res = await db.rawQuery("SELECT 1 FROM $source1Source2MfMaLinks "
            " WHERE molecular_Allergene_id = ${molecularAllergenList[i].id} AND "
            " molecular_family_Allergene_relational_link_id = $mFamilyAllergenLinkId;");
        //print('YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY ${res[0].values.single} YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY');
        // print(res);
        //print(res.toString() == '[{1: 1}]');
        /**if(res[0] == "1") print('olaaaaaa');
            else print('hehe');*/
        foundList.add(res.toString() == '[{1: 1}]');
      }

    //});

    //return res.toString() == '[{1: 1}]';
    return foundList;
  }

  void updateSource1Source2MfMaLinkList(int mFamilyAllergenLinkId,List<int> molecularAllergenIdList) async {
    // clear related links
    deleteSource1Source2MfMaLinkList(mFamilyAllergenLinkId);
    // create given links
    molecularAllergenIdList.forEach((int id){
      insertQuery({
        'molecular_family_Allergene_relational_link_id': mFamilyAllergenLinkId,
        'molecular_Allergene_id': id,}
        , source1Source2MfMaLinks);
    });
  }


  Future<int> deleteSource1Source2MfMaLinkList(int mFamilyAllergenLinkId) async {
    Database db = await instance.database;
    return await db.rawDelete('DELETE FROM $source1Source2MfMaLinks WHERE molecular_family_Allergene_relational_link_id = $mFamilyAllergenLinkId;');
    //return deleteQuery(id, molecularAllergenTable);
  }













}