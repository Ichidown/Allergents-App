import 'package:allergensapp/Beings/MolecularAllergene.dart';
import 'package:allergensapp/Beings/MolecularFamily.dart';
import 'package:allergensapp/Pages/Dialogs/ColorPickerDialog.dart';
import 'package:allergensapp/Pages/Dialogs/DeleteDialog.dart';
import 'package:allergensapp/Pages/Dialogs/MolecularAllergeneDialog.dart';
import 'package:allergensapp/Tools/UiTools.dart';
import 'package:allergensapp/Tools/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MolecularAllergenesTab extends StatefulWidget {

  @override
  _MolecularAllergenesTabState createState() => _MolecularAllergenesTabState();
}

class _MolecularAllergenesTabState extends State<MolecularAllergenesTab> {
  Future<List<MolecularAllergene>> molecularAllergeneList;
  Future<List<MolecularFamily>> molecularFamilyList;

  final dbHelper = DatabaseHelper.instance;
  final String deleateMsg = 'Are you sure you want to deleate this molecular allergene ?';


  @override
  Widget build(BuildContext context) {

    refreshMolecularFamilyList();

    return Stack(
      children: <Widget>[
        SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 80),
            child: FutureBuilder<List<MolecularAllergene>>(
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
                                      print(onValue);
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
                                          Text(snapshot.data[i].id.toString()),
                                        ])
                                ),
                                title: Text(snapshot.data[i].name),
                                subtitle: Text(snapshot.data[i].molecular_family_id.toString()),
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
                tooltip: 'New Molecular Allergene',
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






  Future<List<MolecularFamily>> refreshMolecularFamilyList() async {
    setState(() {molecularFamilyList = dbHelper.getMolecularFamilies();});
    return molecularFamilyList;
  }


  Future<List<MolecularAllergene>> refreshMolecularAllergeneList() async {
    setState(() {molecularAllergeneList = dbHelper.getMolecularAllergenes();});
    return molecularAllergeneList;
  }

  void deleteMolecularAllergene(int index) async {
    bool success = await dbHelper.deleteMolecularAllergene(index) > 0; // if deleted something
    if (success) refreshMolecularAllergeneList();

    UiTools.newSnackBar(
        success?'Molecular allergene deleted successfully':'Error while deleting the molecular allergene',
        success?Colors.green:Colors.redAccent, 1, context);
  }


  void newMolecularAllergene(MolecularAllergene returnedValue) async {
    if (returnedValue != null){
      bool isEdit = returnedValue.id != 0;

      int id = isEdit ? await dbHelper.updateMolecularAllergene(returnedValue.toJson()):
                        await dbHelper.insertMolecularAllergene(returnedValue.toJsonNoId());

      bool success = id>0;
      if(success) refreshMolecularAllergeneList();

      UiTools.newSnackBar(
          success?(isEdit?'Molecular allergene edited successfully':'Molecular allergene created successfully'):
          (isEdit?'Error while editing the molecular allergene':'Error while creating the molecular allergene'),
          success?Colors.green:Colors.redAccent, 1, context);
    }
  }

  void updateMolecularAllergeneColor(MolecularAllergene tempValue, String color){ /** This should be optimised **/
    tempValue.color = color;
    dbHelper.updateMolecularAllergene(tempValue.toJson());
    refreshMolecularAllergeneList();
  }




}