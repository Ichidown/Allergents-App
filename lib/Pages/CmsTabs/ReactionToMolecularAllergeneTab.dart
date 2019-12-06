import 'dart:collection';
import 'package:allergensapp/Widgets/TabTitleBar.dart';
import '../../Beings/MAllergenReaction.dart';
import '../../Beings/MolecularAllergen.dart';
import '../../Beings/Reaction.dart';
import '../../Pages/Dialogs/DeleteDialog.dart';
import '../../Pages/Dialogs/ReactionToMolecularAllergeneDialog.dart';
import '../../Tools/UiTools.dart';
import '../../Tools/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ReactionToMolecularAllergeneTab extends StatefulWidget {
  @override
  _ReactionToMolecularAllergeneTabState createState() => _ReactionToMolecularAllergeneTabState();
}

class _ReactionToMolecularAllergeneTabState extends State<ReactionToMolecularAllergeneTab> {
  Future<List<Reaction>> reactionList;
  Future<List<MolecularAllergen>> molecularAllergeneList;
  Future<List<MAllergenReaction>> mAllergeneReactionList;
  HashMap reactionListHash = new HashMap();
  HashMap molecularAllergeneListHash = new HashMap();
  final dbHelper = DatabaseHelper.instance;




  final String deleateMsg = 'Êtes-vous sûr de vouloir supprimer cette réaction ?';
  final String title = "Liste des liens de l'allergène moléculaire / réaction";

  final String newItemMsg = 'Nouveau lien réaction / allergène moléculaire';
  final String deleteSuccessfulMsg = 'Le lien réaction / allergène moléculaire a été supprimé avec succès';
  final String deleteFailedMsg = 'Erreur lors de la suppression du lien réaction / allergène moléculaire';
  final String editSuccessfulMsg = 'Lien réaction / allergène moléculaire modifié avec succès';
  final String insertSuccessfulMsg = 'Lien réaction / allergène moléculaire créé avec succès';
  final String editFailedMsg = "Erreur lors de la modification du lien réaction / allergène moléculaire";
  final String insertFailedMsg = 'Erreur lors de la création du lien réaction / allergène moléculaire';






  @override
  void initState() {
    reactionList = dbHelper.getReactions();
    molecularAllergeneList = dbHelper.getMolecularAllergens();

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
                snapshot.data.forEach((element) => reactionListHash[element.id]=element.adaptedTreatment);
              return Container();
            }),
    /** Initialise molecular Allergene List HashMap */
        FutureBuilder<List<MolecularAllergen>>(
            future: molecularAllergeneList,
            builder: (context, snapshot) {
              if(snapshot.hasData)
                snapshot.data.forEach((element) => molecularAllergeneListHash[element.id]=element.name);
              return Container();
            }),



        SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(0, 40, 0, 80),
            child: FutureBuilder<List<MAllergenReaction>>(
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
                                          color: Colors.grey[200],
                                          shape: BoxShape.circle,
                                        ),
                                        width: 50,
                                      ),
                                      Text(snapshot.data[i].id.toString(),),
                                    ]),

                                title: Text(molecularAllergeneListHash[snapshot.data[i].molecularAllergenID]),
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
                    return Center(child: SizedBox(width: 100,height: 100,child: CircularProgressIndicator(),),);
                  }
                })),

        TabTitleBar(title),

        Align(
            alignment: Alignment.bottomRight,
            child: Container(
              margin: EdgeInsets.all(10),
              child: FloatingActionButton(
                tooltip: newItemMsg,
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











  Future<List<MAllergenReaction>> refreshMAllergeneReaction() async {
    setState(() {mAllergeneReactionList = dbHelper.getReactionToMolecularAllergeneList();});
    return mAllergeneReactionList;
  }

  void deleteMAllergeneReaction(int index) async {
    bool success = await dbHelper.deleteReactionToMolecularAllergene(index) > 0; // if deleted something
    if (success) refreshMAllergeneReaction();

    UiTools.newSnackBar(
        success?deleteSuccessfulMsg:deleteFailedMsg,
        success?Colors.green:Colors.redAccent, 1, context);
  }


  void newMAllergeneReaction(MAllergenReaction returnedValue) async {
    if (returnedValue != null){
      bool isEdit = returnedValue.id != 0;

      int id = isEdit ?
      await dbHelper.updateReactionToMolecularAllergene(returnedValue.toJson()):
      await dbHelper.insertReactionToMolecularAllergene(returnedValue.toJsonNoId());

      bool success = id>0;
      if(success) refreshMAllergeneReaction();

      UiTools.newSnackBar(
          success?(isEdit?editSuccessfulMsg:insertSuccessfulMsg):
          (isEdit?editFailedMsg:insertFailedMsg),
          success?Colors.green:Colors.redAccent, 1, context);
    }
  }



}