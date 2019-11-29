import '../../Beings/MolecularFamily.dart';
import '../../Pages/Dialogs/ColorPickerDialog.dart';
import '../../Pages/Dialogs/DeleteDialog.dart';
import '../../Pages/Dialogs/MolecularFamilyDialog.dart';
import '../../Tools/UiTools.dart';
import '../../Tools/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class MolecularFamiliesTab extends StatefulWidget {
  //var setTabTitle;
  //MolecularFamiliesTab({this.setTabTitle});
  @override
  _MolecularFamiliesTabState createState() => _MolecularFamiliesTabState();
}

class _MolecularFamiliesTabState extends State<MolecularFamiliesTab> {
  Future<List<MolecularFamily>> molecularFamilyList;
  //var setTabTitle;

  final dbHelper = DatabaseHelper.instance;
  final String deleateMsg = 'Are you sure you want to deleate this molecular family ?';

  //_MolecularFamiliesTabState(this.setTabTitle);


  @override
  Widget build(BuildContext context) {

    //print('Mollecular families Tab');
    //setTabTitle('Allergene Tab');

    return Stack(
      children: <Widget>[
        SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 80),
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
                                      print(onValue);
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
                                          Text(snapshot.data[i].id.toString()),
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
                tooltip: 'New Molecular Family',
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
        success?'Molecular family deleted successfully':'Error while deleting the molecular family',
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
          success?(isEdit?'Molecular family edited successfully':'Molecular family created successfully'):
          (isEdit?'Error while editing the molecular family':'Error while creating the molecular family'),
          success?Colors.green:Colors.redAccent, 1, context);
    }
  }

  void updateMolecularFamilyColor(MolecularFamily tempValue, String color){ /** This should be optimised **/
    tempValue.color = color;
    dbHelper.updateMolecularFamily(tempValue.toJson());
    refreshMolecularFamilyList();
  }




}