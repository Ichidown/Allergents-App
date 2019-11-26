import 'dart:collection';

import 'package:allergensapp/Beings/Allergene.dart';
import 'package:allergensapp/Beings/MFamilyAllergene.dart';
import 'package:allergensapp/Beings/MolecularFamily.dart';
import 'package:allergensapp/Pages/Dialogs/DeleteDialog.dart';
import 'package:allergensapp/Pages/Dialogs/MolecularFamilyToAllergeneDialog.dart';
import 'package:allergensapp/Tools/UiTools.dart';
import 'package:allergensapp/Tools/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MolecularFamilyToAllergeneTab extends StatefulWidget {
  @override
  _MolecularFamilyToAllergeneTabState createState() => _MolecularFamilyToAllergeneTabState();
}

class _MolecularFamilyToAllergeneTabState extends State<MolecularFamilyToAllergeneTab> {
  Future<List<Allergene>> allergeneList;
  Future<List<MolecularFamily>> molecularFamilyList;
  Future<List<MFamilyAllergene>> mFamilyAllergeneList;
  HashMap molecularFamilyListHash = new HashMap();
  HashMap allergeneListHash = new HashMap();
  final dbHelper = DatabaseHelper.instance;




  final String deleteMsg = 'Are you sure you want to deleate this Molecular Family To Allergene link ?';
  final String newItemMsg = 'New Molecular Family To Allergene link Link';
  final String deleteSuccessfulMsg = 'Molecular Family To Allergene link deleted successfully';
  final String deleteFailedMsg = 'Error while deleting the Molecular Family To Allergene link';
  final String editSuccessfulMsg = 'Molecular Family To Allergene link edited successfully';
  final String insertSuccessfulMsg = 'Molecular Family To Allergene link created successfully';
  final String editFailedMsg = 'Error while editing the Molecular Family To Allergene link';
  final String insertFailedMsg = 'Error while creating the Molecular Family To Allergene link';


  @override
  void initState() {
    allergeneList = dbHelper.getAllergenes();
    molecularFamilyList = dbHelper.getMolecularFamilies();

    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return Stack(
      children: <Widget>[

        /** Initialise allergene List HashMap */
        FutureBuilder<List<Allergene>>(
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
            padding: EdgeInsets.fromLTRB(0, 20, 0, 80),
            child: FutureBuilder<List<MFamilyAllergene>>(
                future: refreshMFamilyAllergene(),
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
                                      }).then((onValue) {newMFamilyAllergene(onValue);});
                                },
                                onLongPress: () {
                                  showDialog(context: context, builder: (context) {
                                    return DeleteDialog(deleteMsg);
                                  }).then((onValue) {
                                    if (onValue) deleteMFamilyAllergene(snapshot.data[i].id);
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

                                title: Text('${allergeneListHash[snapshot.data[i].allergeneID1]} + ${allergeneListHash[snapshot.data[i].allergeneID2]}'),
                                subtitle: Text(molecularFamilyListHash[snapshot.data[i].molecularFamilyID]),
                                trailing:

                                GestureDetector(
                                  onTap: () {
                                    showDialog(context: context, builder: (context) {
                                      return DeleteDialog(deleteMsg);
                                    }).then((onValue) {
                                      if (onValue) deleteMFamilyAllergene(snapshot.data[i].id);
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
                tooltip: newItemMsg,
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return MolecularFamilyToAllergeneDialog(null, allergeneList, molecularFamilyList);
                      }).then((onValue) {newMFamilyAllergene(onValue);});
                }
                ,
                child: Icon(Icons.add),
              ),
            )),
      ],
    );
  }











  Future<List<MFamilyAllergene>> refreshMFamilyAllergene() async {
    setState(() {mFamilyAllergeneList = dbHelper.getMolecularFamilyToAllergeneList();});
    return mFamilyAllergeneList;
  }

  void deleteMFamilyAllergene(int index) async {
    bool success = await dbHelper.deleteMolecularFamilyToAllergene(index) > 0; // if deleted something
    if (success) refreshMFamilyAllergene();

    UiTools.newSnackBar(
        success?deleteSuccessfulMsg:deleteFailedMsg,
        success?Colors.green:Colors.redAccent, 1, context);
  }


  void newMFamilyAllergene(MFamilyAllergene returnedValue) async {
    if (returnedValue != null){
      bool isEdit = returnedValue.id != 0;

      int id = isEdit ?
      await dbHelper.updateMolecularFamilyToAllergene(returnedValue.toJson()):
      await dbHelper.insertMolecularFamilyToAllergene(returnedValue.toJsonNoId());

      bool success = id>0;
      if(success) refreshMFamilyAllergene();

      UiTools.newSnackBar(
          success?(isEdit?editSuccessfulMsg:insertSuccessfulMsg):
          (isEdit?editFailedMsg:insertFailedMsg),
          success?Colors.green:Colors.redAccent, 1, context);
    }
  }



}