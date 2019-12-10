import 'dart:collection';

import 'package:allergensapp/Beings/MolecularAllergen.dart';
import 'package:allergensapp/Widgets/TabTitleBar.dart';

import '../../Beings/Allergen.dart';
import '../../Beings/MFamilyAllergen.dart';
import '../../Beings/MolecularFamily.dart';
import '../../Pages/Dialogs/DeleteDialog.dart';
import '../../Pages/Dialogs/MolecularFamilyToAllergeneDialog.dart';
import '../../Tools/UiTools.dart';
import '../../Tools/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MolecularFamilyToAllergeneTab extends StatefulWidget {
  @override
  _MolecularFamilyToAllergeneTabState createState() => _MolecularFamilyToAllergeneTabState();
}

class _MolecularFamilyToAllergeneTabState extends State<MolecularFamilyToAllergeneTab> {
  Future<List<Allergen>> allergeneList;
  Future<List<MolecularFamily>> molecularFamilyList;
  //Future<List<MolecularAllergen>> molecularAllergenList;
  Future<List<MFamilyAllergen>> mFamilyAllergeneList;
  HashMap molecularFamilyListHash = new HashMap();
  HashMap allergeneListHash = new HashMap();
  final dbHelper = DatabaseHelper.instance;




  final String deleteMsg = 'Êtes-vous sûr de vouloir supprimer ce lien Famille moléculaire / Allergène ?';

  final String newItemMsg = 'Nouveau lien famille / allergènes moléculaires';
  final String deleteSuccessfulMsg = 'Le lien Famille moléculaire / Allergène a été supprimé avec succès';
  final String deleteFailedMsg = 'Erreur lors de la suppression du lien Famille moléculaire / Allergène';
  final String editSuccessfulMsg = 'Le lien Famille moléculaire / Allergène a été édité avec succès';
  final String insertSuccessfulMsg = 'Lien Molecular Family / Allergene créé avec succès';
  final String editFailedMsg = 'Erreur lors de la modification du lien Famille moléculaire / Allergène';
  final String insertFailedMsg = 'Erreur lors de la création du lien famille moléculaire / allergène';


  final String title = 'Liste de liens familles moléculaires / Allergènes';

  @override
  void initState() {
    allergeneList = dbHelper.getAllergens();
    molecularFamilyList = dbHelper.getMolecularFamilies();

    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return Stack(
      children: <Widget>[

        /** Initialise allergene List HashMap */
        FutureBuilder<List<Allergen>>(
            future: allergeneList,
            builder: (context, snapshot) {
              if(snapshot.hasData)
                snapshot.data.forEach((element) => allergeneListHash[element.id]=element.name);
              return Container();
            }),
        /** Initialise molecular Family List HashMap */
        FutureBuilder<List<MolecularFamily>>(
            future: molecularFamilyList,
            builder: (context, snapshot) {
              if(snapshot.hasData)
                snapshot.data.forEach((element) => molecularFamilyListHash[element.id]=element.name);
              return Container();
            }),

        SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(0, 40, 0, 80),
            child: FutureBuilder<List<MFamilyAllergen>>(
                future: refreshMFamilyAllergen(),
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
                                        return MolecularFamilyToAllergeneDialog(snapshot.data[i], allergeneList, molecularFamilyList);
                                      }).then((val) {if(val!=null)newMFamilyAllergen(val/*[0]*/ /**,val[1],val[2]*/);});
                                },
                                onLongPress: () {
                                  showDialog(context: context, builder: (context) {
                                    return DeleteDialog(deleteMsg);
                                  }).then((onValue) {
                                    if (onValue) deleteMFamilyAllergen(snapshot.data[i].id);
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
                                      Text(snapshot.data[i].id.toString()),
                                    ]),

                                title: Text('${allergeneListHash[snapshot.data[i].allergenID1]} + ${allergeneListHash[snapshot.data[i].allergenID2]}'),
                                subtitle: Text("${molecularFamilyListHash[snapshot.data[i].molecularFamilyID]}  (${snapshot.data[i].occurrenceFrequency==-1?'Unknown':snapshot.data[i].occurrenceFrequency}%)"),
                                trailing:

                                GestureDetector(
                                  onTap: () {
                                    showDialog(context: context, builder: (context) {
                                      return DeleteDialog(deleteMsg);
                                    }).then((onValue) {
                                      if (onValue) deleteMFamilyAllergen(snapshot.data[i].id);
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
                        return MolecularFamilyToAllergeneDialog(null, allergeneList, molecularFamilyList);
                      }).then((mFamilyAllergen/**,molecularAllergenList,selectedMolecularAllergenList*/) {newMFamilyAllergen(mFamilyAllergen/**,molecularAllergenList,selectedMolecularAllergenList*/);});
                }
                ,
                child: Icon(Icons.add),
              ),
            )),
      ],
    );
  }











  Future<List<MFamilyAllergen>> refreshMFamilyAllergen() async {
    setState(() {mFamilyAllergeneList = dbHelper.getMolecularFamilyToAllergeneList();});
    return mFamilyAllergeneList;
  }

  void deleteMFamilyAllergen(int index) async {
    bool success = await dbHelper.deleteMolecularFamilyToAllergen(index) > 0; // if deleted something
    if (success) refreshMFamilyAllergen();

    UiTools.newSnackBar(
        success?deleteSuccessfulMsg:deleteFailedMsg,
        success?Colors.green:Colors.redAccent, 1, context);
  }


  void newMFamilyAllergen(MFamilyAllergen returnedValue, /*List<int> molecularAllergenIdList, List<bool> choiceList*/) async {
    if (returnedValue != null){
      bool isEdit = returnedValue.id != 0;

      int id = isEdit ?
      await dbHelper.updateMolecularFamilyToAllergen(returnedValue.toJson()):
      await dbHelper.insertMolecularFamilyToAllergen(returnedValue.toJsonNoId());


      bool success = id>0;
      if(success) {
        /**List<int> idList = []; // id of chosen allergen list
        for(int i=0;i<molecularAllergenIdList.length;i++){
          if(choiceList[i]) idList.add(molecularAllergenIdList[i]);
        }
        dbHelper.updateSource1Source2MfMaLinkList(id, idList);*/
        refreshMFamilyAllergen();
      }

        UiTools.newSnackBar(
            success?(isEdit?editSuccessfulMsg:insertSuccessfulMsg):
            (isEdit?editFailedMsg:insertFailedMsg),
            success?Colors.green:Colors.redAccent, 1, context);
    }

  }



}