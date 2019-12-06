import 'dart:collection';
import '../../Widgets/TabTitleBar.dart';
import '../../Beings/MolecularAllergen.dart';
import '../../Beings/MolecularFamily.dart';
import '../../Pages/Dialogs/ColorPickerDialog.dart';
import '../../Pages/Dialogs/DeleteDialog.dart';
import '../../Pages/Dialogs/MolecularAllergeneDialog.dart';
import '../../Tools/UiTools.dart';
import '../../Tools/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MolecularAllergenesTab extends StatefulWidget {

  @override
  _MolecularAllergenesTabState createState() => _MolecularAllergenesTabState();
}

class _MolecularAllergenesTabState extends State<MolecularAllergenesTab> {
  Future<List<MolecularAllergen>> molecularAllergeneList;
  Future<List<MolecularFamily>> molecularFamilyList;
  HashMap mAllergeneListHash = new HashMap();

  final dbHelper = DatabaseHelper.instance;
  final String deleateMsg = 'Êtes-vous sûr de vouloir supprimer cet allergène moléculaire ?';
  final String title = 'Liste des allergènes moléculaires';

  final String newItemMsg = 'Nouvel allergène moléculaire';
  final String deleteSuccessfulMsg = 'Allergène moléculaire supprimé avec succès';
  final String deleteFailedMsg = "Erreur lors de la suppression de l'allergène moléculaire";
  final String editSuccessfulMsg = 'Allergène moléculaire édité avec succès';
  final String insertSuccessfulMsg = 'Allergène moléculaire créé avec succès';
  final String editFailedMsg = "Erreur lors de l'édition de l'allergène moléculaire";
  final String insertFailedMsg = "Erreur lors de la création de l'allergène moléculaire";



  @override
  void initState() {
    setState(() {molecularFamilyList = dbHelper.getMolecularFamilies();});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Stack(
      children: <Widget>[

        /** Initialise molecular Family List HashMap */
        FutureBuilder<List<MolecularFamily>>(
            future: molecularFamilyList,
            builder: (context, snapshot) {
              if(snapshot.hasData)
                snapshot.data.forEach((element) => mAllergeneListHash[element.id]=element.name);
              return Container();
            }),

        SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(0, 40, 0, 80),
            child: FutureBuilder<List<MolecularAllergen>>(
                future: refreshMolecularAllergeneList(),
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
                                        return MolecularAllergeneDialog(snapshot.data[i],molecularFamilyList);
                                      }).then((onValue) {newMolecularAllergene(onValue);});
                                },
                                onLongPress: () {
                                  showDialog(context: context, builder: (context) {
                                    return DeleteDialog(deleateMsg);
                                  }).then((onValue) {
                                    if (onValue) deleteMolecularAllergene(snapshot.data[i].id);
                                  });
                                },
                                leading: GestureDetector(onTap: (){
                                  showDialog(context: context, builder: (context) {
                                    return ColorPickerDialog();
                                  }).then((onValue) {
                                    if (onValue != null){
                                      updateMolecularAllergeneColor(snapshot.data[i] ,onValue);
                                    }
                                  });
                                },
                                    child: Stack(
                                        alignment: Alignment.center,
                                        children: <Widget>[
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Color(int.parse(snapshot.data[i].color)),
                                              shape: BoxShape.circle,
                                            ),
                                            width: 50,
                                          ),
                                          Text(snapshot.data[i].id.toString(),style: TextStyle(color: Colors.white)),
                                        ])
                                ),
                                title: Text(snapshot.data[i].name),
                                subtitle: Text(mAllergeneListHash[snapshot.data[i].molecularFamilyId]),
                                trailing:

                                GestureDetector(
                                  onTap: () {
                                    showDialog(context: context, builder: (context) {
                                      return DeleteDialog(deleateMsg);
                                    }).then((onValue) {
                                      if (onValue) deleteMolecularAllergene(snapshot.data[i].id);
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
                        return MolecularAllergeneDialog(null,molecularFamilyList);
                      }).then((onValue) {newMolecularAllergene(onValue);});
                }
                ,
                child: Icon(Icons.add),
              ),
            )),
      ],
    );
  }


  Future<List<MolecularAllergen>> refreshMolecularAllergeneList() async {
    setState(() {molecularAllergeneList = dbHelper.getMolecularAllergens();});
    return molecularAllergeneList;
  }

  void deleteMolecularAllergene(int index) async {
    bool success = await dbHelper.deleteMolecularAllergen(index) > 0; // if deleted something
    if (success) refreshMolecularAllergeneList();

    UiTools.newSnackBar(
        success?deleteSuccessfulMsg:deleteFailedMsg,
        success?Colors.green:Colors.redAccent, 1, context);
  }


  void newMolecularAllergene(MolecularAllergen returnedValue) async {
    if (returnedValue != null){
      bool isEdit = returnedValue.id != 0;

      int id = isEdit ? await dbHelper.updateMolecularAllergen(returnedValue.toJson()):
                        await dbHelper.insertMolecularAllergen(returnedValue.toJsonNoId());

      bool success = id>0;
      if(success) refreshMolecularAllergeneList();

      UiTools.newSnackBar(
          success?(isEdit?editSuccessfulMsg:insertSuccessfulMsg):
          (isEdit?editFailedMsg:insertFailedMsg),
          success?Colors.green:Colors.redAccent, 1, context);
    }
  }

  void updateMolecularAllergeneColor(MolecularAllergen tempValue, String color){ /** This should be optimised **/
    tempValue.color = color;
    dbHelper.updateMolecularAllergen(tempValue.toJson());
    refreshMolecularAllergeneList();
  }




}