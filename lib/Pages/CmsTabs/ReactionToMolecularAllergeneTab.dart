import 'dart:collection';

import 'package:allergensapp/Beings/MAllergeneReaction.dart';
import 'package:allergensapp/Beings/MolecularAllergene.dart';
import 'package:allergensapp/Beings/Reaction.dart';
import 'package:allergensapp/Pages/Dialogs/DeleteDialog.dart';
import 'package:allergensapp/Pages/Dialogs/ReactionToMolecularAllergeneDialog.dart';
import 'package:allergensapp/Tools/UiTools.dart';
import 'package:allergensapp/Tools/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ReactionToMolecularAllergeneTab extends StatefulWidget {
  @override
  _ReactionToMolecularAllergeneTabState createState() => _ReactionToMolecularAllergeneTabState();
}

class _ReactionToMolecularAllergeneTabState extends State<ReactionToMolecularAllergeneTab> {
  Future<List<Reaction>> reactionList;
  Future<List<MolecularAllergene>> molecularAllergeneList;
  Future<List<MAllergeneReaction>> mAllergeneReactionList;
  HashMap reactionListHash = new HashMap();
  HashMap molecularAllergeneListHash = new HashMap();
  final dbHelper = DatabaseHelper.instance;




  final String deleateMsg = 'Are you sure you want to deleate this reaction ?';


  @override
  void initState() {
    reactionList = dbHelper.getReactions();
    molecularAllergeneList = dbHelper.getMolecularAllergenes();

    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return Stack(
      children: <Widget>[

    /** Initialise reaction List HashMap */
        FutureBuilder<List<Reaction>>(
            future: reactionList,
            builder: (context, snapshot) {
              if(snapshot.hasData)
                snapshot.data.forEach((element) => reactionListHash[element.id]=element.adapted_treatment);
              return Container();
            }),
    /** Initialise molecular Allergene List HashMap */
        FutureBuilder<List<MolecularAllergene>>(
            future: molecularAllergeneList,
            builder: (context, snapshot) {
              if(snapshot.hasData)
                snapshot.data.forEach((element) => molecularAllergeneListHash[element.id]=element.name);
              return Container();
            }),


        SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 80),
            child: FutureBuilder<List<MAllergeneReaction>>(
                future: refreshMAllergeneReaction(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, i) {
                          return Card(
                              child: ListTile(
                                dense: true,
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return ReactionToMolecularAllergeneDialog(snapshot.data[i], molecularAllergeneList, reactionList);
                                      }).then((onValue) {newMAllergeneReaction(onValue);});
                                },
                                onLongPress: () {
                                  showDialog(context: context, builder: (context) {
                                    return DeleteDialog(deleateMsg);
                                  }).then((onValue) {
                                    if (onValue) deleteMAllergeneReaction(snapshot.data[i].id);
                                  });
                                },
                                leading: Stack( alignment: Alignment.center,
                                    children: <Widget>[
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.amberAccent,
                                          shape: BoxShape.circle,
                                        ),
                                        width: 50,
                                      ),
                                      Text(snapshot.data[i].id.toString()),
                                    ]),

                                title: Text(molecularAllergeneListHash[snapshot.data[i].molecularAllergeneID]),
                                subtitle: Text(reactionListHash[snapshot.data[i].reactionID]),
                                trailing:

                                GestureDetector(
                                  onTap: () {
                                    showDialog(context: context, builder: (context) {
                                      return DeleteDialog(deleateMsg);
                                    }).then((onValue) {
                                      if (onValue) deleteMAllergeneReaction(snapshot.data[i].id);
                                    });
                                  },
                                  child: Container(
                                    child: Icon(Icons.clear),
                                  ),
                                ),
                              ));
                        });
                  } else {
                    return ListView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                    );
                  }
                })),
        Align(
            alignment: Alignment.bottomRight,
            child: Container(
              margin: EdgeInsets.all(10),
              child: FloatingActionButton(
                tooltip: 'New Reaction / Molecular Allergene Link',
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return ReactionToMolecularAllergeneDialog(null, molecularAllergeneList, reactionList);
                      }).then((onValue) {newMAllergeneReaction(onValue);});
                }
                ,
                child: Icon(Icons.add),
              ),
            )),
      ],
    );
  }











  Future<List<MAllergeneReaction>> refreshMAllergeneReaction() async {
    setState(() {mAllergeneReactionList = dbHelper.getReactionToMolecularAllergeneList();});
    return mAllergeneReactionList;
  }

  void deleteMAllergeneReaction(int index) async {
    bool success = await dbHelper.deleteReactionToMolecularAllergene(index) > 0; // if deleted something
    if (success) refreshMAllergeneReaction();

    UiTools.newSnackBar(
        success?'Reaction / mollecular allergene link deleted successfully':'Error while deleting the reaction / mollecular allergene link',
        success?Colors.green:Colors.redAccent, 1, context);
  }


  void newMAllergeneReaction(MAllergeneReaction returnedValue) async {
    if (returnedValue != null){
      bool isEdit = returnedValue.id != 0;

      int id = isEdit ?
      await dbHelper.updateReactionToMolecularAllergene(returnedValue.toJson()):
      await dbHelper.insertReactionToMolecularAllergene(returnedValue.toJsonNoId());

      bool success = id>0;
      if(success) refreshMAllergeneReaction();

      UiTools.newSnackBar(
          success?(isEdit?'Reaction / mollecular allergene link edited successfully':'Reaction / mollecular allergene link created successfully'):
          (isEdit?'Error while editing the reaction / mollecular allergene link':'Error while creating the reaction / mollecular allergene link'),
          success?Colors.green:Colors.redAccent, 1, context);
    }
  }



}