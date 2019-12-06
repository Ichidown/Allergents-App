import 'package:allergensapp/Widgets/TabTitleBar.dart';
import '../../Beings/MolecularFamily.dart';
import '../../Pages/Dialogs/ColorPickerDialog.dart';
import '../../Pages/Dialogs/DeleteDialog.dart';
import '../../Pages/Dialogs/MolecularFamilyDialog.dart';
import '../../Tools/UiTools.dart';
import '../../Tools/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MolecularFamiliesTab extends StatefulWidget {
  @override
  _MolecularFamiliesTabState createState() => _MolecularFamiliesTabState();
}

class _MolecularFamiliesTabState extends State<MolecularFamiliesTab> {
  Future<List<MolecularFamily>> molecularFamilyList;

  final dbHelper = DatabaseHelper.instance;
  final String deleateMsg = "Êtes-vous sûr de vouloir supprimer cette famille moléculaire?";
  final String title = "Liste de famille moléculaire";

  final String newItemMsg = 'Nouvelle famille moléculaire';
  final String deleteSuccessfulMsg = 'Famille moléculaire supprimée avec succès';
  final String deleteFailedMsg = 'Erreur lors de la suppression de la famille moléculaire';
  final String editSuccessfulMsg = 'Famille moléculaire modifiée avec succès';
  final String insertSuccessfulMsg = 'Famille moléculaire créée avec succès';
  final String editFailedMsg = "Erreur lors de l'édition de la famille moléculaire";
  final String insertFailedMsg = 'Erreur lors de la création de la famille moléculaire';



  @override
  Widget build(BuildContext context) {

    return Stack(
      children: <Widget>[

        SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(0, 40, 0, 80),
            child: FutureBuilder<List<MolecularFamily>>(
                future: refreshMolecularFamilyList(),
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
                                        return MolecularFamilyDialog(snapshot.data[i]);
                                      }).then((onValue) {newMolecularFamily(onValue);});
                                },
                                onLongPress: () {
                                  showDialog(context: context, builder: (context) {
                                    return DeleteDialog(deleateMsg);
                                  }).then((onValue) {
                                    if (onValue) deleteMolecularFamily(snapshot.data[i].id);
                                  });
                                },
                                leading: GestureDetector(onTap: (){
                                  showDialog(context: context, builder: (context) {
                                    return ColorPickerDialog();
                                  }).then((onValue) {
                                    if (onValue != null){
                                      updateMolecularFamilyColor(snapshot.data[i] ,onValue);
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

                                trailing:

                                GestureDetector(
                                  onTap: () {
                                    showDialog(context: context, builder: (context) {
                                      return DeleteDialog(deleateMsg);
                                    }).then((onValue) {
                                      if (onValue) deleteMolecularFamily(snapshot.data[i].id);
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
                        return MolecularFamilyDialog(null);
                      }).then((onValue) {newMolecularFamily(onValue);});
                }
                ,
                child: Icon(Icons.add),
              ),
            )),
      ],
    );
  }











  Future<List<MolecularFamily>> refreshMolecularFamilyList() async {
    setState(() {molecularFamilyList = dbHelper.getMolecularFamilies();});
    return molecularFamilyList;
  }

  void deleteMolecularFamily(int index) async {
    bool success = await dbHelper.deleteMolecularFamily(index) > 0; // if deleted something
    if (success) refreshMolecularFamilyList();

    UiTools.newSnackBar(
        success?deleteSuccessfulMsg:deleteFailedMsg,
        success?Colors.green:Colors.redAccent, 1, context);
  }


  void newMolecularFamily(MolecularFamily returnedValue) async {
    if (returnedValue != null){
      bool isEdit = returnedValue.id != 0;

      int id = isEdit ? await dbHelper.updateMolecularFamily(returnedValue.toJson()):
      await dbHelper.insertMolecularFamily(returnedValue.toJsonNoId());

      bool success = id>0;
      if(success) refreshMolecularFamilyList();

      UiTools.newSnackBar(
          success?(isEdit?editSuccessfulMsg:insertSuccessfulMsg):
          (isEdit?editFailedMsg:insertFailedMsg),
          success?Colors.green:Colors.redAccent, 1, context);
    }
  }

  void updateMolecularFamilyColor(MolecularFamily tempValue, String color){ /** This should be optimised **/
    tempValue.color = color;
    dbHelper.updateMolecularFamily(tempValue.toJson());
    refreshMolecularFamilyList();
  }




}